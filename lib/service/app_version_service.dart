import 'package:chat_app_bloc/functionality/settings/help_and_support/models/app_version_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AppVersionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _versionCollection = 'app_versions';
  static const String _deviceInfoCollection = 'device_info';

  // Get current app version
  static Future<PackageInfo> getCurrentAppVersion() async {
    return await PackageInfo.fromPlatform();
  }

  // Get device information
  static Future<DeviceInfo> getDeviceInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final deviceInfoPlugin = DeviceInfoPlugin();

    String deviceName = '';
    String deviceModel = '';
    String osVersion = '';
    String platform = '';

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      deviceName = androidInfo.model;
      deviceModel = androidInfo.model;
      osVersion = androidInfo.version.release;
      platform = 'Android';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      deviceName = iosInfo.name;
      deviceModel = iosInfo.model;
      osVersion = iosInfo.systemVersion;
      platform = 'iOS';
    }

    return DeviceInfo(
      deviceId: await _getDeviceId(),
      deviceName: deviceName,
      deviceModel: deviceModel,
      osVersion: osVersion,
      appVersion: packageInfo.version,
      appBuildNumber: packageInfo.buildNumber,
      platform: platform,
      language: Platform.localeName,
      timezone: DateTime.now().timeZoneName,
    );
  }

  static Future<String> _getDeviceId() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      return iosInfo.identifierForVendor ?? '';
    }
    return '';
  }

  // Check for updates
  Future<VersionCheckResult> checkForUpdates() async {
    try {
      final currentPackageInfo = await getCurrentAppVersion();
      final currentVersion = currentPackageInfo.version;
      final currentBuild = int.tryParse(currentPackageInfo.buildNumber) ?? 1;

      // Get latest version from Firebase
      final latestSnapshot = await _firestore
          .collection(_versionCollection)
          .orderBy('buildNumber', descending: true)
          .limit(1)
          .get();

      if (latestSnapshot.docs.isEmpty) {
        return VersionCheckResult(needsUpdate: false);
      }

      final latestVersion = AppVersion.fromFirestore(latestSnapshot.docs.first);
      final latestBuild = latestVersion.buildNumber;

      // Check if update is needed
      final needsUpdate = latestBuild > currentBuild;

      if (!needsUpdate) {
        return VersionCheckResult(needsUpdate: false);
      }

      // Determine if update is required
      final minSupportedVersion = latestVersion
              .minSupportedVersions[Platform.isAndroid ? 'android' : 'ios'] ??
          '1.0.0';
      final isRequired = _isVersionOlder(currentVersion, minSupportedVersion);

      return VersionCheckResult(
        needsUpdate: true,
        isRequired: isRequired,
        isCritical: latestVersion.isCritical,
        latestVersion: latestVersion,
        message: _getUpdateMessage(latestVersion, isRequired),
      );
    } catch (e) {
      debugPrint('Error checking for updates: $e');
      return VersionCheckResult(needsUpdate: false);
    }
  }

  // Save device info to Firebase
  Future<void> saveDeviceInfo() async {
    try {
      final deviceInfo = await getDeviceInfo();
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await _firestore.collection(_deviceInfoCollection).doc(user.uid).set({
          ...deviceInfo.toJson(),
          'userId': user.uid,
          'userEmail': user.email,
          'lastSeen': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint('Error saving device info: $e');
    }
  }

  // Report version issue
  Future<bool> reportVersionIssue({
    required String userId,
    required String issue,
    required String currentVersion,
  }) async {
    try {
      await _firestore.collection('version_issues').add({
        'userId': userId,
        'issue': issue,
        'currentVersion': currentVersion,
        'deviceInfo': (await getDeviceInfo()).toJson(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      debugPrint('Error reporting version issue: $e');
      return false;
    }
  }

  bool _isVersionOlder(String current, String minRequired) {
    final currentParts = current.split('.').map(int.parse).toList();
    final minParts = minRequired.split('.').map(int.parse).toList();

    for (int i = 0; i < 3; i++) {
      final currentPart = i < currentParts.length ? currentParts[i] : 0;
      final minPart = i < minParts.length ? minParts[i] : 0;

      if (currentPart < minPart) return true;
      if (currentPart > minPart) return false;
    }
    return false;
  }

  String _getUpdateMessage(AppVersion version, bool isRequired) {
    if (isRequired) {
      return 'A critical update is required to continue using the app. Please update now.';
    } else if (version.isCritical) {
      return 'Important update available! New features and bug fixes.';
    } else {
      return 'New version ${version.versionName} is available. Would you like to update?';
    }
  }
}
