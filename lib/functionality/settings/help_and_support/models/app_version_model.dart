import 'package:cloud_firestore/cloud_firestore.dart';

class AppVersion {
  final String versionCode;
  final String versionName;
  final int buildNumber;
  final DateTime releaseDate;
  final String releaseNotes;
  final bool isRequired;
  final bool isCritical;
  final String downloadUrl;
  final List<String> changes;
  final Map<String, dynamic> minSupportedVersions;

  AppVersion({
    required this.versionCode,
    required this.versionName,
    required this.buildNumber,
    required this.releaseDate,
    required this.releaseNotes,
    this.isRequired = false,
    this.isCritical = false,
    this.downloadUrl = '',
    this.changes = const [],
    this.minSupportedVersions = const {},
  });

  Map<String, dynamic> toFirestore() {
    return {
      'versionCode': versionCode,
      'versionName': versionName,
      'buildNumber': buildNumber,
      'releaseDate': Timestamp.fromDate(releaseDate),
      'releaseNotes': releaseNotes,
      'isRequired': isRequired,
      'isCritical': isCritical,
      'downloadUrl': downloadUrl,
      'changes': changes,
      'minSupportedVersions': minSupportedVersions,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory AppVersion.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppVersion(
      versionCode: data['versionCode'] ?? '',
      versionName: data['versionName'] ?? '',
      buildNumber: data['buildNumber'] ?? 1,
      releaseDate:
          (data['releaseDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      releaseNotes: data['releaseNotes'] ?? '',
      isRequired: data['isRequired'] ?? false,
      isCritical: data['isCritical'] ?? false,
      downloadUrl: data['downloadUrl'] ?? '',
      changes: List<String>.from(data['changes'] ?? []),
      minSupportedVersions: data['minSupportedVersions'] ?? {},
    );
  }
}

class DeviceInfo {
  final String deviceId;
  final String deviceName;
  final String deviceModel;
  final String osVersion;
  final String appVersion;
  final String appBuildNumber;
  final String platform;
  final String language;
  final String timezone;
  final Map<String, dynamic> additionalInfo;

  DeviceInfo({
    required this.deviceId,
    required this.deviceName,
    required this.deviceModel,
    required this.osVersion,
    required this.appVersion,
    required this.appBuildNumber,
    required this.platform,
    required this.language,
    required this.timezone,
    this.additionalInfo = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'deviceName': deviceName,
      'deviceModel': deviceModel,
      'osVersion': osVersion,
      'appVersion': appVersion,
      'appBuildNumber': appBuildNumber,
      'platform': platform,
      'language': language,
      'timezone': timezone,
      'additionalInfo': additionalInfo,
    };
  }
}

class VersionCheckResult {
  final bool needsUpdate;
  final bool isRequired;
  final bool isCritical;
  final AppVersion? latestVersion;
  final String? message;

  VersionCheckResult({
    required this.needsUpdate,
    this.isRequired = false,
    this.isCritical = false,
    this.latestVersion,
    this.message,
  });
}
