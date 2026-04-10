// ignore_for_file: deprecated_member_use

import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomToggleSwitchTileNotificationSetting extends StatelessWidget {
  final IconData icon;
  final double? iconSize;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? iconColor;
  final Color? iconBgColor;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;

  const CustomToggleSwitchTileNotificationSetting({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    this.iconColor,
    this.iconBgColor,
    this.textStyle,
    this.padding,
    this.iconSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: padding ??
          const EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 0),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColor.darkBorderColor : AppColor.borderColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: MediaQuery.of(context).size.width * 0.1,
            width: MediaQuery.of(context).size.width * 0.1,
            decoration: BoxDecoration(
              color: iconBgColor ??
                  Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: FaIcon(
                icon,
                color: iconColor ?? Theme.of(context).primaryColor,
                size: iconSize,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: textStyle ??
                  GoogleFonts.poppins(
                    color: isDark ? Colors.white : AppColor.blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Transform.scale(
            scale: 0.75,
            child: CupertinoSwitch(
              value: value,
              onChanged: onChanged,
              activeColor: Theme.of(context).primaryColor,
              trackColor: Colors.grey[300],
              thumbColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
