abstract class AuthenticationEvent {
  const AuthenticationEvent();

  List<Object> get props => [];
}

class SignUpUser extends AuthenticationEvent {
  final String email;
  final String password;
  final String name;
  final String mobileNumber;
  final String profileimg;

  SignUpUser(
    this.email,
    this.password,
    this.name,
    this.mobileNumber,
    this.profileimg,
  );

  @override
  List<Object> get props => [
        email,
        password,
        name,
        mobileNumber,
        profileimg,
      ];
}

class LoginUser extends AuthenticationEvent {
  final String email;
  final String password;

  LoginUser(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignOutUser extends AuthenticationEvent {}

class FetchUserData extends AuthenticationEvent {}

class SelectProfileUrl extends AuthenticationEvent {
  final dynamic imageUrl;

  const SelectProfileUrl(this.imageUrl);

  @override
  List<Object> get props => [imageUrl];
}

class ForgotPasswordEvent extends AuthenticationEvent {
  final String email;

  ForgotPasswordEvent(this.email);
}
