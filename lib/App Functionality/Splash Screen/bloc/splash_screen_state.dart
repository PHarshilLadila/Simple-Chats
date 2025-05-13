abstract class SplashScreenState {}

class SplashScreenInitialize extends SplashScreenState {}

class SplashScreenLoading extends SplashScreenState {}

class SplasScreenLoaded extends SplashScreenState {}

class SplashScreenNavigateToLanding extends SplashScreenState {}

class SplashScreenNavigateToLogin extends SplashScreenState {}

class SplashScreenError extends SplashScreenState {
  final String error;
  SplashScreenError(this.error);
}
