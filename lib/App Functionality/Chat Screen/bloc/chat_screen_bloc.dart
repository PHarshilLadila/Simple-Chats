import 'dart:async';
import 'package:chat_app_bloc/App%20Functionality/Auth/model/user_model.dart';
import 'package:chat_app_bloc/Service/send_notification.dart';
import 'package:chat_app_bloc/Service/socket_service.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app_bloc/App%20Functionality/Chat%20Screen/bloc/chat_screen_events.dart';
import 'package:chat_app_bloc/App%20Functionality/Chat%20Screen/bloc/chat_screen_state.dart';

class ChatScreenBloc extends Bloc<ChatScreenEvents, ChatScreenState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final String chatId;
  final String currentUserName;
  final String senderName;
  final String receiverName;
  final String senderUid;
  final String receiverUid;
  final String receiverFCMToken;
  late SocketService socketService;
  StreamSubscription? _messageSubscription;

  ChatScreenBloc(
    this.chatId,
    this.currentUserName,
    this.senderName,
    this.receiverName,
    this.senderUid,
    this.receiverUid,
    this.receiverFCMToken,
  ) : super(ChatScreenInitial()) {
    socketService = SocketService();
    socketService.connect(chatId);

    on<Loadmessages>(_loadMessages);
    on<OnSendMessage>(_onSendMessage);
    on<OnSendImage>(_onSendImage);
    on<StartListeningMessages>(_startListeningMessages);
    on<FetchCurrentUserData>(_fetchUserData);
    on<ClearMessages>(clearMessages);
    // on<ShowAllImages>(getAllImages);
    add(FetchCurrentUserData());
    add(Loadmessages());
    add(StartListeningMessages());
    // add(ShowAllImages());
  }
  final SendNotification sendNotification = SendNotification();

  Map<String, dynamic> datas = {};
  String senderFCMToken = "";

  Future<void> _fetchUserData(
    FetchCurrentUserData event,
    Emitter<ChatScreenState> emit,
  ) async {
    UserModel? userModel = await getCurrentUserData(FirebaseAuth.instance);
    if (userModel != null) {
      datas = {
        'id': userModel.id,
        'email': userModel.email,
        'displayName': userModel.displayName,
        'mobileNumber': userModel.mobileNumber,
        'senderFCm': userModel.senderFCm,
      };

      senderFCMToken = datas['senderFCm'];
      debugPrint("=> senderFCM Token : $senderFCMToken");
    }
  }

  Future<UserModel?> getCurrentUserData(dynamic firebaseAuth) async {
    final User? firebaseUser = firebaseAuth.currentUser;
    if (firebaseUser == null) {
      debugPrint("=> No user logged in.");
      return null;
    }
    try {
      debugPrint("=> Fetching user data for UID: ${firebaseUser.uid}");

      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(firebaseUser.uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        debugPrint("=> User data fetched: $userData");

        return UserModel(
          id: firebaseUser.uid,
          email: userData['email'] ?? "N/A",
          displayName: userData['name'] ?? "N/A",
          mobileNumber: userData['mobileNumber'] ?? "N/A",
          senderFCm: userData["fcmToken"] ?? "FCM Token Not Found",
        );
      } else {
        debugPrint("=> User document does not exist!");
      }
    } catch (e) {
      debugPrint("=> Fetch User Data Error: $e");
    }
    return null;
  }

  Future<void> _onSendMessage(
      OnSendMessage event, Emitter<ChatScreenState> emit) async {
    if (event.message.isEmpty) {
      emit(const ChatScreenError("Enter Some Text"));
      return;
    }

    Map<String, dynamic> newMessage = {
      "sendby": currentUserName,
      "message": event.message,
      "time": FieldValue.serverTimestamp(),
      "isImage": false,
    };

    try {
      DocumentReference docRef = await firestore
          .collection("chatroom")
          .doc(chatId)
          .collection("chats")
          .add(newMessage);

      DocumentSnapshot savedMessage = await docRef.get();
      Map<String, dynamic> confirmedMessage =
          savedMessage.data() as Map<String, dynamic>;
      confirmedMessage["time"] =
          (confirmedMessage["time"] as Timestamp).toDate().toIso8601String();
      if (state is ChatScreenLoaded) {
        final updatedMessages = List<Map<String, dynamic>>.from(
            (state as ChatScreenLoaded).messages);
        updatedMessages.add(confirmedMessage);
        emit(ChatScreenLoaded(updatedMessages));
      }

      socketService.sendMessage(
        chatId,
        // senderUid,
        receiverUid,
        confirmedMessage,
      );

      // socketService.listenForMessages((data) {
      //   add(StartListeningMessages());
      // });
      sendNotificationToReceiver(confirmedMessage);
    } catch (e) {
      emit(ChatScreenError("Failed to send message: $e"));
    }
  }

  Future<void> _onSendImage(
      OnSendImage event, Emitter<ChatScreenState> emit) async {
    if (event.images.isEmpty) {
      emit(const ChatScreenError("No Images Selected."));
      return;
    }

    List<String> base64Images = event.images;
    Map<String, dynamic> message = {
      "sendby": currentUserName,
      "message": base64Images,
      "time": FieldValue.serverTimestamp(),
      "isImage": true,
    };

    try {
      await firestore
          .collection("chatroom")
          .doc(chatId)
          .collection("chats")
          .add(message);
      sendNotificationToReceiver(message);

      emit(ChatScreenLoaded([message]));
    } catch (e) {
      emit(ChatScreenError("Failed to send image: $e"));
    }
  }

  Future<void> _loadMessages(
      Loadmessages event, Emitter<ChatScreenState> emit) async {
    emit(ChatScreenLoading());

    try {
      QuerySnapshot querySnapshot = await firestore
          .collection("chatroom")
          .doc(chatId)
          .collection("chats")
          .orderBy("time", descending: false)
          .get();

      List<Map<String, dynamic>> messages = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          ...data,
          "time": (data["time"] is Timestamp) ? data["time"] : Timestamp.now(),
        };
      }).toList();

      emit(ChatScreenLoaded(messages));

      socketService.listenForMessages(
        (data) async {
          debugPrint("=> New Socket.IO Message: $data");
          return messages;
        },
      );
    } catch (e) {
      emit(ChatScreenError("Failed to Load Messages: $e"));
    }
  }

  void _startListeningMessages(
      StartListeningMessages event, Emitter<ChatScreenState> emit) async {
    emit(ChatScreenLoading());

    try {
      await Future.delayed(Duration.zero);

      _messageSubscription = firestore
          .collection("chatroom")
          .doc(chatId)
          .collection("chats")
          .orderBy("time", descending: false)
          .snapshots()
          .listen((snapshot) {
        List<Map<String, dynamic>> messages =
            snapshot.docs.map((doc) => doc.data()).toList();

        debugPrint("=> Firestore Updated Messages: $messages");

        if (!emit.isDone) {
          emit(ChatScreenLoaded(messages));
        }
        socketService.listenForMessages(
          (data) async {
            debugPrint("=> New Socket.IO Message: $data");
            return messages;
          },
        );
      });
    } catch (e) {
      if (!emit.isDone) {
        emit(ChatScreenError("Failed to listen for messages: $e"));
      }
    }
  }

  void sendNotificationToReceiver(Map<String, dynamic> messageData) async {
    final receiverToken = receiverFCMToken;
    debugPrint("=> RECEIVER TOKEN  ===== >> $receiverToken");
    debugPrint("=> RECEIVER UID  ===== >> $receiverUid");
    debugPrint("=> RECEIVER USER NAME  ===== >> $receiverName");

    final notificationData = {
      "receiverId": receiverUid,
      'receiverFCM': receiverToken,
      'senderName': currentUserName,
      'message': messageData['message'],
      'timestamp': FieldValue.serverTimestamp(),
      'chatId': chatId,
      'senderFCM': senderFCMToken,
      'isImage': messageData['isImage'] ?? false,
    };

    debugPrint("=> NOTIFICATION DATA ===== >> $notificationData");
    debugPrint(
        "=> check the message is image or normal message :: ${messageData['isImage'] == true ? "${messageData['message'].length}" : messageData['message']}");

    await firestore
        .collection('notifications')
        .doc(chatId)
        .collection('chats')
        .add(notificationData);

    await sendNotification.sendNotificationToUser(
      // senderFCMToken,
      receiverToken,
      currentUserName,
      notificationData['message'].toString(),
      chatId,
      currentUserName,
      senderName,
      // receiverToken,
      senderFCMToken,
      senderUid,
      receiverUid,
      receiverToken,
    );
    debugPrint("=> SENDER FCM TOKENS === >> $senderFCMToken");
    debugPrint("=> RECEIVER FCM TOKENS === >> $receiverToken");
    debugPrint("=> SENDER NAME === >> $currentUserName");
    debugPrint("=> SENDER MESSAGE === >> ${notificationData['message']}");
  }

  @override
  Future<void> close() {
    socketService.disconnect();
    _messageSubscription?.cancel();
    return super.close();
  }

  void clearMessages(ClearMessages event, Emitter<ChatScreenState> emit) {
    emit(ChatScreenLoading());

    try {
      FirebaseFirestore.instance
          .collection('chatroom')
          .doc(chatId)
          .collection("chats")
          .get()
          .then((snapshot) {
        for (DocumentSnapshot snapShot in snapshot.docs) {
          snapShot.reference.delete();
        }
      });
    } catch (e) {
      emit(ChatScreenError(e.toString()));
    }
  }
}
