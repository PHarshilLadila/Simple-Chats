 
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'socket_chat_event.dart';
// import 'socket_chat_state.dart';
// import '../model/chat_message_model.dart';

// class SocketChatBloc extends Bloc<SocketChatEvent, SocketChatState> {
//   SocketChatBloc() : super(SocketChatState(messages: [])) {
//     on<SocketSendMessageEvent>(_onSendMessage);
//     on<SocketReceiveMessageEvent>(_onReceiveMessage);
//   }

//   void _onSendMessage(
//     SocketSendMessageEvent event,
//     Emitter<SocketChatState> emit,
//   ) {
//     final updatedMessages = List<MessageModel>.from(state.messages)
//       ..add(event.message);
//     emit(SocketChatState(messages: updatedMessages));
//   }

//   void _onReceiveMessage(
//     SocketReceiveMessageEvent event,
//     Emitter<SocketChatState> emit,
//   ) {
//     final updatedMessages = List<MessageModel>.from(state.messages)
//       ..add(event.message);
//     emit(SocketChatState(messages: updatedMessages));
//   }
// }
import 'dart:async';
import 'package:chat_app_bloc/socketandbloc/socket/socket_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'socket_chat_event.dart';
import 'socket_chat_state.dart';
import '../model/chat_message_model.dart';
 
class SocketChatBloc extends Bloc<SocketChatEvent, SocketChatState> {
  final String userId;
  late StreamSubscription<MessageModel> _subscription;

  SocketChatBloc({required this.userId}) : super(SocketChatState.initial()) {
    SocketServiceMain().connect(userId);

    // Listen for incoming messages
    _subscription = SocketServiceMain().messages.listen((message) {
      add(SocketReceiveMessageEvent(message));
    });

    on<SocketSendMessageEvent>((event, emit) {
      SocketServiceMain().sendMessage(event.message);
      emit(state.copyWith(
          messages: List.from(state.messages)..add(event.message)));
    });

    on<SocketReceiveMessageEvent>((event, emit) {
      emit(state.copyWith(
          messages: List.from(state.messages)..add(event.message)));
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    SocketServiceMain().disconnect();
    return super.close();
  }
}
