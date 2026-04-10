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
  final Set<String> selectedMessageIds;

  const ChatScreenLoaded(this.messages, {this.selectedMessageIds = const {}});

  @override
  List<Object?> get props => [messages, selectedMessageIds];
}

class ChatScreenError extends ChatScreenState {
  final String error;

  const ChatScreenError(this.error);

  @override
  List<Object?> get props => [error];
}
