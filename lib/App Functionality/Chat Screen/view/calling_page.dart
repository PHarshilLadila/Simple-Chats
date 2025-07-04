import 'package:chat_app_bloc/App%20Functionality/Chat%20Screen/helper/call_service.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatelessWidget {
  final String callID;
  final String userID;
  final String userName;
  final bool isVideoCall;

  const CallPage({
    super.key,
    required this.callID,
    required this.userID,
    required this.userName,
    this.isVideoCall = true,
  });

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: ZegoService.appID,
      appSign: ZegoService.appSign,
      userID: userID,
      userName: userName,
      callID: callID,
      config: isVideoCall
          ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
          : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
    );
  }
}
