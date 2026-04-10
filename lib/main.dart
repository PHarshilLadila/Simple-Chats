import 'dart:io';

import 'package:chat_app_bloc/functionality/Auth/bloc/authentication_bloc.dart';
import 'package:chat_app_bloc/functionality/Contacts/bloc/contact_bloc.dart';
import 'package:chat_app_bloc/functionality/landing_page/bloc/landing_page_bloc.dart';
import 'package:chat_app_bloc/functionality/profile/bloc/profile_bloc.dart';
import 'package:chat_app_bloc/functionality/home/bloc/searching_user_bloc.dart';
import 'package:chat_app_bloc/functionality/settings/help_and_support/models/app_version_model.dart';
import 'package:chat_app_bloc/functionality/splash_screen/bloc/splash_screen_bloc.dart';
import 'package:chat_app_bloc/functionality/splash_screen/view/splash_screen.dart';
import 'package:chat_app_bloc/functionality/chat_section/bloc/chat_screen_bloc.dart';
import 'package:chat_app_bloc/functionality/settings/chat_setting/bloc/chat_setting_bloc.dart';
import 'package:chat_app_bloc/functionality/settings/chat_setting/bloc/chat_setting_event.dart';
import 'package:chat_app_bloc/functionality/chat_section/helper/call_service.dart';
import 'package:chat_app_bloc/service/analytics_service.dart';
import 'package:chat_app_bloc/service/app_version_service.dart';
import 'package:chat_app_bloc/service/firebase_api.dart';
import 'package:chat_app_bloc/socketandbloc/bloc/socket_chat_bloc.dart';
import 'package:chat_app_bloc/theme/bloc/theme_bloc.dart';
import 'package:chat_app_bloc/theme/bloc/theme_event.dart';
import 'package:chat_app_bloc/theme/bloc/theme_state.dart';
import 'package:chat_app_bloc/theme/helper/theme_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_bloc/connectivity_wrapper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

// GLOBAL USER SESSION VARIABLES
// These variables store currently logged-in user's basic info.
// Used across the app lifecycle (e.g., online/offline status).

String currentUserId = '';
String currentUserName = '';

// FETCH USER DATA FROM LOCAL STORAGE
// Retrieves stored userId and name from SharedPreferences.
// This runs before Firebase & Zego initialization.

Future<void> getCurrentUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? userid = pref.getString('userId');
  String? userName = pref.getString('name');
  currentUserId = userid ?? '';
  currentUserName = userName ?? "";
}

// GLOBAL NAVIGATOR KEY
// Used for navigation outside of BuildContext (e.g., notifications).

final navigatorKey = GlobalKey<NavigatorState>();

// APPLICATION ENTRY POINT
// Initializes:
// - Flutter binding
// - Firebase
// - Zego Call Service
// - Notifications
// - Analytics

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await getCurrentUserId();
  await Firebase.initializeApp();

  //  Update user info in Zego cloud before initializing call service
  if (currentUserId.isNotEmpty) {
    await ZegoService.updateUser(currentUserId, currentUserName);
  }
  debugPrint("user id =--> $currentUserId && user name  --> $currentUserName");

  //  Initialize Zego real-time call service
  await ZegoService.init();

  //  Initialize Firebase Push Notifications
  final firebaseApi = FirebaseApi();
  await firebaseApi.initNotification();

  //  Initialize Analytics Tracking
  final analyticsService = AnalyticsService();
  analyticsService.logAppOpen("App Open");
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

  runApp(MyApp(navigatorKey: navigatorKey));
}

// ROOT APPLICATION WIDGET
// Observes lifecycle changes to manage user online/offline status.

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({super.key, required this.navigatorKey});

  @override
  State<MyApp> createState() => _MyAppState();
}

// APPLICATION LIFECYCLE OBSERVER
// Tracks app state changes to update user presence in Firestore.

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // Called when widget initializes
  // Marks user as "online"
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    updateStatus("online");
    _checkAppVersion();
    _saveDeviceInfo();
  }

  Future<void> _checkAppVersion() async {
    final versionService = AppVersionService();
    final result = await versionService.checkForUpdates();

    if (result.needsUpdate && result.isRequired) {
      _showRequiredUpdateDialog(result);
    } else if (result.needsUpdate && result.isCritical) {
      _showOptionalUpdateDialog(result);
    }
  }

  Future<void> _saveDeviceInfo() async {
    final versionService = AppVersionService();
    await versionService.saveDeviceInfo();
  }

  void _showRequiredUpdateDialog(VersionCheckResult result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: const Text('Update Required'),
          content: Text(
              result.message ?? 'Please update to continue using the app.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Open store for update
                _openStore();
              },
              child: const Text('Update Now'),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionalUpdateDialog(VersionCheckResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Available'),
        content: Text(result.message ?? 'A new version is available.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _openStore();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _openStore() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final packageName = packageInfo.packageName;

    String url = Platform.isAndroid
        ? 'https://play.google.com/store/apps/details?id=$packageName'
        : 'https://apps.apple.com/app/id$packageName';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  // Called when widget disposes
  // Marks user as "offline"
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    updateStatus("offline");
    super.dispose();
  }

  // Detects foreground/background changes
  // Updates real-time user presence in Firestore
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      updateStatus("online");
    } else {
      updateStatus("offline");
    }
  }

  // UPDATE USER STATUS IN FIRESTORE
  // This enables real-time "online/offline" tracking
  void updateStatus(String status) async {
    if (currentUserId.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .update({'status': status});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Firestore instance passed into specific BLoCs
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return MultiBlocProvider(
      providers: [
        // Splash Screen Logic
        BlocProvider<SplashScreenBloc>(
          create: (_) => SplashScreenBloc(),
        ),

        // Authentication Logic
        BlocProvider<AuthenticationBloc>(
          create: (_) => AuthenticationBloc(),
        ),

        // Landing Page Logic
        BlocProvider<LandingPageBloc>(
          create: (_) => LandingPageBloc(),
        ),

        // Duplicate AuthenticationBloc (kept as-is intentionally)
        BlocProvider<AuthenticationBloc>(
          create: (_) => AuthenticationBloc(),
        ),

        // User Search Feature
        BlocProvider<SearchingUserBloc>(
          create: (_) => SearchingUserBloc(firestore),
        ),

        // Contacts Management
        BlocProvider<ContactBloc>(
          create: (_) => ContactBloc(),
        ),

        // Profile Management
        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(),
        ),

        // Real-Time Socket Communication
        BlocProvider<SocketChatBloc>(
          create: (_) => SocketChatBloc(userId: ""),
        ),

        // Chat Screen Logic (Message Handling)
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

        // Theme Management (Light/Dark + Dynamic Color)
        BlocProvider<ThemeBloc>(
          create: (_) => ThemeBloc()..add(LoadThemeEvent()),
        ),
        // Chat Settings (Wallpaper, etc.)
        BlocProvider<ChatSettingBloc>(
          create: (_) => ChatSettingBloc()..add(LoadChatSettings()),
        ),
      ],

      // THEME STATE BUILDER
      // Dynamically updates theme when ThemeBloc state changes

      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            navigatorKey: widget.navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',

            // Light/Dark Mode Control
            themeMode: themeState.themeMode,

            // Dynamic Primary Color Theming
            theme: AppThemeHelper(
              primaryColor: themeState.primaryColor,
            ).lightTheme,

            // Initial Screen
            home: const SplashScreen(),

            // Connectivity Wrapper
            // Shows internet connection status globally
            builder: (context, child) {
              return ConnectivityWrapper(
                navigatorKey: widget.navigatorKey,
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
