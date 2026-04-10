// import 'package:chat_app_bloc/functionality/settings/help_and_support/models/support_model.dart';
// import 'package:equatable/equatable.dart';

// abstract class ChatSettingEvent extends Equatable {
//   const ChatSettingEvent();

//   @override
//   List<Object?> get props => [];
// }

// class LoadChatSettings extends ChatSettingEvent {}

// class UpdateWallpaper extends ChatSettingEvent {
//   final String wallpaperPath;
//   const UpdateWallpaper(this.wallpaperPath);

//   @override
//   List<Object?> get props => [wallpaperPath];
// }

// class ResetWallpaper extends ChatSettingEvent {}

// class CreateSupportTicket extends ChatSettingEvent {
//   final String title;
//   final String description;
//   final SupportCategory category;
//   final SupportPriority priority;

//   const CreateSupportTicket({
//     required this.title,
//     required this.description,
//     required this.category,
//     required this.priority,
//   });

//   @override
//   List<Object?> get props => [title, description, category, priority];
// }

// class FetchUserTickets extends ChatSettingEvent {}

// class SendSupportTicketMessage extends ChatSettingEvent {
//   final String ticketId;
//   final String message;
//   final String senderName;

//   const SendSupportTicketMessage({
//     required this.ticketId,
//     required this.message,
//     required this.senderName,
//   });

//   @override
//   List<Object?> get props => [ticketId, message, senderName];
// }

import 'package:chat_app_bloc/functionality/settings/help_and_support/models/support_model.dart';
import 'package:equatable/equatable.dart';

abstract class ChatSettingEvent extends Equatable {
  const ChatSettingEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatSettings extends ChatSettingEvent {}

class UpdateWallpaper extends ChatSettingEvent {
  final String wallpaperPath;
  const UpdateWallpaper(this.wallpaperPath);
  @override
  List<Object?> get props => [wallpaperPath];
}

class ResetWallpaper extends ChatSettingEvent {}

class CreateSupportTicket extends ChatSettingEvent {
  final String title;
  final String description;
  final SupportCategory category;
  final SupportPriority priority;
  const CreateSupportTicket({
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
  });
  @override
  List<Object?> get props => [title, description, category, priority];
}

class FetchUserTickets extends ChatSettingEvent {}

class SendSupportTicketMessage extends ChatSettingEvent {
  final String ticketId;
  final String message;
  final String senderName;
  const SendSupportTicketMessage({
    required this.ticketId,
    required this.message,
    required this.senderName,
  });
  @override
  List<Object?> get props => [ticketId, message, senderName];
}

class UpdateTicketStatus extends ChatSettingEvent {
  final String ticketId;
  final SupportStatus status;
  const UpdateTicketStatus({
    required this.ticketId,
    required this.status,
  });
  @override
  List<Object?> get props => [ticketId, status];
}

class MarkMessagesAsRead extends ChatSettingEvent {
  final String ticketId;
  const MarkMessagesAsRead(this.ticketId);
  @override
  List<Object?> get props => [ticketId];
}

class ListenToTicketUpdates extends ChatSettingEvent {}

class UpdateTicketsList extends ChatSettingEvent {
  final List<SupportTicket> tickets;
  const UpdateTicketsList(this.tickets);
  @override
  List<Object?> get props => [tickets];
}

class ClearError extends ChatSettingEvent {
  const ClearError();
}
