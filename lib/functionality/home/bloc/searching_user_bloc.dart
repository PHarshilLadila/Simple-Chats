import 'package:chat_app_bloc/functionality/home/model/searched_user_model.dart';
import 'package:chat_app_bloc/service/send_notification.dart';
import 'package:chat_app_bloc/utils/constent/app_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'searching_user_event.dart';
import 'searching_user_state.dart';

class SearchingUserBloc extends Bloc<SearchingUserEvent, SearchingUserState> {
  final FirebaseFirestore firestore;
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final SendNotification sendNotification = SendNotification();

  SearchingUserBloc(this.firestore) : super(SearchingUserInitial()) {
    on<SearchingUsers>(_onSearchingUsers);
    on<LoadAllUsers>(_onLoadAllUsers);
  }

  Future<void> _onSearchingUsers(
      SearchingUsers event, Emitter<SearchingUserState> emit) async {
    emit(SearchingUserLoading());
    try {
      List<SearchedUserModel> users =
          await _retrieveSearchableUserData(event.query);

      // Sort users by last message time (most recent first)
      users.sort((a, b) {
        if (a.lastMessageTime == null && b.lastMessageTime == null) return 0;
        if (a.lastMessageTime == null) return 1;
        if (b.lastMessageTime == null) return -1;
        return b.lastMessageTime!.compareTo(a.lastMessageTime!);
      });

      emit(users.isEmpty
          ? SearchingUserError("No users found.")
          : SearchingUserLoaded(users, const []));
    } catch (e) {
      emit(SearchingUserError(e.toString()));
    }
  }

