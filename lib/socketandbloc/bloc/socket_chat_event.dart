// import 'package:chat_app_bloc/socketandbloc/model/chat_message_model.dart';

// abstract class SocketChatEvent {}

// class SocketSendMessageEvent extends SocketChatEvent {
//   final MessageModel message;
//   SocketSendMessageEvent(this.message);
// }

// class SocketReceiveMessageEvent extends SocketChatEvent {
//   final MessageModel message;
//   SocketReceiveMessageEvent(this.message);
// }
import 'package:equatable/equatable.dart';
import '../model/chat_message_model.dart';

abstract class SocketChatEvent extends Equatable {
  const SocketChatEvent();

  @override
  List<Object?> get props => [];
}

class SocketSendMessageEvent extends SocketChatEvent {
  final MessageModel message;

  const SocketSendMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class SocketReceiveMessageEvent extends SocketChatEvent {
  final MessageModel message;

  const SocketReceiveMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
}
