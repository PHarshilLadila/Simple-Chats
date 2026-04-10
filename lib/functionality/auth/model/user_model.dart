class UserModel {
  final String? id;
  final String? email;
  final String? displayName;
  final String? mobileNumber;
  final String? senderFCm;
  final String? profileImage;
  final bool isMessageNotification;
  final bool isGroupNotification;
  final bool isCallNotification;
  final bool isNotificationSound;
  final bool isNotificationVibration;

  UserModel({
    this.id,
    this.email,
    this.displayName,
    this.mobileNumber,
    this.senderFCm,
    this.profileImage,
    this.isMessageNotification = true,
    this.isGroupNotification = true,
    this.isCallNotification = true,
    this.isNotificationSound = true,
    this.isNotificationVibration = true,
  });
}