  Future<void> _onLoadAllUsers(
      LoadAllUsers event, Emitter<SearchingUserState> emit) async {
    emit(SearchingUserLoading());
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? currentUser = auth.currentUser;
      final currentUserUID = currentUser?.uid;

      // Get current user's name for chatId generation
      DocumentSnapshot? currentUserDoc;
      String? currentUserName;
      if (currentUserUID != null) {
        currentUserDoc =
            await firestore.collection('users').doc(currentUserUID).get();
        currentUserName = currentUserDoc['name'];
      }

      QuerySnapshot querySnapshot = await firestore.collection('users').get();
      List<SearchedUserModel?> users =
          await Future.wait(querySnapshot.docs.map((doc) async {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Skip current user
        if (currentUserUID == doc.id) {
          debugPrint('Skipping current user $currentUserUID');
          return null;
        }

        String? fcmToken = data['fcmToken'] ?? "N/A";
        if (fcmToken == "N/A") {
          fcmToken = await messaging.getToken();
          if (fcmToken != null) {
            await firestore
                .collection('users')
                .doc(doc.id)
                .update({'fcmToken': fcmToken});
          }
        }

        String? profileImg = data['profile'] ?? "N/A";
        if (profileImg == "N/A") {
          profileImg = await messaging.getToken();
          if (profileImg != null) {
            await firestore
                .collection('users')
                .doc(doc.id)
                .update({'profileImg': profileImg});
          }
        }

        // Generate chatId
        String chatId =
            _generateChatId(currentUserName ?? "", data['name'] ?? "");

        // Fetch last message time and unread count
        DateTime? lastMessageTime;
        int unreadCount = 0;

        try {
          // Get last message
          QuerySnapshot messagesSnapshot = await firestore
              .collection('chatroom')
              .doc(chatId)
              .collection('chats')
              .orderBy('time', descending: true)
              .limit(1)
              .get();

          if (messagesSnapshot.docs.isNotEmpty) {
            var lastMessage = messagesSnapshot.docs.first;
            lastMessageTime = (lastMessage['time'] as Timestamp).toDate();
          }

          // Get unread count (messages sent by the other user that haven't been read)
          QuerySnapshot unreadSnapshot = await firestore
              .collection('chatroom')
              .doc(chatId)
              .collection('chats')
              .where('senderUid', isEqualTo: doc.id)
              .where('isRead', isEqualTo: false)
              .get();

          unreadCount = unreadSnapshot.docs.length;
        } catch (e) {
          debugPrint('Error fetching chat data for $chatId: $e');
        }

        return SearchedUserModel(
          id: doc.id,
          email: data['email'] ?? "N/A",
          displayName: data['name'] ?? "N/A",
          mobileNumber: data['mobileNumber'] ?? "N/A",
          receiverFCm: fcmToken ?? "N/A",
          profileImage: data["profile"] ?? AppString.demoImgurl,
          lastMessageTime: lastMessageTime,
          unreadCount: unreadCount,
        );
      }).toList());

      // Remove null values (current user)
      List<SearchedUserModel> filteredUsers =
          users.whereType<SearchedUserModel>().toList();

      // Sort users by last message time (most recent first)
      filteredUsers.sort((a, b) {
        if (a.lastMessageTime == null && b.lastMessageTime == null) return 0;
        if (a.lastMessageTime == null) return 1;
        if (b.lastMessageTime == null) return -1;
        return b.lastMessageTime!.compareTo(a.lastMessageTime!);
      });

      emit(SearchingUserLoaded(filteredUsers, const []));
    } catch (e) {
      emit(SearchingUserError(e.toString()));
    }
  }

  String _generateChatId(String user1, String user2) {
    if (user1.isEmpty || user2.isEmpty) {
      return "";
    }
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  Future<List<SearchedUserModel>> _retrieveSearchableUserData(
      String query) async {
    List<SearchedUserModel> users = [];

    if (query.isNotEmpty) {
      // Search by name
      QuerySnapshot nameQuerySnapshot = await firestore
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: query.trim())
          .where('name', isLessThanOrEqualTo: '${query.trim()}\uf8ff')
          .get();
      users.addAll(await _mapQueryToUsers(nameQuerySnapshot));

      // Search by mobile number
      QuerySnapshot mobileNumberQuerySnapshot = await firestore
          .collection('users')
          .where('mobileNumber', isEqualTo: query.trim())
          .get();
      users.addAll(await _mapQueryToUsers(mobileNumberQuerySnapshot));

      // Search by email
      QuerySnapshot emailQuerySnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: query.trim())
          .get();
      users.addAll(await _mapQueryToUsers(emailQuerySnapshot));

      users = users.toSet().toList();
    }

    return users;
  }

  Future<List<SearchedUserModel>> _mapQueryToUsers(
      QuerySnapshot querySnapshot) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? currentUser = auth.currentUser;
    final currentUserUID = currentUser?.uid;

    // Get current user's name for chatId generation
    String? currentUserName;
    if (currentUserUID != null) {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(currentUserUID).get();
      currentUserName = userDoc['name'];
    }

    return Future.wait(querySnapshot.docs
        .where((doc) => doc.id != currentUserUID)
        .map((doc) async {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      String? fcmToken = data['fcmToken'] ?? "N/A";
      if (fcmToken == "N/A") {
        fcmToken = await messaging.getToken();
        if (fcmToken != null) {
          await firestore
              .collection('users')
              .doc(doc.id)
              .update({'fcmToken': fcmToken});
        }
      }

      String? profileImg = data['profile'] ?? "N/A";
      if (profileImg == "N/A") {
        profileImg = await messaging.getToken();
        if (profileImg != null) {
          await firestore
              .collection('users')
              .doc(doc.id)
              .update({'profileImg': profileImg});
        }
      }

      // Generate chatId
      String chatId =
          _generateChatId(currentUserName ?? "", data['name'] ?? "");

      // Fetch last message time and unread count
      DateTime? lastMessageTime;
      int unreadCount = 0;

      try {
        // Get last message
        QuerySnapshot messagesSnapshot = await firestore
            .collection('chatroom')
            .doc(chatId)
            .collection('chats')
            .orderBy('time', descending: true)
            .limit(1)
            .get();

        if (messagesSnapshot.docs.isNotEmpty) {
          var lastMessage = messagesSnapshot.docs.first;
          if (lastMessage['time'] != null) {
            lastMessageTime = (lastMessage['time'] as Timestamp).toDate();
          }
        }

        // Get unread count
        QuerySnapshot unreadSnapshot = await firestore
            .collection('chatroom')
            .doc(chatId)
            .collection('chats')
            .where('senderUid', isEqualTo: doc.id)
            .where('isRead', isEqualTo: false)
            .get();

        unreadCount = unreadSnapshot.docs.length;
      } catch (e) {
        debugPrint('Error fetching chat data for search $chatId: $e');
      }

      return SearchedUserModel(
        id: doc.id,
        email: data['email'] ?? "N/A",
        displayName: data['name'] ?? "N/A",
        mobileNumber: data['mobileNumber'] ?? "N/A",
        receiverFCm: fcmToken!,
        profileImage: data["profile"] ?? AppString.demoImgurl,
        lastMessageTime: lastMessageTime,
        unreadCount: unreadCount,
      );
    }).toList());
  }
}

 
//   //       users,
//   //       [
//   //         UserModel(
//   //           id: datas['id'],
//   //           email: datas['email'],
//   //           displayName: datas['displayName'],
//   //           mobileNumber: datas['mobileNumber'],
//   //         )
//   //       ],
//   //     ));
//   // String? token = await messaging.getToken();
//   // if (token != null) {
//   //   debugPrint('=> SEND FCM TOKEN TO USER: $token');
//   //   for (var user in users) {
//   //     sendNotification.sendFCMTokenToUser(user.id, token);
//   //   }
//   // }
//   //   } catch (e) {
//   //     emit(SearchingUserError(e.toString()));
//   //   }
//   // }