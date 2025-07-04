// ignore_for_file: deprecated_member_use

import 'package:chat_app_bloc/main.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class ZegoService {
  static const int appID = 129830797;
  static const String appSign =
      "8f198ef3effc61630892737fe603ce91ab27840a07470b567405869082fbc395";

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
    if (_currentUserId == userId && _currentUserName == userName) return;

    debugPrint("Updating Zego user: $userName ($userId)");

    // Uninitialize if already initialized with different user
    if (initialized && (_currentUserId != null || _currentUserName != null)) {
      await ZegoUIKitPrebuiltCallInvitationService().uninit();
    }

    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: appID,
      appSign: appSign,
      userID: userId,
      userName: userName,
      plugins: [ZegoUIKitSignalingPlugin()],
      notificationConfig: ZegoCallInvitationNotificationConfig(
        androidNotificationConfig: ZegoAndroidNotificationConfig(
          channelID: 'zego_call',
          channelName: 'Call Notifications',
          sound: 'zego_call',
          icon: 'notification_icon',
        ),
        iOSNotificationConfig: ZegoIOSNotificationConfig(
          systemCallingIconName: 'CallKitIcon',
        ),
      ),
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
