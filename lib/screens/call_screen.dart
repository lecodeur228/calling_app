import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key, required this.name, required this.userId, required this.callId});
  final String name;
  final String userId;
  final String callId;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 101958010, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign: "61ca9c62fc32a040c7758fee1be1d320fef03fadc0dab760f1324abb2a2a6c5e", // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: userId,
      userName: name,
      callID: callId,
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
      ..onOnlySelfInRoom = (context) => Navigator.of(context).pop(),
    );
  }
}