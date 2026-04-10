import 'dart:async';

import 'package:chat_app_bloc/functionality/settings/help_and_support/models/support_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_setting_event.dart';
import 'chat_setting_state.dart';

class ChatSettingBloc extends Bloc<ChatSettingEvent, ChatSettingState> {
  static const String _wallpaperKey = 'chat_wallpaper_path';
  static const String _defaultWallpaper = 'assets/images/background.jpg';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<StreamSubscription> _subscriptions = [];

  ChatSettingBloc() : super(const ChatSettingState()) {
    on<LoadChatSettings>(_onLoadChatSettings);
    on<UpdateWallpaper>(_onUpdateWallpaper);
    on<ResetWallpaper>(_onResetWallpaper);
    on<CreateSupportTicket>(_onCreateSupportTicket);
    on<FetchUserTickets>(_onFetchUserTickets);
    on<SendSupportTicketMessage>(_onSendSupportTicketMessage);
    on<UpdateTicketStatus>(_onUpdateTicketStatus);
    on<MarkMessagesAsRead>(_onMarkMessagesAsRead);
    on<ListenToTicketUpdates>(_onListenToTicketUpdates);
    on<UpdateTicketsList>(_onUpdateTicketsList);
    on<ClearError>(_onClearError);
  }

  Future<void> _onLoadChatSettings(
      LoadChatSettings event, Emitter<ChatSettingState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_wallpaperKey) ?? _defaultWallpaper;
    emit(state.copyWith(
      wallpaperPath: path,
      isDefault: path == _defaultWallpaper,
    ));

    add(FetchUserTickets());

