import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? size;
  final FontWeight? fontWeight;
  final Color color;
  final double? wordSpacing;

  const AppText({
    super.key,
    required this.text,
    this.size,
    this.fontWeight,
    required this.color,
    this.wordSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.aclonica(
        fontSize: size,
        fontWeight: fontWeight,
        color: color,
        wordSpacing: wordSpacing,
      ),
    );
  }
}
