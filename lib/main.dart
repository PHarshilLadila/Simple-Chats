import 'package:chat_app_bloc/App%20Functionality/Auth/bloc/authentication_bloc.dart';
import 'package:chat_app_bloc/App%20Functionality/Chat%20Screen/bloc/chat_screen_bloc.dart';
import 'package:chat_app_bloc/App%20Functionality/Chat%20Screen/helper/call_service.dart';
import 'package:chat_app_bloc/App%20Functionality/Contacts/bloc/contact_bloc.dart';
import 'package:chat_app_bloc/App%20Functionality/Landing%20Page/bloc/landing_page_bloc.dart';
import 'package:chat_app_bloc/App%20Functionality/Profile/bloc/profile_bloc.dart';
import 'package:chat_app_bloc/App%20Functionality/Search%20User/bloc/searching_user_bloc.dart';
import 'package:chat_app_bloc/App%20Functionality/Splash%20Screen/bloc/splash_screen_bloc.dart';
import 'package:chat_app_bloc/App%20Functionality/Splash%20Screen/view/splash_screen.dart';
import 'package:chat_app_bloc/Constent/app_color.dart';
import 'package:chat_app_bloc/Service/analytics_service.dart';
import 'package:chat_app_bloc/Service/firebase_api.dart';
import 'package:chat_app_bloc/socketandbloc/bloc/socket_chat_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

String currentUserId = '';
String currentUserName = '';
void getCurrentUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? userid = pref.getString('userId');
  String? userName = pref.getString('name');
  currentUserId = userid ?? '';
  currentUserName = userName ?? "";
}

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  getCurrentUserId();
  await Firebase.initializeApp();
  await ZegoService.updateUser(currentUserId, currentUserName);
  debugPrint("user id =--> $currentUserId && user name  --> $currentUserName");
  await ZegoService.init();

  final firebaseApi = FirebaseApi();
  await firebaseApi.initNotification();
  final analyticsService = AnalyticsService();
  analyticsService.logAppOpen("App Open");
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

  runApp(MyApp(navigatorKey: navigatorKey));
}

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({super.key, required this.navigatorKey});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashScreenBloc>(
          create: (_) => SplashScreenBloc(),
        ),
        BlocProvider<AuthenticationBloc>(
          create: (_) => AuthenticationBloc(),
        ),
        BlocProvider<LandingPageBloc>(
          create: (_) => LandingPageBloc(),
        ),
        BlocProvider<AuthenticationBloc>(
          create: (_) => AuthenticationBloc(),
        ),
        BlocProvider<SearchingUserBloc>(
          create: (_) => SearchingUserBloc(firestore),
        ),
        BlocProvider<ContactBloc>(
          create: (_) => ContactBloc(),
        ),
        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(),
        ),
        BlocProvider<SocketChatBloc>(
          create: (_) => SocketChatBloc(userId: ""),
        ),
        BlocProvider<ChatScreenBloc>(
          create: (context) => ChatScreenBloc(
            "chatId",
            "CurentUserName",
            "SenderName",
            "ReceiverName",
            "SenderUid",
            "receiverUid",
            "senderFCM",
          ),
        ),
      ],
      child: MaterialApp(
        navigatorKey: widget.navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColor.mainColor),
          useMaterial3: true,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
