// import 'package:chat_app_bloc/App%20Functionality/Splash%20Screen/bloc/splash_screen_event.dart';
// import 'package:chat_app_bloc/App%20Functionality/Splash%20Screen/bloc/splash_screen_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
//   SplashScreenBloc() : super(SplashScreenInitialize()) {
//     on<NavigateToLoginScreenEvent>((event, emit) async {
//       emit(SplashScreenLoading());
//       await Future.delayed(const Duration(seconds: 3));
//       emit(SplasScreenLoaded());
//     });
//   }
// }

import 'package:chat_app_bloc/App%20Functionality/Splash%20Screen/bloc/splash_screen_event.dart';
import 'package:chat_app_bloc/App%20Functionality/Splash%20Screen/bloc/splash_screen_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenBloc() : super(SplashScreenInitialize()) {
    on<NavigateToLoginScreenEvent>(_checkUserLoginStatus);
  }

  Future<void> _checkUserLoginStatus(
      NavigateToLoginScreenEvent event, Emitter<SplashScreenState> emit) async {
    emit(SplashScreenLoading());
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? userid = pref.getString('userId');
    await Future.delayed(const Duration(seconds: 2));

    if (userid != null) {
      debugPrint("=> navigate to landing");
      emit(SplashScreenNavigateToLanding());
    } else {
      debugPrint("=> navigate to login");
      emit(SplashScreenNavigateToLogin());
    }
  }
}
