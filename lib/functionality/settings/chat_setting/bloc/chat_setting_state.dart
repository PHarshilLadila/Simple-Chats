// import 'package:chat_app_bloc/functionality/settings/help_and_support/models/support_model.dart';
// import 'package:equatable/equatable.dart';

// class ChatSettingState extends Equatable {
//   final String wallpaperPath;
//   final bool isDefault;
//   final List<SupportTicket> tickets;
//   final bool isLoading;
//   final String? error;

//   const ChatSettingState({
//     this.wallpaperPath = 'assets/images/background.jpg',
//     this.isDefault = true,
//     this.tickets = const [],
//     this.isLoading = false,
//     this.error,
//   });

//   ChatSettingState copyWith({
//     String? wallpaperPath,
//     bool? isDefault,
//     List<SupportTicket>? tickets,
//     bool? isLoading,
//     String? error,
//   }) {
//     return ChatSettingState(
//       wallpaperPath: wallpaperPath ?? this.wallpaperPath,
//       isDefault: isDefault ?? this.isDefault,
//       tickets: tickets ?? this.tickets,
//       isLoading: isLoading ?? this.isLoading,
//       error: error,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         wallpaperPath,
//         isDefault,
//         tickets,
//         isLoading,
//         error,
//       ];
// }

import 'package:chat_app_bloc/functionality/settings/chat_setting/bloc/chat_setting_event.dart';
import 'package:chat_app_bloc/functionality/settings/help_and_support/models/support_model.dart';
import 'package:equatable/equatable.dart';

class ChatSettingState extends Equatable {
  final String wallpaperPath;
  final bool isDefault;
  final List<SupportTicket> tickets;
  final bool isLoading;
  final String? error;
  final String? successMessage;

  const ChatSettingState({
    this.wallpaperPath = 'assets/images/background.jpg',
    this.isDefault = true,
    this.tickets = const [],
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  ChatSettingState copyWith({
    String? wallpaperPath,
    bool? isDefault,
    List<SupportTicket>? tickets,
    bool? isLoading,
    String? error,
    String? successMessage,
  }) {
    return ChatSettingState(
      wallpaperPath: wallpaperPath ?? this.wallpaperPath,
      isDefault: isDefault ?? this.isDefault,
      tickets: tickets ?? this.tickets,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        wallpaperPath,
        isDefault,
        tickets,
        isLoading,
        error,
        successMessage,
      ];
}
