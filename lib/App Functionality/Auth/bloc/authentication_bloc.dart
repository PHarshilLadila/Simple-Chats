import 'package:chat_app_bloc/App%20Functionality/Chat%20Screen/view/chat_screen.dart';
import 'package:chat_app_bloc/Service/auth_service.dart';
import 'package:chat_app_bloc/App%20Functionality/Auth/bloc/authentication_event.dart';
import 'package:chat_app_bloc/App%20Functionality/Auth/bloc/authentication_state.dart';
import 'package:chat_app_bloc/App%20Functionality/Auth/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthService authService = AuthService();

  AuthenticationBloc() : super(AuthenticationInitialState()) {
    on<SignUpUser>(signUpUsers);
    on<LoginUser>(loginUsers);
    on<FetchUserData>(fetchUsersData);
    on<SignOutUser>(signOutUsers);
    on<SelectProfileUrl>(selectImageProfileUrl);
    on<ForgotPasswordEvent>(forgotpassword);
  }
  String profileImageUrl = "";

  Future<void> signUpUsers(
      SignUpUser event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoadingState(isLoading: true));
    try {
      final UserModel? user = await authService.signUpUser(
        event.email,
        event.password,
        event.name,
        event.mobileNumber,
        event.profileimg,
      );

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await firestore.collection('users').doc(user!.id).set({
        'name': user.displayName,
        'email': user.email,
        'mobileNumber': user.mobileNumber,
        'profile': event.profileimg,
        'fcmToken': prefs.getString('fcmToken'), //
      });
      // ignore: unnecessary_null_comparison
      if (user != null) {
        emit(AuthenticationSuccessState(user));
      } else {
        emit(AuthenticationFailureState('Create user failed'));
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("SignUp Error: $e");
      emit(AuthenticationFailureState(e.toString()));
    }
  }

  Future<void> loginUsers(
      LoginUser event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoadingState(isLoading: true));
    try {
      final UserModel? user = await authService.loginUser(
        event.email,
        event.password,
        // profileImageUrl
      );

      if (user != null) {
        emit(AuthenticationSuccessState(user));
      } else {
        emit(AuthenticationFailureState('Login failed'));
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("Login Error: $e");
      emit(AuthenticationFailureState(e.toString()));
    }
  }

  Future<void> forgotpassword(
      ForgotPasswordEvent event, Emitter<AuthenticationState> emit) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    try {
      await firebaseAuth.sendPasswordResetEmail(email: event.email);
    } catch (e, stackTrace) {
      debugPrint("Forgot Password Error: $e");
      debugPrint("Stack Trace: $stackTrace");
      emit(
        AuthenticationFailureState(
          e.toString(),
        ),
      );
      Text("$e");
    }
  }

  Future<void> fetchUsersData(
      FetchUserData event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoadingState(isLoading: false));
    try {
      final UserModel? user = await authService.getCurrentUserData();

      if (user != null) {
        emit(AuthenticationSuccessState(user));
      } else {
        emit(AuthenticationFailureState('Failed to fetch user data'));
      }
    } catch (e) {
      debugPrint("FetchUserData Error: $e");
      emit(AuthenticationFailureState(e.toString()));
    }
  }

  void signOutUsers(
      SignOutUser event, Emitter<AuthenticationState> emit) async {
    await authService.signOutUser();
    emit(AuthenticationInitialState());
  }

  Future<void> selectImageProfileUrl(
      SelectProfileUrl event, Emitter<AuthenticationState> emit) async {
    // final FirebaseAuth auth = FirebaseAuth.instance;
    // final User? user = auth.currentUser;
    // final userUID = user?.uid;

    String base64Image = event.imageUrl;
    profileImageUrl = base64Image;

    try {
      // await firestore.collection('users').doc(userUID).set(
      //   {'profile': base64Image},
      //   SetOptions(merge: true),
      // );
      // debugPrint("profile Image Store successfully in");
    } catch (e) {
      debugPrint("Error in update the profile ${e.toString()}");
      emit(AuthenticationFailureState(e.toString()));
    }
  }
}
