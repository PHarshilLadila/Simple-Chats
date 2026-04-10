// ignore_for_file: deprecated_member_use

import 'package:chat_app_bloc/app_widget/app_appbar.dart';
import 'package:chat_app_bloc/functionality/settings/help_and_support/screens/app_version_screen.dart';
import 'package:chat_app_bloc/functionality/settings/help_and_support/screens/contact_support_screen.dart';
import 'package:chat_app_bloc/functionality/settings/help_and_support/screens/faq_screen.dart';
import 'package:chat_app_bloc/functionality/settings/help_and_support/screens/technical_support_screen.dart';
import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:chat_app_bloc/functionality/profile/view/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: CustomeAppBar(
        automaticallyImplyLeadings: false,
        titleWidget: Text(
          "Help Center",
          style: GoogleFonts.poppins(
            color: isColorValidation(context),
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.arrowLeft,
                size: 18,
                color: Color(0xFF4B5563),
              ),
            ),
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
                icon: CupertinoIcons.question_circle_fill,
                title: "FAQ",
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FAQScreen()));
                },
              ),
              SettingTile(
                icon: CupertinoIcons.wrench_fill,
                title: "Technical Support",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TechnicalSupportScreen()));
                },
              ),
              SettingTile(
                icon: CupertinoIcons.headphones,
                title: "Contact Support",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactSupportScreen(),
                    ),
                  );
                },
              ),
              // SettingTile(
              //   icon: CupertinoIcons.exclamationmark_bubble_fill,
              //   title: "Report a Problem",
              //   onTap: () {},
              // ),
              SettingTile(
                icon: CupertinoIcons.info_circle_fill,
                title: "App Version",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppVersionScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
