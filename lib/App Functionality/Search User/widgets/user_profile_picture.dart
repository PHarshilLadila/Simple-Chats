import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

class ProfileAvatar extends StatelessWidget {
  final String base64Image;

  const ProfileAvatar({super.key, required this.base64Image});

  Future<Uint8List> _decodeImage() async {
    return base64Decode(base64Image);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipOval(
        child: FutureBuilder<Uint8List>(
          future: _decodeImage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  color: Colors.grey.shade200,
                  width: 40,
                  height: 40,
                ),
              );
            } else if (snapshot.hasError || !snapshot.hasData) {
              return Container(
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: const FaIcon(FontAwesomeIcons.user,
                    size: 20, color: Colors.grey),
              );
            } else {
              return Image.memory(
                snapshot.data!,
                fit: BoxFit.cover,
                width: 40,
                height: 40,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const FaIcon(FontAwesomeIcons.user,
                        size: 20, color: Colors.grey),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
