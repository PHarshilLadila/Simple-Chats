// ignore_for_file: deprecated_member_use

import 'package:chat_app_bloc/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class ZegoService {
  static const int appID = 355891306;
  static const String appSign =
      "5fbe55a774b231aaa319495bb9ab5a44eb2aad9f749737ddf6f3d3e283698f70";

  static bool initialized = false;
  static String? _currentUserId;
  static String? _currentUserName;

  static Future<void> init() async {
    // Only set up navigator key and basic initialization
    ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
    initialized = true;
    debugPrint("Zego basic initialization complete");
  }

  static Future<void> updateUser(String userId, String userName) async {
    if (userId.isEmpty) {
      debugPrint("Skipping Zego update: User ID is empty");
      return;
    }

    if (_currentUserId == userId &&
        _currentUserName == userName &&
        initialized) {
      debugPrint("Zego already initialized for $userName ($userId)");
      return;
    }

    debugPrint("Updating Zego user: $userName ($userId)");

    // Uninitialize if already initialized with different user
    if (initialized) {
      debugPrint("Uninitializing Zego for previous user");
      await ZegoUIKitPrebuiltCallInvitationService().uninit();
      initialized = false;
    }

    // Fetch current user settings
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      bool isCallNotification = true;
      bool isNotificationSound = true;

      if (userDoc.exists && userDoc.data() != null) {
        final data = userDoc.data() as Map<String, dynamic>;
        final settings = data['notificationSettings'] ?? {};
        isCallNotification = settings['call'] ?? true;
        isNotificationSound = settings['sound'] ?? true;
      }

      debugPrint("Initializing Zego with ID: $userId, Name: $userName");
      await ZegoUIKitPrebuiltCallInvitationService().init(
        appID: appID,
        appSign: appSign,
        userID: userId,
        userName: userName,
        plugins: [ZegoUIKitSignalingPlugin()],
        notificationConfig: isCallNotification
            ? ZegoCallInvitationNotificationConfig(
                androidNotificationConfig: ZegoAndroidNotificationConfig(
                  channelID: 'zego_call',
                  channelName: 'Call Notifications',
                  sound: isNotificationSound ? 'zego_call' : null,
                  icon: 'notification_icon',
                ),
                iOSNotificationConfig: ZegoIOSNotificationConfig(
                  systemCallingIconName: 'CallKitIcon',
                ),
              )
            : null,
        requireConfig: (ZegoCallInvitationData data) {
          return data.invitees.isNotEmpty
              ? (data.type == ZegoCallType.videoCall
                  ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                  : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall())
              : (data.type == ZegoCallType.voiceCall
                  ? ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
                  : ZegoUIKitPrebuiltCallConfig.groupVoiceCall());
        },
      );

      _currentUserId = userId;
      _currentUserName = userName;
      initialized = true;
      debugPrint("Zego user updated successfully");
    } catch (e) {
      debugPrint("Error updating Zego user: $e");
      initialized = false;
    }
  }

  static Future<void> sendCallInvitation({
    required String senderUid,
    required String receiverUid,
    required String receiverName,
    required bool isVideoCall,
  }) async {
    if (!initialized || _currentUserId == null) {
      throw Exception(
          "Zego not properly initialized with user. Call updateUser() first.");
    }

    final callID = generateCallID(senderUid, receiverUid);
    debugPrint("Sending call invitation to $receiverName ($receiverUid)");

    try {
      await ZegoUIKitPrebuiltCallInvitationService().send(
        invitees: [ZegoCallUser(receiverUid, receiverName)],
        isVideoCall: isVideoCall,
        callID: callID,
      );
    } catch (e) {
      debugPrint("Error sending call invitation: $e");
      rethrow;
    }
  }

  static String generateCallID(String userA, String userB) {
    final ids = [userA, userB]..sort();
    return ids.join("_");
  }
}

//--
// ignore_for_file: deprecated_member_use

// import 'package:chat_app_bloc/main.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

