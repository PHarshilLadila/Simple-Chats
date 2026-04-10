import 'package:cloud_firestore/cloud_firestore.dart';

enum SupportCategory { technical, account, payment, feature, bug, other }

enum SupportPriority { low, medium, high, critical }

enum SupportStatus { open, inProgress, waitingForUser, resolved, closed }

class SupportTicket {
  final String id;
  final String userId;
  final String title;
  final String description;
  final SupportCategory category;
  final SupportPriority priority;
  final SupportStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool hasUnreadMessages; // Add this field
  final String? assignedTo;
  final List<SupportMessage> messages;

  SupportTicket({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.hasUnreadMessages = false, // Initialize with default
    this.assignedTo,
    this.messages = const [],
  });

  factory SupportTicket.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SupportTicket(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: _stringToCategory(data['category']),
      priority: _stringToPriority(data['priority']),
      status: _stringToStatus(data['status']),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      hasUnreadMessages: data['hasUnreadMessages'] ?? false,
      assignedTo: data['assignedTo'],
      messages: [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'category': category.name,
      'priority': priority.name,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'hasUnreadMessages': hasUnreadMessages,
      'assignedTo': assignedTo,
    };
  }

  static SupportCategory _stringToCategory(String? value) {
    switch (value) {
      case 'technical':
        return SupportCategory.technical;
      case 'account':
        return SupportCategory.account;
      case 'payment':
        return SupportCategory.payment;
      case 'feature':
        return SupportCategory.feature;
      case 'bug':
        return SupportCategory.bug;
      default:
        return SupportCategory.other;
    }
  }

  static SupportPriority _stringToPriority(String? value) {
    switch (value) {
      case 'low':
        return SupportPriority.low;
      case 'medium':
        return SupportPriority.medium;
      case 'high':
        return SupportPriority.high;
      case 'critical':
        return SupportPriority.critical;
      default:
        return SupportPriority.medium;
    }
  }

  static SupportStatus _stringToStatus(String? value) {
    switch (value) {
      case 'open':
        return SupportStatus.open;
      case 'inProgress':
        return SupportStatus.inProgress;
      case 'waitingForUser':
        return SupportStatus.waitingForUser;
      case 'resolved':
        return SupportStatus.resolved;
      case 'closed':
        return SupportStatus.closed;
      default:
        return SupportStatus.open;
    }
  }

  SupportTicket copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    SupportCategory? category,
    SupportPriority? priority,
    SupportStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? hasUnreadMessages,
    String? assignedTo,
    List<SupportMessage>? messages,
  }) {
    return SupportTicket(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      hasUnreadMessages: hasUnreadMessages ?? this.hasUnreadMessages,
      assignedTo: assignedTo ?? this.assignedTo,
      messages: messages ?? this.messages,
    );
  }
}

class SupportMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final bool isFromUser;
  final bool isAutoReply;
  final DateTime timestamp;
  final List<String> attachments;
  final bool isRead; // Add this field

  SupportMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.isFromUser,
    required this.isAutoReply,
    required this.timestamp,
    this.attachments = const [],
    this.isRead = false, // Initialize with default
  });

  factory SupportMessage.fromFirestore(DocumentSnapshot doc, [String? docId]) {
    final data = doc.data() as Map<String, dynamic>;
    return SupportMessage(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? '',
      message: data['message'] ?? '',
      isFromUser: data['isFromUser'] ?? true,
      isAutoReply: data['isAutoReply'] ?? false,
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      attachments: List<String>.from(data['attachments'] ?? []),
      isRead: data['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'isFromUser': isFromUser,
      'isAutoReply': isAutoReply,
      'timestamp': Timestamp.fromDate(timestamp),
      'attachments': attachments,
      'isRead': isRead,
    };
  }
}
