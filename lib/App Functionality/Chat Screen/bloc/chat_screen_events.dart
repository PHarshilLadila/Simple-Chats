import 'package:equatable/equatable.dart';

abstract class ChatScreenEvents extends Equatable {
  const ChatScreenEvents();
  @override
  List<Object?> get props => [];
}

class OnSendMessage extends ChatScreenEvents {
  final String message;

  const OnSendMessage(
    this.message,
  );
  @override
  List<Object?> get props => [message];
}

class OnSendImage extends ChatScreenEvents {
  final List<String> images;

  const OnSendImage(
    this.images,
  );

  @override
  List<Object?> get props => [images];
}

class Loadmessages extends ChatScreenEvents {}

class StartListeningMessages extends ChatScreenEvents {}

class FetchCurrentUserData extends ChatScreenEvents {}

class ClearMessages extends ChatScreenEvents {}
