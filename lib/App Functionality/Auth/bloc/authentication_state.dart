import 'package:chat_app_bloc/App%20Functionality/Auth/model/user_model.dart';

abstract class AuthenticationState {
  const AuthenticationState();

  List<Object> get props => [];
}

class AuthenticationInitialState extends AuthenticationState {}

class AuthenticationLoadingState extends AuthenticationState {
  final bool isLoading;

  AuthenticationLoadingState({required this.isLoading});
}

class AuthenticationSuccessState extends AuthenticationState {
  final UserModel user;
  final bool redirectToHome;

  const AuthenticationSuccessState(this.user, {this.redirectToHome = false});

  @override
  List<Object> get props => [user];
}

class AuthenticationFailureState extends AuthenticationState {
  final String errorMessage;

  AuthenticationFailureState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
