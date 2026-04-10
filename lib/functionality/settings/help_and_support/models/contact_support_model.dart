import 'package:cloud_firestore/cloud_firestore.dart';

enum ContactMethod {
  email,
  phone,
  chat,
  whatsapp,
}

enum InquiryType {
  general,
  technical,
  feature,
  complaint,
  other,
}

enum ContactStatus {
  pending,
  inProgress,
  resolved,
  closed,
}

class ContactInquiry {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String subject;
  final String message;
  final InquiryType type;
  final ContactMethod preferredContact;
  final List<String> attachments;
  final DateTime createdAt;
  final ContactStatus status;
  final String? response;
  final DateTime? respondedAt;
  final DateTime? updatedAt; // Add this field

  ContactInquiry({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.subject,
    required this.message,
    required this.type,
    required this.preferredContact,
    this.attachments = const [],
    required this.createdAt,
    this.status = ContactStatus.pending,
    this.response,
    this.respondedAt,
    this.updatedAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName.isNotEmpty ? userName : 'User',
      'userEmail': userEmail,
      'subject': subject,
      'message': message,
      'type': type.name,
      'preferredContact': preferredContact.name,
      'attachments': attachments,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status.name,
      'response': response,
      'respondedAt':
          respondedAt != null ? Timestamp.fromDate(respondedAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  factory ContactInquiry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ContactInquiry(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'User',
      userEmail: data['userEmail'] ?? '',
      subject: data['subject'] ?? '',
      message: data['message'] ?? '',
      type: _parseInquiryType(data['type']),
      preferredContact: _parseContactMethod(data['preferredContact']),
      attachments: _parseAttachments(data['attachments']),
      createdAt: _parseTimestamp(data['createdAt']),
      status: _parseStatus(data['status']),
      response: data['response'],
      respondedAt: _parseTimestamp(data['respondedAt']),
      updatedAt: _parseTimestamp(data['updatedAt']),
    );
  }

  static InquiryType _parseInquiryType(dynamic value) {
    if (value == null) return InquiryType.general;
    try {
      return InquiryType.values.firstWhere(
        (e) => e.name == value,
        orElse: () => InquiryType.general,
      );
    } catch (e) {
      return InquiryType.general;
    }
  }

  static ContactMethod _parseContactMethod(dynamic value) {
    if (value == null) return ContactMethod.email;
    try {
      return ContactMethod.values.firstWhere(
        (e) => e.name == value,
        orElse: () => ContactMethod.email,
      );
    } catch (e) {
      return ContactMethod.email;
    }
  }

  static ContactStatus _parseStatus(dynamic value) {
    if (value == null) return ContactStatus.pending;
    try {
      return ContactStatus.values.firstWhere(
        (e) => e.name == value,
        orElse: () => ContactStatus.pending,
      );
    } catch (e) {
      return ContactStatus.pending;
    }
  }

  static List<String> _parseAttachments(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return List<String>.from(value);
    }
    return [];
  }

  static DateTime _parseTimestamp(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    return DateTime.now();
  }

  ContactInquiry copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userEmail,
    String? subject,
    String? message,
    InquiryType? type,
    ContactMethod? preferredContact,
    List<String>? attachments,
    DateTime? createdAt,
    ContactStatus? status,
    String? response,
    DateTime? respondedAt,
    DateTime? updatedAt,
  }) {
    return ContactInquiry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      type: type ?? this.type,
      preferredContact: preferredContact ?? this.preferredContact,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      response: response ?? this.response,
      respondedAt: respondedAt ?? this.respondedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
