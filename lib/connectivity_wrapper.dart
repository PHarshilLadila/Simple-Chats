import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'app_widget/no_internet_bottom_sheet.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;
  const ConnectivityWrapper({
    super.key,
    required this.child,
    required this.navigatorKey,
  });

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  final Connectivity internetConnectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> internetSubscription;

  @override
  void initState() {
    super.initState();
    internetSubscription = internetConnectivity.onConnectivityChanged
        .listen(updateConnectionStatus);
    checkInitialConnection();
  }

  void checkInitialConnection() async {
    final results = await internetConnectivity.checkConnectivity();
    updateConnectionStatus(results);
  }

  void updateConnectionStatus(List<ConnectivityResult> results) {
    bool hasInternet =
        results.any((result) => result != ConnectivityResult.none);

    if (hasInternet) {
      handleStateChange(true);
    } else {
      // Short delay to avoid blips
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!mounted) return;
        internetConnectivity.checkConnectivity().then((currentResults) {
          bool stillOffline = currentResults
              .every((result) => result == ConnectivityResult.none);
          if (stillOffline) {
            handleStateChange(false);
          }
        });
      });
    }
  }

  void handleStateChange(bool hasInternet) {
    final context = widget.navigatorKey.currentContext;
    if (context == null) return;

    if (hasInternet) {
      NoInternetBottomSheet.hide(context);
    } else {
      NoInternetBottomSheet.show(context);
    }
  }

  @override
  void dispose() {
    internetSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
