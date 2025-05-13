import 'package:equatable/equatable.dart';

abstract class SearchingUserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchingUsers extends SearchingUserEvent {
  final String query;

  SearchingUsers(this.query);

  @override
  List<Object?> get props => [query];
}

class FetchUserDatas extends SearchingUserEvent {}

class AllSearchingUsers extends SearchingUserEvent {
  final List allUser;
  AllSearchingUsers(this.allUser);

  @override
  List<Object?> get props => [allUser];
}

class LoadAllUsers extends SearchingUserEvent {}
