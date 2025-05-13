import 'package:chat_app_bloc/App%20Functionality/Auth/model/user_model.dart';
import 'package:chat_app_bloc/App%20Functionality/Search%20User/model/searched_user_model.dart';
import 'package:equatable/equatable.dart';

abstract class SearchingUserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchingUserInitial extends SearchingUserState {}

class SearchingUserLoading extends SearchingUserState {}

class SearchingUserLoaded extends SearchingUserState {
  // final List<UserModel> users;
  final List<SearchedUserModel> users;
  final List<UserModel> userModel;
  SearchingUserLoaded(
    this.users,
    this.userModel,
  );

  @override
  List<Object?> get props => [users];
}

class SearchingUserError extends SearchingUserState {
  final String message;

  SearchingUserError(this.message);

  @override
  List<Object?> get props => [message];
}
