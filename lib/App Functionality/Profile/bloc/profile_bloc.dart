import 'package:chat_app_bloc/App%20Functionality/Auth/model/user_model.dart';
import 'package:chat_app_bloc/App%20Functionality/Profile/bloc/profile_event.dart';
import 'package:chat_app_bloc/App%20Functionality/Profile/bloc/profile_state.dart';
import 'package:chat_app_bloc/Service/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<GetProfileData>(getUserDataToProfile);
    on<SelectProfile>(selectImage);
    on<GetProfileImage>(getProfileImage);
    add(GetProfileData());
    add(GetProfileImage());
  }
  void getUserDataToProfile(
      ProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final AuthService authService = AuthService();

    try {
      final UserModel? user = await authService.getCurrentUserData();

      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(const ProfileError('Failed to fetch profile data'));
      }
    } catch (e) {
      debugPrint("Error in Get Profile Data : ${e.toString()}");
      emit(ProfileError(e.toString()));
    }
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> selectImage(
      SelectProfile event, Emitter<ProfileState> emit) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final userUID = user?.uid;
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    String base64Image = event.imageUrl;

    await preferences.setString('profile', base64Image);

    try {
      // await firestore.collection('users').doc(userUID).set(
      //   {'profile': base64Image},
      //   SetOptions(merge: true),
      await firestore.collection('users').doc(userUID).update(
        {'profile': base64Image},
      );
      debugPrint("profile Image Store successfully in");
    } catch (e) {
      debugPrint("Error in update the profile ${e.toString()}");
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> getProfileImage(
      GetProfileImage event, Emitter<ProfileState> emit) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final userUID = user?.uid;

    if (userUID == null) {
      // Correct condition
      emit(const ProfileError("User is not logged in."));
      return;
    }

    final SharedPreferences preferences = await SharedPreferences.getInstance();
    emit(ProfileLoading());

    try {
      DocumentSnapshot documentSnapshot =
          await firestore.collection('users').doc(userUID).get();

      if (!documentSnapshot.exists) {
        emit(const ProfileError("User profile does not exist."));
        return;
      }

      String? imageUrl = documentSnapshot.get('profile') ?? "";
      String? profileUserNames = documentSnapshot.get('name') ?? "N/A";
      String? profileUserMobile = documentSnapshot.get('mobileNumber') ?? "N/A";

      await preferences.setString('profile', imageUrl!);

      final UserModel userModel = UserModel(
        id: userUID,
        email: user!.email!,
        displayName: profileUserNames,
        mobileNumber: profileUserMobile,
        profileImage: imageUrl,
      );

      emit(ProfileLoaded(userModel));
    } catch (e) {
      debugPrint("Failed To Load Profile Picture: ${e.toString()}");
      emit(ProfileError("Failed to load profile picture: ${e.toString()}"));
    }
  }
}