// class ZegoService {
//   static const int appID = 355891306;
//   static const String appSign =
//       "5fbe55a774b231aaa319495bb9ab5a44eb2aad9f749737ddf6f3d3e283698f70";

//   static bool initialized = false;
//   static String? _currentUserId;
//   static String? _currentUserName;

//   static Future<void> init() async {
//     // Only set up navigator key and basic initialization
//     ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
//     initialized = true;
//     debugPrint("Zego basic initialization complete");
//   }

//   static Future<void> updateUser(String userId, String userName) async {
//     if (userId.isEmpty) {
//       debugPrint("Skipping Zego update: User ID is empty");
//       return;
//     }

//     if (_currentUserId == userId && _currentUserName == userName && initialized) {
//       debugPrint("Zego already initialized for $userName ($userId)");
//       return;
//     }

//     debugPrint("Updating Zego user: $userName ($userId)");

//     // Uninitialize if already initialized with different user
//     if (initialized) {
//       debugPrint("Uninitializing Zego for previous user");
//       await ZegoUIKitPrebuiltCallInvitationService().uninit();
//       initialized = false;
//     }

//     // Fetch current user settings
//     try {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .get();

//       bool isCallNotification = true;
//       bool isNotificationSound = true;

//       if (userDoc.exists && userDoc.data() != null) {
//         final data = userDoc.data() as Map<String, dynamic>;
//         final settings = data['notificationSettings'] ?? {};
//         isCallNotification = settings['call'] ?? true;
//         isNotificationSound = settings['sound'] ?? true;
//       }

//       debugPrint("Initializing Zego with ID: $userId, Name: $userName");
//       await ZegoUIKitPrebuiltCallInvitationService().init(
//         appID: appID,
//         appSign: appSign,
//         userID: userId,
//         userName: userName,
//         plugins: [ZegoUIKitSignalingPlugin()],
//         notificationConfig: isCallNotification
//             ? ZegoCallInvitationNotificationConfig(
//                 androidNotificationConfig: ZegoAndroidNotificationConfig(
//                   channelID: 'zego_call',
//                   channelName: 'Call Notifications',
//                   sound: isNotificationSound ? 'zego_call' : null,
//                   icon: 'notification_icon',
//                 ),
//                 iOSNotificationConfig: ZegoIOSNotificationConfig(
//                   systemCallingIconName: 'CallKitIcon',
//                 ),
//               )
//             : null,
//         requireConfig: (ZegoCallInvitationData data) {
//           return data.invitees.isNotEmpty
//               ? (data.type == ZegoCallType.videoCall
//                   ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
//                   : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall())
//               : (data.type == ZegoCallType.voiceCall
//                   ? ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
//                   : ZegoUIKitPrebuiltCallConfig.groupVoiceCall());
//         },
//       );

//       _currentUserId = userId;
//       _currentUserName = userName;
//       initialized = true;
//       debugPrint("Zego user updated successfully");
//     } catch (e) {
//       debugPrint("Error updating Zego user: $e");
//       initialized = false;
//     }
//   }

//   static Future<void> sendCallInvitation({
//     required String senderUid,
//     required String receiverUid,
//     required String receiverName,
//     required bool isVideoCall,
//   }) async {
//     if (!initialized || _currentUserId == null) {
//       throw Exception(
//           "Zego not properly initialized with user. Call updateUser() first.");
//     }

//     final callID = generateCallID(senderUid, receiverUid);
//     debugPrint("Sending call invitation to $receiverName ($receiverUid)");

//     try {
//       await ZegoUIKitPrebuiltCallInvitationService().send(
//         invitees: [ZegoCallUser(receiverUid, receiverName)],
//         isVideoCall: isVideoCall,
//         callID: callID,
//       );
//     } catch (e) {
//       debugPrint("Error sending call invitation: $e");
//       rethrow;
//     }
//   }

//   static String generateCallID(String userA, String userB) {
//     final ids = [userA, userB]..sort();
//     return ids.join("_");
//   }
// }
