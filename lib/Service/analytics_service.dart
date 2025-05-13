import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class AnalyticsService {
  final FirebaseAnalytics instance = FirebaseAnalytics.instance;

  Future<void> logScreenView(String screenName) async {
    await instance.setAnalyticsCollectionEnabled(true);
    await instance.logScreenView(
      screenClass: screenName,
      screenName: screenName,
    );
    debugPrint("✅ logScreenView called: $screenName");
  }

  void logSearchEvent(String searchTerm) async {
    await instance.logSearch(searchTerm: searchTerm);
    debugPrint("Search logged: $searchTerm");
  }

  Future<void> logLogin(String method) async {
    await instance.logLogin(loginMethod: method);
  }

  Future<void> logSearchBarToggle(String searchToggle) async {
    await instance.logEvent(
      name: "search_bar_toggle",
      parameters: {
        "is_enabled": searchToggle,
      },
    );
    debugPrint("🔍 Search bar toggle logged: $searchToggle");
  }

  Future<void> logLogOut(String userLogout) async {
    await instance.logEvent(
      name: "UserSignOut",
      parameters: {
        "UserLogOut": userLogout,
      },
    );
    debugPrint("=> User Log Out: $userLogout");
  }

  Future<void> logchatIdOpen(String chatId) async {
    await instance.logEvent(
      name: "Open_ChatId",
      parameters: {
        "ChatId": chatId,
      },
    );
    debugPrint("=> user chat id open for chat: $chatId");
  }

  Future<void> logAppOpen(String appOpen) async {
    await instance.logAppOpen(
      callOptions: AnalyticsCallOptions(
        global: true,
      ),
      parameters: {"AppOpen": appOpen},
    );
    debugPrint("=> app open : $appOpen");
  }
}
