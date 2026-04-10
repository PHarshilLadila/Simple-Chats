import 'dart:convert';

import 'package:chat_app_bloc/functionality/chat_section/view/chat_screen.dart';
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
        AndroidInitializationSettings('notification_icon');

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
      icon: 'notification_icon',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await localNotificationsPlugin.show(
      DateTime.now().microsecondsSinceEpoch % 1000000,
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
        String senderUid = notificationData['senderUid'] ?? "N/A";
        String chatId = notificationData['chatId'] ?? "ChatId";

        debugPrint("debugPrint this is the user id =>=>=>=>=> $senderUid");

        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatId: chatId,
              currentUserName: currentUserName,
              senderName: currentUserName,
              receiverName: notificationData['senderName'] ?? "N/A",
              senderUid: currentUserId,
              receiverUid: senderUid,
              userEmail: notificationData['senderEmail'] ?? "N/A",
              mobileNumber: notificationData['senderMobile'] ?? "N/A",
              receiverFCM: notificationData['senderFCMToken'] ?? "N/A",
              profileImage: notificationData['senderProfile'] ?? "",
            ),
          ),
        );
      } else {
        debugPrint('Missing userId in notification data');
      }
    }
  }
}
