import 'package:cloud_firestore/cloud_firestore.dart';

enum SupportStatus {
  open,
  inProgress,
  waitingForUser,
  resolved,
  closed,
}

enum SupportCategory {
  technical,
  account,
  payment,
  feature,
  bug,
  other,
}

enum SupportPriority {
  low,
  medium,
  high,
  critical,
}

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
  final String? assignedTo;
  final bool hasUnreadMessages;

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
    this.assignedTo,
    this.hasUnreadMessages = false,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'category': category.name,
      'priority': priority.name,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'assignedTo': assignedTo,
      'hasUnreadMessages': hasUnreadMessages,
    };
  }

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
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      assignedTo: data['assignedTo'],
      hasUnreadMessages: data['hasUnreadMessages'] ?? false,
    );
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
}

class SupportMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final bool isFromUser;
  final bool isAutoReply;
  final List<String> attachments;
  final DateTime timestamp;
  final bool isRead;

  SupportMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.isFromUser,
    this.isAutoReply = false,
    this.attachments = const [],
    required this.timestamp,
    this.isRead = false,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'isFromUser': isFromUser,
      'isAutoReply': isAutoReply,
      'attachments': attachments,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
    };
  }

  factory SupportMessage.fromFirestore(DocumentSnapshot doc, String docId) {
    final data = doc.data() as Map<String, dynamic>;
    return SupportMessage(
      id: docId,
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? '',
      message: data['message'] ?? '',
      isFromUser: data['isFromUser'] ?? true,
      isAutoReply: data['isAutoReply'] ?? false,
      attachments: List<String>.from(data['attachments'] ?? []),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
    );
  }
}
