import 'package:chat_app_bloc/App%20Functionality/Auth/view/signin_screen.dart';
import 'package:chat_app_bloc/App%20Functionality/Landing%20Page/view/landing_page.dart';
import 'package:chat_app_bloc/App%20Functionality/Splash%20Screen/bloc/splash_screen_bloc.dart';
import 'package:chat_app_bloc/App%20Functionality/Splash%20Screen/bloc/splash_screen_event.dart';
import 'package:chat_app_bloc/App%20Functionality/Splash%20Screen/bloc/splash_screen_state.dart';
import 'package:chat_app_bloc/Constent/app_color.dart';
import 'package:chat_app_bloc/Constent/app_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SplashScreenBloc>(context)
        .add(NavigateToLoginScreenEvent());

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: BlocConsumer<SplashScreenBloc, SplashScreenState>(
        listener: (context, state) {
          if (state is SplashScreenNavigateToLanding) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LandingPage(),
              ),
            );
          } else if (state is SplashScreenNavigateToLogin) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SigninScreen(),
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/splash.png',
                  width: 160,
                ),
              ),
              const Center(
                child: AppText(
                  text: "Simple Chats",
                  color: Color.fromARGB(255, 80, 76, 76),
                  fontWeight: FontWeight.bold,
                  size: 40,
                  wordSpacing: 0,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
