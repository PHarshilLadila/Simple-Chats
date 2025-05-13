import 'dart:convert';

import 'package:chat_app_bloc/Constent/app_color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:full_screen_image/full_screen_image.dart';

class ImageView extends StatelessWidget {
  final String imageUrl;

  const ImageView({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColor.mainColor,
        centerTitle: false,
        toolbarHeight: 70,
        title: const Row(
          children: [
            Center(
              child: Text(
                "Image",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("Save Image"),
              ),
            ],
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white)),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.arrowLeft,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
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
