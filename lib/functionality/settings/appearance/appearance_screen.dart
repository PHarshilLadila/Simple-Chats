import 'package:chat_app_bloc/app_widget/app_appbar.dart';
import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:chat_app_bloc/theme/widgets/theme_settings_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: CustomeAppBar(
        automaticallyImplyLeadings: true,
        titleWidget: Text(
          "Appearance",
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
          child: Column(children: [ThemeSettingsWidget()]),
        ),
      ),
    );
  }
}
