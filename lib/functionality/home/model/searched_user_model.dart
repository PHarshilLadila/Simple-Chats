class SearchedUserModel {
  final String id;
  final String email;
  final String displayName;
  final String mobileNumber;
  final String receiverFCm;
  final String profileImage;
  final DateTime? lastMessageTime;
  final int unreadCount;

  SearchedUserModel({
    required this.id,
    required this.email,
    required this.displayName,
    required this.mobileNumber,
    required this.receiverFCm,
    required this.profileImage,
    this.lastMessageTime,
    this.unreadCount = 0,
  });
}
