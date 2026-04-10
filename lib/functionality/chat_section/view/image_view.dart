// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:chat_app_bloc/app_widget/app_appbar.dart';
import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:google_fonts/google_fonts.dart';

class ImageView extends StatelessWidget {
  final String imageUrl;

  const ImageView({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: CustomeAppBar(
        automaticallyImplyLeadings: false,
        titleWidget: Text(
          "Image",
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
        actions: [
          PopupMenuButton(
            color: isColorValidation(context),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Text(
                  "Save Image",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      //  AppBar(
      //   automaticallyImplyLeading: false,
      //   iconTheme: const IconThemeData(color: Colors.white),
      //   backgroundColor: AppColor.mainColor,
      //   centerTitle: false,
      //   toolbarHeight: 70,
      //   title: const Row(
      //     children: [
      //       Center(
      //         child: Text(
      //           "Image",
      //           style: TextStyle(color: Colors.white, fontSize: 20),
      //         ),
      //       ),
      //     ],
      //   ),
      //   actions: [
      //     PopupMenuButton(
      //       itemBuilder: (context) => [
      //         const PopupMenuItem<int>(
      //           value: 0,
      //           child: Text("Save Image"),
      //         ),
      //       ],
      //     ),
      //   ],
      //   leading: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: GestureDetector(
      //       onTap: () {
      //         Navigator.pop(context);
      //       },
      //       child: Container(
      //         decoration: BoxDecoration(
      //             color: Colors.transparent,
      //             shape: BoxShape.circle,
      //             border: Border.all(color: Colors.white)),
      //         child: const Center(
      //           child: FaIcon(
      //             FontAwesomeIcons.arrowLeft,
      //             size: 18,
      //             color: Colors.white,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 100.0,
          boundaryMargin: const EdgeInsets.all(8),
          child: FullScreenWidget(
            backgroundIsTransparent: true,
            disposeLevel: DisposeLevel.Medium,
            child: Image.memory(
              base64Decode(imageUrl),
              fit: BoxFit.cover,
              frameBuilder: (BuildContext context, Widget child, int? frame,
                  bool wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) {
                  return child;
                }
                return AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: const Duration(seconds: 0),
                    curve: Curves.easeInOutSine,
                    child: child);
              },
            ),
          ),
        ),
      ),
    );
  }
}
