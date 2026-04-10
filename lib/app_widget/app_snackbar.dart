import 'package:flutter/material.dart';

class AppSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    IconData? icon,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor, size: 20),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Success Snackbar
  static void success(BuildContext context, String message) {
    show(
      context,
      message: message,
      backgroundColor: Colors.green.shade600,
      icon: Icons.check_circle,
    );
  }

  // Error Snackbar
  static void error(BuildContext context, String message) {
    show(
      context,
      message: message,
      backgroundColor: Colors.red.shade600,
      icon: Icons.error,
    );
  }

  // Info Snackbar
  static void info(BuildContext context, String message) {
    show(
      context,
      message: message,
      backgroundColor: Colors.blue.shade600,
      icon: Icons.info,
    );
  }
}


/*

AppSnackbar.show(
  context,
  message: "Telegram coming soon",
  icon: Icons.telegram,
);
AppSnackbar.success(context, "Login successful");
AppSnackbar.error(context, "Something went wrong");
AppSnackbar.info(context, "Telegram coming soon");

*/ 