    Future.microtask(() {
      add(ListenToTicketUpdates());
    });
  }

  Future<void> _onUpdateWallpaper(
      UpdateWallpaper event, Emitter<ChatSettingState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_wallpaperKey, event.wallpaperPath);
    emit(state.copyWith(
      wallpaperPath: event.wallpaperPath,
      isDefault: false,
    ));
  }

  Future<void> _onResetWallpaper(
      ResetWallpaper event, Emitter<ChatSettingState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_wallpaperKey);
    emit(state.copyWith(
      wallpaperPath: _defaultWallpaper,
      isDefault: true,
    ));
  }

  Future<void> _onCreateSupportTicket(
      CreateSupportTicket event, Emitter<ChatSettingState> emit) async {
    final user = _auth.currentUser;
    if (user == null) return;

    emit(state.copyWith(isLoading: true));
    try {
      final ticketId = _firestore.collection('support_tickets').doc().id;
      final ticket = SupportTicket(
        id: ticketId,
        userId: user.uid,
        title: event.title,
        description: event.description,
        category: event.category,
        priority: event.priority,
        status: SupportStatus.open,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('support_tickets')
          .doc(ticketId)
          .set(ticket.toFirestore());

      // Add user's initial message
      await _firestore
          .collection('support_tickets')
          .doc(ticketId)
          .collection('messages')
          .add(SupportMessage(
            id: '',
            senderId: user.uid,
            senderName: user.displayName ?? 'You',
            message: event.description,
            isFromUser: true,
            isAutoReply: false,
            timestamp: DateTime.now(),
          ).toFirestore());

      // Send auto-reply
      await _sendAutoReply(ticketId, user.displayName ?? 'User');

      emit(state.copyWith(isLoading: false));
      add(FetchUserTickets());

      // Show success message
      emit(state.copyWith(
        successMessage:
            "Ticket created successfully! Support team will contact you soon.",
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _sendAutoReply(String ticketId, String userName) async {
    final autoReplyMessage = SupportMessage(
      id: '',
      senderId: 'support_bot',
      senderName: 'Support Team',
      message:
          "Hello $userName! Thank you for contacting support. Your ticket has been created successfully. Our team will review your issue and get back to you within 24 hours. Ticket ID: ${ticketId.substring(0, 8)}",
      isFromUser: false,
      isAutoReply: true,
      timestamp: DateTime.now(),
    );

    await _firestore
        .collection('support_tickets')
        .doc(ticketId)
        .collection('messages')
        .add(autoReplyMessage.toFirestore());

    // Update ticket status
    await _firestore.collection('support_tickets').doc(ticketId).update({
      'updatedAt': Timestamp.now(),
      'status': SupportStatus.inProgress.name,
    });
  }

  Future<void> _onFetchUserTickets(
      FetchUserTickets event, Emitter<ChatSettingState> emit) async {
    final user = _auth.currentUser;
    if (user == null) return;

    emit(state.copyWith(isLoading: true));
    try {
      final snapshot = await _firestore
          .collection('support_tickets')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .get();

      final tickets =
          snapshot.docs.map((doc) => SupportTicket.fromFirestore(doc)).toList();

      emit(state.copyWith(tickets: tickets, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onSendSupportTicketMessage(
      SendSupportTicketMessage event, Emitter<ChatSettingState> emit) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Send user message
      await _firestore
          .collection('support_tickets')
          .doc(event.ticketId)
          .collection('messages')
          .add(SupportMessage(
            id: '',
            senderId: user.uid,
            senderName: event.senderName,
            message: event.message,
            isFromUser: true,
            isAutoReply: false,
            timestamp: DateTime.now(),
          ).toFirestore());

      // Update ticket's updatedAt and status
      await _firestore
          .collection('support_tickets')
          .doc(event.ticketId)
          .update({
        'updatedAt': Timestamp.now(),
        'status': SupportStatus.waitingForUser.name,
      });

      // Auto-reply for common issues
      await _checkAndSendAutoReply(event.ticketId, event.message);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _checkAndSendAutoReply(String ticketId, String message) async {
    final lowerMessage = message.toLowerCase();
    String? autoReply;

    // Common issue patterns
    if (lowerMessage.contains('login') || lowerMessage.contains('password')) {
      autoReply =
          "I see you're having login issues. Please try resetting your password. If the issue persists, our team will assist you shortly.";
    } else if (lowerMessage.contains('message') &&
        (lowerMessage.contains('not send') || lowerMessage.contains('fail'))) {
      autoReply =
          "Having trouble sending messages? Please check your internet connection and try again. If the issue continues, our technical team will investigate.";
    } else if (lowerMessage.contains('notification')) {
      autoReply =
          "Notification issues can often be resolved by checking your device settings. Make sure notifications are enabled for this app in your system settings.";
    } else if (lowerMessage.contains('crash') ||
        lowerMessage.contains('close')) {
      autoReply =
          "I'm sorry to hear the app is crashing. Please try clearing the app cache or reinstalling. Our team will look into this issue.";
    } else if (lowerMessage.contains('payment') ||
        lowerMessage.contains('subscription')) {
      autoReply =
          "I understand you're having payment issues. Our billing team will contact you shortly to resolve this.";
    }

    if (autoReply != null) {
      await Future.delayed(
          const Duration(seconds: 2)); // Delay for realistic response

      await _firestore
          .collection('support_tickets')
          .doc(ticketId)
          .collection('messages')
          .add(SupportMessage(
            id: '',
            senderId: 'support_bot',
            senderName: 'Support Bot',
            message: autoReply,
            isFromUser: false,
            isAutoReply: true,
            timestamp: DateTime.now(),
          ).toFirestore());
    }
  }

  Future<void> _onUpdateTicketStatus(
      UpdateTicketStatus event, Emitter<ChatSettingState> emit) async {
    try {
      await _firestore
          .collection('support_tickets')
          .doc(event.ticketId)
          .update({
        'status': event.status.name,
        'updatedAt': Timestamp.now(),
      });

      add(FetchUserTickets());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onMarkMessagesAsRead(
      MarkMessagesAsRead event, Emitter<ChatSettingState> emit) async {
    try {
      final messages = await _firestore
          .collection('support_tickets')
          .doc(event.ticketId)
          .collection('messages')
          .where('isRead', isEqualTo: false)
          .where('isFromUser', isEqualTo: false)
          .get();

      final batch = _firestore.batch();
      for (var doc in messages.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();

      // Update ticket unread status
      await _firestore
          .collection('support_tickets')
          .doc(event.ticketId)
          .update({
        'hasUnreadMessages': false,
      });
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  Future<void> _onListenToTicketUpdates(
      ListenToTicketUpdates event, Emitter<ChatSettingState> emit) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Listen for ticket status changes
    final ticketSubscription = _firestore
        .collection('support_tickets')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .listen((snapshot) {
      // final tickets =
      snapshot.docs.map((doc) => SupportTicket.fromFirestore(doc)).toList();
      // add(UpdateTicketsList(tickets));
    });

    _subscriptions.add(ticketSubscription);
  }

  void _onClearError(ClearError event, Emitter<ChatSettingState> emit) {
    emit(state.copyWith(error: null));
  }

  void _onUpdateTicketsList(
      UpdateTicketsList event, Emitter<ChatSettingState> emit) {
    emit(state.copyWith(tickets: event.tickets));
  }

  @override
  Future<void> close() {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    return super.close();
  }
}
