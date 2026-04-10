// ignore_for_file: use_build_context_synchronously

import 'package:chat_app_bloc/app_widget/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermissionManager {
  static Future<bool> checkCameraPermission(BuildContext context) async {
    var status = await Permission.camera.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      var result = await Permission.camera.request();

      if (result.isGranted) {
        return true;
      } else {
        AppSnackbar.error(context, "Please allow camera permission");
        // Fluttertoast.showToast(msg: "Please allow camera permission");
        return false;
      }
    }

    if (status.isPermanentlyDenied) {
      AppSnackbar.error(context, "Please allow camera permission");
      // Fluttertoast.showToast(
      //     msg: "Camera permission permanently denied. Open settings.");
      openAppSettings(); // Opens Android settings screen
      return false;
    }

    return false;
  }

  static Future<bool> checkMediaFilePermission(BuildContext context) async {
    var status = await Permission.mediaLibrary.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      var result = await Permission.mediaLibrary.request();

      if (result.isGranted) {
        return true;
      } else {
        AppSnackbar.error(context, "Please allow media file permission");
        // Fluttertoast.showToast(msg: "Please allow camera permission");
        return false;
      }
    }

    if (status.isPermanentlyDenied) {
      AppSnackbar.error(context, "Please allow media file permission");
      // Fluttertoast.showToast(
      //     msg: "Camera permission permanently denied. Open settings.");
      openAppSettings(); // Opens Android settings screen
      return false;
    }

    return false;
  }
}
