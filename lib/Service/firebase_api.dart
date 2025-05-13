import 'dart:convert';

import 'package:chat_app_bloc/App%20Functionality/Chat%20Screen/view/chat_screen.dart';
import 'package:chat_app_bloc/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseApi {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // bool isNotificationOpen = false;

  Future<void> initNotification() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);

    await localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        final String? payload = notificationResponse.payload;
        if (payload != null) {
          // final Map<String, dynamic> data = jsonDecode(payload);
          // final RemoteMessage message = RemoteMessage(data: data);
          // handleNotificationClick(message, true);
        }
      },
    );

    NotificationSettings settings = await messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('=> User granted permission for notifications');
    } else {
      debugPrint('=> User declined or has not accepted notifications');
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(
        message.notification?.title,
        message.notification?.body,
        message.data,
      );
      debugPrint('=> Foreground notification: ${message.notification?.title}');
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      // if (message != null) {
      //   Future.delayed(
      //       Duration.zero, () => handleNotificationClick(message, true));
      // }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // handleNotificationClick(message, true);
    });
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    debugPrint(
        '=> Handling background notification: ${message.notification?.title}');
  }

  Future<void> _showNotification(
      String? title, String? body, Map<String, dynamic> data) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      channelDescription: 'This is the default notification channel',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await localNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: jsonEncode(data),
    );
  }

  void handleNotificationClick(RemoteMessage message, bool isTapped) {
    if (message.data.isEmpty) return;
    final notificationData = message.data;
    debugPrint('debugPrintNotification Data: $notificationData');

    if (notificationData.containsKey('type') &&
        notificationData['type'] == 'chat') {
      if (notificationData.containsKey('senderUid')) {
        String userId = notificationData['senderUid'];
        debugPrint("debugPrint this is the user id =>=>=>=>=> $userId");
        // navigatorKey.currentState
        //     ?.pushNamed(AppRoute.chatScreen, arguments: {'senderUid': userId});
        Map<String, dynamic>? userMap;
        if (notificationData.containsKey('usermap')) {
          userMap = jsonDecode(notificationData['usermap']);
        }
        debugPrint('debugPrint this is the usemap =>..=> $userMap');

        // var usermapdata = notificationData['usermap'];
        // var mainusermapdata = jsonEncode(usermapdata);
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatId: notificationData['chatId'] ?? "ChatId",
              // replace current user name to sender name
              currentUserName: isTapped
                  ? notificationData['senderName'] ?? "N/A"
                  : notificationData['currentUserName'] ?? "N/A",
              // message: message.notification?.body ?? "N/A",

              receiverUid: isTapped
                  ? notificationData['receiverUid'] ?? "N/A"
                  : notificationData['senderUid'] ?? "N/A",
              senderUid: isTapped
                  ? notificationData['senderUid'] ?? "N/A"
                  : notificationData['receiverUid'] ?? "N/A",

              receiverFCM: isTapped
                  ? notificationData['senderFCMToken'] ?? "N/A"
                  : notificationData['receiverFCMToken'] ?? "N/A",

              receiverName: isTapped
                  ? notificationData['receiverFCMToken'] ?? "N/A"
                  : notificationData['senderFCMToken'] ?? "N/A",
              // senderName: message.notification?.title ?? "User",
              senderName: notificationData['currentUserName'] ?? "N/A",

              // userMap: userMap,
            ),
          ),
        );
      } else {
        debugPrint('Missing userId in notification data');
      }
    }
  }
}
