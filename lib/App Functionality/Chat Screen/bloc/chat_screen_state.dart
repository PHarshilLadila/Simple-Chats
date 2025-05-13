import 'package:equatable/equatable.dart';

abstract class ChatScreenState extends Equatable {
  const ChatScreenState();

  @override
  List<Object?> get props => [];
}

class ChatScreenInitial extends ChatScreenState {}

class ChatScreenLoading extends ChatScreenState {}

class ChatScreenLoaded extends ChatScreenState {
  final List<Map<String, dynamic>> messages;

  const ChatScreenLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatScreenError extends ChatScreenState {
  final String error;

  const ChatScreenError(this.error);

  @override
  List<Object?> get props => [error];
}
