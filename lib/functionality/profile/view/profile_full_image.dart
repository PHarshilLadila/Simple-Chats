import 'dart:convert';

import 'package:chat_app_bloc/app_widget/app_appbar.dart';
import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileFullImage extends StatelessWidget {
  final String? imageurl;
  const ProfileFullImage({
    super.key,
    this.imageurl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomeAppBar(
        automaticallyImplyLeadings: true,
        titleWidget: Text(
          "Profile Image",
          style: GoogleFonts.poppins(
            color: isColorValidation(context),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Center(
        child: Image.memory(
          base64Decode(imageurl!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
