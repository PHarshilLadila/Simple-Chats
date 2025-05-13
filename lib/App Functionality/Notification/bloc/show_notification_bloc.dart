import 'package:chat_app_bloc/App%20Functionality/Notification/bloc/show_notification_event.dart';
import 'package:chat_app_bloc/App%20Functionality/Notification/bloc/show_notification_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  NotificationBloc() : super(NotificationInitial()) {
    on<LoadNotifications>(_loadNotifications);
    // on<ClearNotification>(clearNotification);
    add(LoadNotifications());
  }

  List<Map<String, dynamic>> notificationData = [];

  Future<void> _loadNotifications(
      LoadNotifications event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());

    try {
      String? currentUserId = auth.currentUser?.uid;
      if (currentUserId == null) {
        emit(NotificationError("User not logged in"));
        return;
      }

      // Fetch notifications for the current user across all chat IDs
      QuerySnapshot querySnapshot = await firestore
          .collectionGroup(
              "chats") // <-- Searches across ALL chat subcollections
          .where("receiverId", isEqualTo: currentUserId)
          .orderBy("timestamp", descending: true)
          .get();

      List<Map<String, dynamic>> notifications = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      notificationData = notifications;

      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError("Failed to load notifications: $e"));
    }
  }

  // void clearNotification(
  //     ClearNotification event, Emitter<NotificationState> emit) {
  //   emit(NotificationLoading());
  //   String chatid =
  //       notificationData.isNotEmpty ? notificationData[0]["chatId"] : "";

  //   try {
  //     FirebaseFirestore.instance
  //         .collection('chatroom')
  //         .doc(chatid)
  //         .collection("chats")
  //         .get()
  //         .then((snapshot) {
  //       for (DocumentSnapshot snapShot in snapshot.docs) {
  //         snapShot.reference.delete();
  //       }
  //     });
  //   } catch (e) {
  //     emit(NotificationError(e.toString()));
  //   }
  // }
}
