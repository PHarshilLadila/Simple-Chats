import 'dart:async';
import 'package:chat_app_bloc/functionality/Auth/model/user_model.dart';
import 'package:chat_app_bloc/functionality/chat_section/bloc/chat_screen_events.dart';
import 'package:chat_app_bloc/functionality/chat_section/bloc/chat_screen_state.dart';
import 'package:chat_app_bloc/service/send_notification.dart';
import 'package:chat_app_bloc/service/socket_service.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    on<ToggleMessageSelection>(_toggleMessageSelection);
    on<ClearMessageSelection>(_clearMessageSelection);
    on<DeleteSelectedMessages>(_deleteSelectedMessages);
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
        'profile': userModel.profileImage,
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
          profileImage: userData["profile"] ?? "",
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

    // Check receiver's online status
    DocumentSnapshot receiverDoc =
        await firestore.collection("users").doc(receiverUid).get();
    bool isReceiverOnline = false;
    if (receiverDoc.exists) {
      isReceiverOnline =
          (receiverDoc.data() as Map<String, dynamic>)['status'] == 'online';
    }

    Map<String, dynamic> newMessage = {
      "sendby": currentUserName,
      "senderUid": senderUid,
      "message": event.message,
      "time": FieldValue.serverTimestamp(),
      "isImage": false,
      "isRead": false,
      "isDelivered": isReceiverOnline,
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
    // Check receiver's online status
    DocumentSnapshot receiverDoc =
        await firestore.collection("users").doc(receiverUid).get();
    bool isReceiverOnline = false;
    if (receiverDoc.exists) {
      isReceiverOnline =
          (receiverDoc.data() as Map<String, dynamic>)['status'] == 'online';
    }

    Map<String, dynamic> message = {
      "sendby": currentUserName,
      "senderUid": senderUid,
      "message": base64Images,
      "time": FieldValue.serverTimestamp(),
      "isImage": true,
      "isRead": false,
      "isDelivered": isReceiverOnline,
    };

    try {
      await firestore
          .collection("chatroom")
          .doc(chatId)
          .collection("chats")
          .add(message);
      sendNotificationToReceiver(message);

      if (state is ChatScreenLoaded) {
        final updatedMessages = List<Map<String, dynamic>>.from(
            (state as ChatScreenLoaded).messages);
        updatedMessages.add(message);
        emit(ChatScreenLoaded(updatedMessages));
      } else {
        emit(ChatScreenLoaded([message]));
      }
    } catch (e) {
      emit(ChatScreenError("Failed to send image: $e"));
    }
  }

  Future<void> _loadMessages(
      Loadmessages event, Emitter<ChatScreenState> emit) async {
    emit(ChatScreenLoading());

    try {
      await _markMessagesAsRead();

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
          "docId": doc.id,
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

  Future<void> _markMessagesAsRead() async {
    try {
      QuerySnapshot unreadMessages = await firestore
          .collection("chatroom")
          .doc(chatId)
          .collection("chats")
          .where("senderUid", isEqualTo: receiverUid)
          .where("isRead", isEqualTo: false)
          .get();

      if (unreadMessages.docs.isNotEmpty) {
        WriteBatch batch = firestore.batch();
        for (var doc in unreadMessages.docs) {
          batch.update(doc.reference, {"isRead": true});
        }
        await batch.commit();
      }
    } catch (e) {
      debugPrint("Error marking messages as read: $e");
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
          .listen((snapshot) async {
        List<Map<String, dynamic>> messages = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            ...data,
            "docId": doc.id,
          };
        }).toList();

        debugPrint("=> Firestore Updated Messages: $messages");

        // Mark messages as delivered if they are for the current user
        bool hasNewUndelivered = snapshot.docs.any((doc) {
          final data = doc.data();
          return data['senderUid'] == receiverUid &&
              data['isDelivered'] == false;
        });

        if (hasNewUndelivered) {
          await _markMessagesAsDelivered();
        }

        // Mark messages as read if they are from the other user
        bool hasNewUnread = snapshot.docs.any((doc) {
          final data = doc.data();
          return data['senderUid'] == receiverUid && data['isRead'] == false;
        });

        if (hasNewUnread) {
          await _markMessagesAsRead();
        }

        if (!emit.isDone) {
          final currentState = state;
          final Set<String> currentSelection = currentState is ChatScreenLoaded
              ? currentState.selectedMessageIds
              : const {};
          emit(
              ChatScreenLoaded(messages, selectedMessageIds: currentSelection));
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

  Future<void> _markMessagesAsDelivered() async {
    try {
      QuerySnapshot undeliveredMessages = await firestore
          .collection("chatroom")
          .doc(chatId)
          .collection("chats")
          .where("senderUid", isEqualTo: receiverUid)
          .where("isDelivered", isEqualTo: false)
          .get();

      if (undeliveredMessages.docs.isNotEmpty) {
        WriteBatch batch = firestore.batch();
        for (var doc in undeliveredMessages.docs) {
          batch.update(doc.reference, {"isDelivered": true});
        }
        await batch.commit();
      }
    } catch (e) {
      debugPrint("Error marking messages as delivered: $e");
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
      'senderUid': senderUid,
      'senderFCM': senderFCMToken,
      'senderProfile': datas['profile'] ?? "",
      'senderEmail': datas['email'] ?? "",
      'senderMobile': datas['mobileNumber'] ?? "",
      'message': messageData['message'],
      'timestamp': FieldValue.serverTimestamp(),
      'chatId': chatId,
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
      messageData['isImage'] == true
          ? "Sent an image"
          : notificationData['message'].toString(),
      chatId,
      currentUserName,
      senderName,
      // receiverToken,
      senderFCMToken,
      senderUid,
      receiverUid,
      receiverToken,
      datas['profile'] ?? "",
      datas['email'] ?? "",
      datas['mobileNumber'] ?? "",
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

  void _toggleMessageSelection(
      ToggleMessageSelection event, Emitter<ChatScreenState> emit) {
    if (state is ChatScreenLoaded) {
      final currentState = state as ChatScreenLoaded;
      final newSelection = Set<String>.from(currentState.selectedMessageIds);

      if (newSelection.contains(event.messageId)) {
        newSelection.remove(event.messageId);
      } else {
        newSelection.add(event.messageId);
      }

      emit(ChatScreenLoaded(currentState.messages,
          selectedMessageIds: newSelection));
    }
  }

  void _clearMessageSelection(
      ClearMessageSelection event, Emitter<ChatScreenState> emit) {
    if (state is ChatScreenLoaded) {
      final currentState = state as ChatScreenLoaded;
      emit(ChatScreenLoaded(currentState.messages,
          selectedMessageIds: const {}));
    }
  }

  Future<void> _deleteSelectedMessages(
      DeleteSelectedMessages event, Emitter<ChatScreenState> emit) async {
    if (state is ChatScreenLoaded) {
      final currentState = state as ChatScreenLoaded;
      final selectedIds = currentState.selectedMessageIds;

      if (selectedIds.isEmpty) return;

      emit(ChatScreenLoading());

      try {
        final WriteBatch batch = firestore.batch();
        final chatRef =
            firestore.collection("chatroom").doc(chatId).collection("chats");

        for (String messageId in selectedIds) {
          batch.delete(chatRef.doc(messageId));
        }

        await batch.commit();

        // The listener in _startListeningMessages will automatically update the UI
        // We just need to clear the selection
      } catch (e) {
        emit(ChatScreenError("Failed to delete messages: $e"));
      }
    }
  }
}
