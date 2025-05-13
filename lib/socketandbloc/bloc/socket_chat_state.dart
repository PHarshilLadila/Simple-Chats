// import 'package:chat_app_bloc/socketandbloc/model/chat_message_model.dart';

// class SocketChatState {
//   final List<MessageModel> messages;

//   SocketChatState({required this.messages});

//   SocketChatState copyWith({List<MessageModel>? messages}) {
//     return SocketChatState(
//       messages: messages ?? this.messages,
//     );
//   }
// }
 import '../model/chat_message_model.dart';

// class SocketChatState extends Equatable {
//   final List<MessageModel> messages;

//   const SocketChatState({required this.messages});
//   SocketChatState copyWith({List<MessageModel>? messages}) {
//     return SocketChatState(
//       messages: messages ?? this.messages,
//     );
//   }

//   @override
//   List<Object?> get props => [messages];
// }

class SocketChatState {
  final List<MessageModel> messages;

  SocketChatState({required this.messages});

  SocketChatState copyWith({List<MessageModel>? messages}) {
    return SocketChatState(
      messages: messages ?? this.messages,
    );
  }

  static SocketChatState initial() {
    return SocketChatState(messages: []);
  }
}
