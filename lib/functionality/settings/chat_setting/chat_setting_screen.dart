import 'package:chat_app_bloc/app_widget/app_appbar.dart';
import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:chat_app_bloc/functionality/profile/view/profile_screen.dart';
import 'package:chat_app_bloc/functionality/settings/chat_setting/chat_wallpaper_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatSettingScreen extends StatefulWidget {
  const ChatSettingScreen({super.key});

  @override
  State<ChatSettingScreen> createState() => _ChatSettingScreenState();
}

class _ChatSettingScreenState extends State<ChatSettingScreen> {
  bool enterIsSend = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      enterIsSend = prefs.getBool('enterIsSend') ?? false;
    });
  }

  Future<void> _toggleEnterIsSend(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enterIsSend', value);
    setState(() {
      enterIsSend = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: CustomeAppBar(
        automaticallyImplyLeadings: true,
        titleWidget: Text(
          "Chats",
          style: GoogleFonts.poppins(
            color: isColorValidation(context),
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SettingTile(
                icon: Icons.send,
                title: "Enter is send",
                onTap: () {},
                trailing: Transform.scale(
                  scale: 0.7,
                  child: CupertinoSwitch(
                    value: enterIsSend,
                    onChanged: (value) {
                      _toggleEnterIsSend(value);
                    },
                    activeTrackColor: Theme.of(context).primaryColor,
                    inactiveTrackColor: Colors.grey[300],
                    thumbColor: Colors.white,
                  ),
                ),
              ),
              SettingTile(
                icon: Icons.wallpaper,
                title: "Chat Wallpaper",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatWallpaperScreen(),
                    ),
                  );
                },
              ),
              SettingTile(
                icon: Icons.text_fields,
                title: "Font Size",
                subTitle: "Medium",
                onTap: () {},
              ),
              SettingTile(
                icon: Icons.backup,
                title: "Chat Backup",
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
