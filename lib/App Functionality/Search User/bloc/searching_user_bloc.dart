import 'package:chat_app_bloc/App%20Functionality/Search%20User/model/searched_user_model.dart';
import 'package:chat_app_bloc/Constent/app_string.dart';
import 'package:chat_app_bloc/Service/send_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'searching_user_event.dart';
import 'searching_user_state.dart';

class SearchingUserBloc extends Bloc<SearchingUserEvent, SearchingUserState> {
  final FirebaseFirestore firestore;
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final SendNotification sendNotification = SendNotification();

  SearchingUserBloc(this.firestore) : super(SearchingUserInitial()) {
    on<SearchingUsers>(_onSearchingUsers);
    on<LoadAllUsers>(_onLoadAllUsers);
  }

  Future<void> _onSearchingUsers(
      SearchingUsers event, Emitter<SearchingUserState> emit) async {
    emit(SearchingUserLoading());
    try {
      List<SearchedUserModel> users =
          await _retrieveSearchableUserData(event.query);
      emit(users.isEmpty
          ? SearchingUserError("No users found.")
          : SearchingUserLoaded(users, const []));
    } catch (e) {
      emit(SearchingUserError(e.toString()));
    }
  }

  Future<void> _onLoadAllUsers(
      LoadAllUsers event, Emitter<SearchingUserState> emit) async {
    emit(SearchingUserLoading());
    try {
      QuerySnapshot querySnapshot = await firestore.collection('users').get();
      List<SearchedUserModel> users =
          await Future.wait(querySnapshot.docs.map((doc) async {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        final FirebaseAuth auth = FirebaseAuth.instance;
        final User? user = auth.currentUser;
        final userUID = user?.uid;

        if (userUID == doc.id) {
          debugPrint('current user $userUID && searched user ${doc.id}');
        }

        String? fcmToken = data['fcmToken'] ?? "N/A";
        if (fcmToken == "N/A") {
          fcmToken = await messaging.getToken();
          if (fcmToken != null) {
            await firestore
                .collection('users')
                .doc(doc.id)
                .update({'fcmToken': fcmToken});
          }
        }
        String? profileImg = data['profile'] ?? "N/A";
        if (profileImg == "N/A") {
          profileImg = await messaging.getToken();
          if (profileImg != null) {
            await firestore
                .collection('users')
                .doc(doc.id)
                .update({'profileImg': profileImg});
          }
        }

        return SearchedUserModel(
          id: doc.id,
          email: data['email'] ?? "N/A",
          displayName: data['name'] ?? "N/A",
          mobileNumber: data['mobileNumber'] ?? "N/A",
          receiverFCm: fcmToken ?? "N/A",
          profileImage: data["profile"] ?? AppString.demoImgurl,
        );
      }).toList());

      emit(SearchingUserLoaded(users, const []));
    } catch (e) {
      emit(SearchingUserError(e.toString()));
    }
  }

  Future<List<SearchedUserModel>> _retrieveSearchableUserData(
      String query) async {
    List<SearchedUserModel> users = [];

    if (query.isNotEmpty) {
      // Search by name
      QuerySnapshot nameQuerySnapshot = await firestore
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: query.trim())
          .where('name', isLessThanOrEqualTo: '${query.trim()}\uf8ff')
          .get();
      users.addAll(await _mapQueryToUsers(nameQuerySnapshot));

      // Search by mobile number
      QuerySnapshot mobileNumberQuerySnapshot = await firestore
          .collection('users')
          .where('mobileNumber', isEqualTo: query.trim())
          .get();
      users.addAll(await _mapQueryToUsers(mobileNumberQuerySnapshot));

      // Search by email
      QuerySnapshot emailQuerySnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: query.trim())
          .get();
      users.addAll(await _mapQueryToUsers(emailQuerySnapshot));

      users = users.toSet().toList();
    }

    return users;
  }

  Future<List<SearchedUserModel>> _mapQueryToUsers(
      QuerySnapshot querySnapshot) async {
    return Future.wait(querySnapshot.docs.map((doc) async {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      final userUID = user?.uid;

      if (userUID == doc.id) {
        debugPrint('current user $userUID && searched user ${doc.id}');
      }

      String? fcmToken = data['fcmToken'] ?? "N/A";
      if (fcmToken == "N/A") {
        fcmToken = await messaging.getToken();
        if (fcmToken != null) {
          await firestore
              .collection('users')
              .doc(doc.id)
              .update({'fcmToken': fcmToken});
        }
      }

      String? profileImg = data['profile'] ?? "N/A";
      if (profileImg == "N/A") {
        profileImg = await messaging.getToken();
        if (profileImg != null) {
          await firestore
              .collection('users')
              .doc(doc.id)
              .update({'profileImg': profileImg});
        }
      }
      return SearchedUserModel(
        id: doc.id,
        email: data['email'] ?? "N/A",
        displayName: data['name'] ?? "N/A",
        mobileNumber: data['mobileNumber'] ?? "N/A",
        receiverFCm: fcmToken!,
        profileImage: data["profile"] ?? AppString.demoImgurl,
      );
    }).toList());
  }
}

 
//   //       users,
//   //       [
//   //         UserModel(
//   //           id: datas['id'],
//   //           email: datas['email'],
//   //           displayName: datas['displayName'],
//   //           mobileNumber: datas['mobileNumber'],
//   //         )
//   //       ],
//   //     ));
//   // String? token = await messaging.getToken();
//   // if (token != null) {
//   //   debugPrint('=> SEND FCM TOKEN TO USER: $token');
//   //   for (var user in users) {
//   //     sendNotification.sendFCMTokenToUser(user.id, token);
//   //   }
//   // }
//   //   } catch (e) {
//   //     emit(SearchingUserError(e.toString()));
//   //   }
//   // }