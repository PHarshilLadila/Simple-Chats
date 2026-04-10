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
    String senderProfileImages,
    String senderEmails,
    String senderMobileNumbers,
  ) async {
    try {
      // Fetch receiver's settings
      DocumentSnapshot receiverDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverUids)
          .get();

      bool isMessageNotification = true;
      bool isCallNotification = true;
      bool isNotificationSound = true;
      bool isNotificationVibration = true;

      if (receiverDoc.exists && receiverDoc.data() != null) {
        final data = receiverDoc.data() as Map<String, dynamic>;
        final settings = data['notificationSettings'] ?? {};
        isMessageNotification = settings['message'] ?? true;
        isCallNotification = settings['call'] ?? true;
        isNotificationSound = settings['sound'] ?? true;
        isNotificationVibration = settings['vibration'] ?? true;
      }

      // Check if this is a call or message (simplified check)
      bool isCall = title.toLowerCase().contains("call") ||
          body.toLowerCase().contains("call");

      if (isCall && !isCallNotification) {
        debugPrint("=> Call notification is disabled for receiver. Skipping.");
        return;
      }

      if (!isCall && !isMessageNotification) {
        debugPrint(
            "=> Message notification is disabled for receiver. Skipping.");
        return;
      }

      final accessToken = await getAccessToken();

      // FCM v1 URL
      final Uri url = Uri.parse(
          'https://fcm.googleapis.com/v1/projects/simple-chat-52a15/messages:send');

      final Map<String, dynamic> notificationData = {
        "message": {
          "token": token,
          "notification": {
            "title": title,
            "body": body,
          },
          "data": {
            "type": isCall ? "call" : "chat",
            "chatId": chatIds,
            "senderUid": senderUids,
            "senderName": senderNames,
          },
          "android": {
            "priority": "HIGH",
            "notification": {
              "sound": isNotificationSound ? "default" : null,
              "default_vibrate_timings": isNotificationVibration,
              "default_sound": isNotificationSound,
            },
          },
          "apns": {
            "payload": {
              "aps": {
                "sound": isNotificationSound ? "default" : null,
              }
            }
          }
        }
      };

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode(notificationData),
      );

      if (response.statusCode == 200) {
        debugPrint('=> Notification sent successfully to $token');
      } else {
        debugPrint('=> Failed to send notification: ${response.body}');
      }
    } catch (e) {
      debugPrint("=> Error in sendNotificationToUser: $e");
    }
  }
}
