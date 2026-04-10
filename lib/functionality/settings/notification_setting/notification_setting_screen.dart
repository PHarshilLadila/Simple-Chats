// ignore_for_file: deprecated_member_use

import 'package:chat_app_bloc/app_widget/app_appbar.dart';
import 'package:chat_app_bloc/functionality/settings/notification_setting/widget/custom_toggle_switch_tile.dart';
import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isMessageNotification = true;
  bool isGroupNotification = true;
  bool isCallNotification = true;
  bool isNotificationSound = true;
  bool isNotificationVibration = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc =
            await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          final data = doc.data() as Map<String, dynamic>;
          final settings = data['notificationSettings'] ?? {};
          setState(() {
            isMessageNotification = settings['message'] ?? true;
            isGroupNotification = settings['group'] ?? true;
            isCallNotification = settings['call'] ?? true;
            isNotificationSound = settings['sound'] ?? true;
            isNotificationVibration = settings['vibration'] ?? true;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        debugPrint("Error loading notification settings: $e");
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _updateSetting(String key, bool value) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).set({
          'notificationSettings': {
            key: value,
          }
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint("Error updating notification setting ($key): $e");
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: CustomeAppBar(
        automaticallyImplyLeadings: true,
        titleWidget: Text(
          "Notification",
          style: GoogleFonts.poppins(
            color: isColorValidation(context),
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CustomToggleSwitchTileNotificationSetting(
                      icon: FontAwesomeIcons.solidBell,
                      title: "Message Notification",
                      value: isMessageNotification,
                      onChanged: (val) {
                        setState(() {
                          isMessageNotification = val;
                        });
                        _updateSetting('message', val);
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomToggleSwitchTileNotificationSetting(
                      icon: FontAwesomeIcons.userGroup,
                      title: "Group Notification",
                      iconSize: 16,
                      value: isGroupNotification,
                      onChanged: (val) {
                        setState(() {
                          isGroupNotification = val;
                        });
                        _updateSetting('group', val);
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomToggleSwitchTileNotificationSetting(
                      icon: CupertinoIcons.phone_fill,
                      title: "Call Notification",
                      iconSize: 22,
                      value: isCallNotification,
                      onChanged: (val) {
                        setState(() {
                          isCallNotification = val;
                        });
                        _updateSetting('call', val);
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomToggleSwitchTileNotificationSetting(
                      icon: CupertinoIcons.speaker_2_fill,
                      title: "Notification Sound",
                      value: isNotificationSound,
                      onChanged: (val) {
                        setState(() {
                          isNotificationSound = val;
                        });
                        _updateSetting('sound', val);
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomToggleSwitchTileNotificationSetting(
                      icon: CupertinoIcons.waveform,
                      title: "Notification Vibration",
                      value: isNotificationVibration,
                      iconSize: 26,
                      onChanged: (val) {
                        setState(() {
                          isNotificationVibration = val;
                        });
                        _updateSetting('vibration', val);
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
