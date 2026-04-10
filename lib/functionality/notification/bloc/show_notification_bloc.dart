import 'package:chat_app_bloc/functionality/notification/bloc/show_notification_event.dart';
import 'package:chat_app_bloc/functionality/notification/bloc/show_notification_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowNotificationBloc
    extends Bloc<ShowNotificationEvent, ShowNotificationState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  ShowNotificationBloc() : super(ShowNotificationInitial()) {
    on<ShowLoadNotifications>(_loadNotifications);
    // on<ClearNotification>(clearNotification);
    add(ShowLoadNotifications());
  }

  List<Map<String, dynamic>> notificationData = [];

  Future<void> _loadNotifications(
      ShowLoadNotifications event, Emitter<ShowNotificationState> emit) async {
    emit(ShowNotificationLoading());

    try {
      String? currentUserId = auth.currentUser?.uid;
      if (currentUserId == null) {
        emit(ShowNotificationError("User not logged in"));
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

      emit(ShowNotificationLoaded(notifications));
    } catch (e) {
      emit(ShowNotificationError("Failed to load notifications: $e"));
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
