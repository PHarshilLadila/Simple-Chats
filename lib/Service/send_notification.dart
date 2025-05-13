import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class SendNotification {
  Future<String> getAccessToken() async {
    try {
      final serviceAccountJson =
          await rootBundle.loadString('assets/key/serviceAccountKey.json');
      final serviceAccount = jsonDecode(serviceAccountJson);

      final accountCredentials =
          ServiceAccountCredentials.fromJson(serviceAccount);
      final scopes = ['https://www.googleapis.com/auth/cloud-platform'];

      final authClient =
          await clientViaServiceAccount(accountCredentials, scopes);

      final accessToken = authClient.credentials.accessToken.data;

      debugPrint("=> Access token retrieved successfully: $accessToken");
      return accessToken;
    } catch (e) {
      debugPrint("=> Error fetching access token: $e");
      rethrow;
    }
  }

  Future<String?> getFCMTokenFromUser(String userId) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('fcmToken')) {
          String? fcmToken = data['fcmToken'] as String?;
          debugPrint("=> FCM Token retrieved: $fcmToken");
          return fcmToken;
        } else {
          debugPrint("=> FCM token not found in user document");
          return null;
        }
      } else {
        debugPrint("=> User document not found");
        return null;
      }
    } catch (e) {
      debugPrint("=> Error retrieving FCM Token: $e");
      return null;
    }
  }

  Future<void> sendFCMTokenToUser(String userId, String fcmToken) async {
    try {
      debugPrint("=> Attempting to send FCM Token...");
      debugPrint("=> UserID: $userId");
      debugPrint("=> FCM Token: $fcmToken");

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentReference userDocRef = firestore.collection('users').doc(userId);

      await userDocRef.set(
        {'fcmToken': fcmToken},
        SetOptions(merge: true),
      );

      debugPrint(
          "=> FCM Token sent successfully to Firestore for user: $userId with the FCM token : $fcmToken");
    } catch (e) {
      debugPrint("=> Error sending FCM Token: $e");
      if (e is FirebaseException) {
        debugPrint("=> Firestore Error: ${e.code} - ${e.message}");
      }
    }
  }

  Future<void> sendNotificationToUser(
    String token,
    String title,
    String body,
    String chatIds,
    String currentUserNames,
    String senderNames,
    String senderFCMTokens,
    String senderUids,
    String receiverUids,
    String receiverFCMTokens,
    // Map<String, dynamic> userMaps,
  ) async {
    final accessToken = await getAccessToken();

    debugPrint("=> accesee tokens : $accessToken");
    // Map<String, dynamic>? userMap;

    // userMap = userMaps;

    // FCM v1 URL
    final Uri url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/chat-app-bloc-d05a0/messages:send');

    // chatScreen:
    // (context) => const ChatScreen();

    final Map<String, dynamic> notificationData = {
      "message": {
        "token": token,
        "notification": {
          "title": title,
          "body": body,
        },
        "android": {
          "priority": "HIGH",
        },
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK ",
          "type": "chat",
          "screen": "/chatScreen",
          "chatId": chatIds,
          "currentUserName": currentUserNames,
          "senderName": senderNames,
          "senderFCMToken": senderFCMTokens,
          "senderUid": senderUids,
          "receiverUid": receiverUids,
          "receiverFCMToken": receiverFCMTokens,
        },
      }
    };

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Bearer $accessToken", // Use Bearer token for authentication
      },
      body: jsonEncode(notificationData),
    );

    if (response.statusCode == 200) {
      debugPrint('=> Notification sent successfully');

      debugPrint('=> Notification sent successfully to $token');
    } else {
      debugPrint('=> Failed to send notification: ${response.body}');
    }
  }
}
