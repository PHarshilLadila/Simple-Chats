import 'package:chat_app_bloc/App%20Functionality/Landing%20Page/bloc/landing_page_event.dart';
import 'package:chat_app_bloc/App%20Functionality/Landing%20Page/bloc/landing_page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingPageBloc extends Bloc<LandingPageEvent, LandingPageState> {
  LandingPageBloc() : super(const LandingPageInitial(tabIndex: 0)) {
    on<LandingPageEvent>((event, emit) {
      if (event is TabChange) {
        debugPrint("=> ${event.tabIndex}");
        emit(LandingPageInitial(tabIndex: event.tabIndex));
      }
    });
  }
}
