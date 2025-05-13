import 'package:chat_app_bloc/App%20Functionality/Auth/model/user_model.dart';
import 'package:chat_app_bloc/Service/send_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final SendNotification sendNotification = SendNotification();
  String? token = "";
  Future<void> saveUserLocally(UserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user.id!);
    await prefs.setString('email', user.email!);
    await prefs.setString('name', user.displayName!);
    await prefs.setString('mobileNumber', user.mobileNumber!);
    debugPrint("=> User saved locally: $user");
  }

  Future<UserModel?> getUserFromLocalStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId == null) return null;

    await messaging.deleteToken();
    String? token = await messaging.getToken();
    await prefs.setString("fcmToken", token!);
    debugPrint(
        "==================> FCMTOKEN ================> ${prefs.getString('fcmToken')}");
    // ignore: unnecessary_null_comparison
    if (token != null) {
      await sendNotification.sendFCMTokenToUser(userId, token);
    }
    var localUserData = UserModel(
      id: userId,
      email: prefs.getString('email') ?? "",
      displayName: prefs.getString('name') ?? "",
      mobileNumber: prefs.getString('mobileNumber') ?? "",
      senderFCm: prefs.getString('fcmToken'),
    );
    debugPrint("=> Local User Data (getUserlocalStorage): $localUserData");

    return localUserData;
  }

  Future<void> clearUserFromLocalStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<UserModel?> signUpUser(
    String email,
    String password,
    String name,
    String mobileNumber,
    String profileImg,
  ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        await messaging.deleteToken();

        token = await messaging.getToken();
        await prefs.setString("fcmToken", token!);
        debugPrint("===> FCMTOKEN ===> ${prefs.getString('fcmToken')}");

        if (token != null) {
          debugPrint('=> SEND FCM TOKEN TO USER: $token');
          sendNotification.sendFCMTokenToUser(firebaseUser.uid, token ?? '');
        }

        await firestore.collection('users').doc(firebaseUser.uid).set({
          'name': name.trim(),
          'email': email.trim(),
          'mobileNumber': mobileNumber.trim(),
          'profile': profileImg,
          'fcmToken': prefs.getString('fcmToken'), //
        });

        return UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email,
          displayName: name,
          mobileNumber: mobileNumber,
          profileImage: profileImg,
          senderFCm: token,
        );
      }
    } catch (e) {
      debugPrint("=> SignUp Error: $e");
    }
    return null;
  }

  Future<UserModel?> loginUser(String email, String password) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        DocumentSnapshot userDoc =
            await firestore.collection('users').doc(firebaseUser.uid).get();

        if (userDoc.exists) {
          await messaging.deleteToken();
          token = await messaging.getToken();
          await prefs.setString("fcmToken", token!);
          debugPrint(
              "==================> FCMTOKEN ================> ${prefs.getString('fcmToken')}");
          if (token != null) {
            //      await FirebaseFirestore.instance
            // .collection('users')
            // .doc(firebaseUser.uid)
            // .update({'fcmToken': token});

            debugPrint('=> SEND FCM TOKEN TO USER: $token');
            sendNotification.sendFCMTokenToUser(firebaseUser.uid, token ?? '');
          }

          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          UserModel user = UserModel(
            id: firebaseUser.uid,
            email: userData['email'] ?? "N/A",
            displayName: userData['name'] ?? "N/A",
            mobileNumber: userData['mobileNumber'] ?? "N/A",
            senderFCm: prefs.getString('fcmToken') ?? "N/A",
            profileImage: userData['profile'] ?? "N/A",
          );

          // Save user details locally
          await saveUserLocally(user);
          debugPrint("=> saveUserLocally from login: $user");
          return user;
        }
      }
    } catch (e) {
      debugPrint("=> Login Error: $e");
    }
    return null;
  }

  Future<void> signOutUser() async {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await messaging.deleteToken();

      debugPrint("=> Signing out user: ${firebaseUser.uid}");
      await FirebaseAuth.instance.signOut();
      debugPrint(" User signed out successfully from Firebase");

      await clearUserFromLocalStorage();
      debugPrint("=> User signed out successfully from Local Storage");
    }
  }

  Future<UserModel?> getCurrentUserData() async {
    final User? firebaseUser = firebaseAuth.currentUser;
    if (firebaseUser == null) {
      debugPrint("=> No user logged in.");
      return null;
    }

    try {
      debugPrint("=> Fetching user data for UID: ${firebaseUser.uid}");

      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(firebaseUser.uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        debugPrint("=> User data fetched: $userData");

        return UserModel(
          id: firebaseUser.uid,
          email: userData['email'] ?? "N/A",
          displayName: userData['name'] ?? "N/A",
          mobileNumber: userData['mobileNumber'] ?? "N/A",
        );
      } else {
        debugPrint("=> User document does not exist!");
      }
    } catch (e) {
      debugPrint("=> Fetch User Data Error: $e");
    }
    return null;
  }
}
