// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:chat_app_bloc/functionality/settings/chat_setting/bloc/chat_setting_bloc.dart';
import 'package:chat_app_bloc/functionality/settings/chat_setting/bloc/chat_setting_event.dart';
import 'package:chat_app_bloc/functionality/settings/chat_setting/bloc/chat_setting_state.dart';
import 'package:chat_app_bloc/functionality/settings/help_and_support/models/support_model.dart';
import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class TechnicalSupportScreen extends StatefulWidget {
  const TechnicalSupportScreen({super.key});

  @override
  State<TechnicalSupportScreen> createState() => _TechnicalSupportScreenState();
}

class _TechnicalSupportScreenState extends State<TechnicalSupportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _messageController = TextEditingController();
  String? _lastSuccessMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load tickets when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatSettingBloc>().add(FetchUserTickets());
      context.read<ChatSettingBloc>().add(ListenToTicketUpdates());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatSettingBloc, ChatSettingState>(
      listener: (context, state) {
        // Show success message when ticket is created
        if (state.successMessage != null &&
            state.successMessage != _lastSuccessMessage) {
          _lastSuccessMessage = state.successMessage;
          _showSuccessMessage(state.successMessage!);
        }

        // Show error message if any
        if (state.error != null) {
          _showErrorMessage(state.error!);
          // Clear error after showing
          context.read<ChatSettingBloc>().add(ClearError());
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(context, state),
          body: state.isLoading && state.tickets.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLiveChat(context, state),
                    _buildMyTickets(context, state),
                    _buildHelpCenter(context),
                  ],
                ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, ChatSettingState state) {
    return AppBar(
      title: Text(
        "Technical Support",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isColorValidation(context),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.arrowLeft,
                size: 18,
                color: Color(0xFF4B5563),
              ),
            ),
          ),
        ),
      ),
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        labelColor: isColorValidation(context),
        indicatorWeight: 3,
        tabs: [
          Tab(
            icon: Icon(
              Icons.chat,
              color: isColorValidation(context),
            ),
            text: "Live Chat",
          ),
          Tab(
              icon: Icon(
                Icons.confirmation_num,
                color: isColorValidation(context),
              ),
              text: "My Tickets"),
          Tab(
              icon: Icon(
                Icons.help_center,
                color: isColorValidation(context),
              ),
              text: "Help Center"),
        ],
      ),
      // actions: [
      //   if (state.tickets.isNotEmpty)
      //     Badge(
      //       label: Text(
      //         state.tickets.where((t) => t.hasUnreadMessages).length.toString(),
      //         style: const TextStyle(fontSize: 10),
      //       ),
      //       child: IconButton(
      //         onPressed: () {
      //           _tabController.animateTo(1);
      //         },
      //         icon: const Icon(Icons.notifications),
      //       ),
      //     ),
      // ],
    );
  }

  Widget _buildLiveChat(BuildContext context, ChatSettingState state) {
    final openTickets = state.tickets
        .where((t) =>
            t.status != SupportStatus.resolved &&
            t.status != SupportStatus.closed)
        .toList();

    final mostRecentTicket = openTickets.isNotEmpty
        ? openTickets.first
        : (state.tickets.isNotEmpty ? state.tickets.first : null);

    if (mostRecentTicket == null) {
      return _buildEmptyChatState(context);
    }

    return Column(
      children: [
        _buildTicketInfoBar(context, mostRecentTicket),
        Expanded(
          child: _buildMessagesStream(mostRecentTicket.id),
        ),
        _buildMessageInput(context, mostRecentTicket.id),
      ],
    );
  }

  Widget _buildEmptyChatState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_outlined,
              size: 60,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No Active Support Chat",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Create a ticket to start a conversation\nwith our support team",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _tabController.animateTo(1),
            icon: const Icon(Icons.add),
            label: const Text("Create New Ticket"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketInfoBar(BuildContext context, SupportTicket ticket) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _getStatusColor(ticket.status).withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getStatusColor(ticket.status),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticket.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _getStatusDescription(ticket.status),
                  style: TextStyle(
                    fontSize: 11,
                    color: _getStatusColor(ticket.status),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Text(
              "ID: ${ticket.id.substring(0, 8)}",
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesStream(String ticketId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('support_tickets')
          .doc(ticketId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                const SizedBox(height: 8),
                Text("Error loading messages: ${snapshot.error}"),
              ],
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data!.docs
            .map((doc) => SupportMessage.fromFirestore(doc, doc.id))
            .toList();

        if (messages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.message_outlined, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 8),
                Text(
                  "No messages yet",
                  style: TextStyle(color: Colors.grey[500]),
                ),
                const SizedBox(height: 4),
                Text(
                  "Type your message above to start the conversation",
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ],
            ),
          );
        }

        // Mark messages as read when viewed
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<ChatSettingBloc>().add(MarkMessagesAsRead(ticketId));
        });

        return ListView.builder(
          controller: ScrollController(),
          padding: const EdgeInsets.all(16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return _buildChatBubble(messages[index]);
          },
        );
      },
    );
  }

  Widget _buildChatBubble(SupportMessage message) {
    final isUser = message.isFromUser;
    final isAutoReply = message.isAutoReply;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isUser)
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isAutoReply)
                      Icon(Icons.smart_toy, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      message.senderName,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser
                    ? Theme.of(context).primaryColor
                    : (isAutoReply ? Colors.grey[200] : Colors.grey[300]),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isUser
                      ? const Radius.circular(16)
                      : const Radius.circular(4),
                  bottomRight: isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    style: TextStyle(
                      // color: isUser ? Colors.white : Colors.black87,
                      color:
                          isUser ? isColorValidation(context) : Colors.black87,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  if (message.attachments.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: message.attachments.map((attachment) {
                        return Chip(
                          label: Text(
                            attachment.split('/').last,
                            style: const TextStyle(fontSize: 10),
                          ),
                          backgroundColor: Colors.white70,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                  ),
                  if (isUser && message.isRead)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Icon(Icons.done_all,
                          size: 12, color: Colors.grey[500]),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, String ticketId) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: () => _showAttachmentOptions(context, ticketId),
              icon: Icon(
                Icons.attach_file,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _messageController,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: "Type your message...",
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () => _sendMessage(context, ticketId),
                icon: Icon(
                  Icons.send,
                  color: isColorValidation(context),
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyTickets(BuildContext context, ChatSettingState state) {
    if (state.tickets.isEmpty) {
      return _buildEmptyTicketsState(context);
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ChatSettingBloc>().add(FetchUserTickets());
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                _createNewTicket(context); // This now opens bottom sheet
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: isColorValidation(context)),
                  Text(
                    "Create New Ticket",
                    style: TextStyle(
                      color: isColorValidation(context),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.builder(
                itemCount: state.tickets.length,
                itemBuilder: (context, index) {
                  return _buildTicketCard(context, state.tickets[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyTicketsState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.confirmation_number_outlined,
              size: 50,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No Support Tickets",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "You haven't created any support tickets yet.\nCreate one to get help from our team.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _createNewTicket(context),
            icon: const Icon(Icons.add),
            label: const Text("Create New Ticket"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, SupportTicket ticket) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _viewTicketDetails(context, ticket),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      ticket.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusChip(ticket.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                ticket.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildInfoChip(
                    Icons.category,
                    _getCategoryName(ticket.category),
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    Icons.priority_high,
                    _getPriorityName(ticket.priority),
                    color: _getPriorityColor(ticket.priority),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatDate(ticket.createdAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                      if (ticket.updatedAt != null)
                        Text(
                          "Updated: ${_formatTime(ticket.updatedAt!)}",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[400],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              if (ticket.hasUnreadMessages)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.message, size: 12, color: Colors.red[400]),
                        const SizedBox(width: 4),
                        Text(
                          "New response from support",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.red[400],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpCenter(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        _buildSearchBar(),
        const SizedBox(height: 16),
        _buildHelpSection(
          title: "Common Issues",
          icon: Icons.error_outline,
          color: Colors.red,
          items: [
            HelpItem(
              title: "App crashing on startup",
              solution:
                  "Clear app cache from Settings > Apps > Chat App > Clear Cache. If issue persists, reinstall the app.",
            ),
            HelpItem(
              title: "Messages not sending",
              solution:
                  "Check your internet connection. Ensure you have stable Wi-Fi or mobile data. Try restarting the app.",
            ),
            HelpItem(
              title: "Notification issues",
              solution:
                  "Go to device Settings > Notifications > Chat App > Enable all notifications. Also check in-app notification settings.",
            ),
            HelpItem(
              title: "Login problems",
              solution:
                  "Reset your password using 'Forgot Password' option. Clear app data and try again.",
            ),
          ],
        ),
        const SizedBox(height: 4),
        _buildHelpSection(
          title: "Quick Solutions",
          icon: Icons.lightbulb_outline,
          color: Colors.orange,
          items: [
            HelpItem(
              title: "Clear app cache",
              solution: "Settings > Apps > Chat App > Storage > Clear Cache",
            ),
            HelpItem(
              title: "Update to latest version",
              solution: "Visit Play Store/App Store and check for updates",
            ),
            HelpItem(
              title: "Check internet connection",
              solution:
                  "Toggle Wi-Fi/ mobile data on/off, restart router if needed",
            ),
            HelpItem(
              title: "Restart the app",
              solution: "Close app completely from recent apps and reopen",
            ),
          ],
        ),
        const SizedBox(height: 4),
        _buildHelpSection(
          title: "Troubleshooting Guides",
          icon: Icons.troubleshoot,
          color: Colors.blue,
          items: [
            HelpItem(
              title: "Media files not loading",
              solution:
                  "Check storage permissions. Ensure you have enough storage space. Clear media cache.",
            ),
            HelpItem(
              title: "Battery drain issues",
              solution:
                  "Disable background data for the app. Reduce notification frequency in settings.",
            ),
            HelpItem(
              title: "Connection timeout",
              solution:
                  "Switch between Wi-Fi and mobile data. Reset network settings if persistent.",
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildContactSupportCard(context),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search for help...",
          prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: (value) {
          // Implement search functionality
        },
      ),
    );
  }

  Widget _buildHelpSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<HelpItem> items,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: items.map((item) {
          return ListTile(
            leading: const Icon(Icons.help_outline, size: 20),
            title: Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showSolutionDialog(item.title, item.solution),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContactSupportCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.support_agent,
              size: 48,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            const Text(
              "Need More Help?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Our support team is available 24/7 to assist you",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _createNewTicket(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Contact Support"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(SupportStatus status) {
    final config = _getStatusConfig(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: config['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: config['color'],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            config['label'],
            style: TextStyle(
              fontSize: 11,
              color: config['color'],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color ?? Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color ?? Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(BuildContext context, String ticketId) {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    context.read<ChatSettingBloc>().add(SendSupportTicketMessage(
          ticketId: ticketId,
          message: message,
          senderName: "You",
        ));
    _messageController.clear();
  }

  void _createNewTicket(BuildContext context) {
    FocusScope.of(context).unfocus(); // Dismiss any open keyboard first

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Required for keyboard handling
      enableDrag: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (dialogContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context)
              .viewInsets
              .bottom, // Handle keyboard padding
        ),
        child: CreateTicketBottomSheet(
          onSubmit: (title, description, category, priority) {
            context.read<ChatSettingBloc>().add(CreateSupportTicket(
                  title: title,
                  description: description,
                  category: category,
                  priority: priority,
                ));
            // Switch to My Tickets tab after creating
            _tabController.animateTo(1);

            // Show success snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Ticket created successfully!"),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
      ),
    );
  }

  void _viewTicketDetails(BuildContext context, SupportTicket ticket) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketDetailsScreen(ticket: ticket),
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context, String ticketId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.photo_library, color: Colors.blue[700]),
              ),
              title: const Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(context);
                // Implement gallery picker
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.camera_alt, color: Colors.green[700]),
              ),
              title: const Text("Take a Photo"),
              onTap: () {
                Navigator.pop(context);
                // Implement camera
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.insert_drive_file, color: Colors.orange[700]),
              ),
              title: const Text("Choose File"),
              onTap: () {
                Navigator.pop(context);
                // Implement file picker
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showSolutionDialog(String title, String solution) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.lightbulb_outline, color: Colors.orange[700]),
            const SizedBox(width: 8),
            Expanded(child: Text(title)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Solution:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              solution,
              style: const TextStyle(height: 1.4),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.thumb_up_outlined,
                    size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  "Did this solve your issue?",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No, Contact Support"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Yes, Thanks"),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showErrorMessage(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(error)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Map<String, dynamic> _getStatusConfig(SupportStatus status) {
    switch (status) {
      case SupportStatus.open:
        return {
          'label': 'Open',
          'color': Colors.orange,
          'description': 'Awaiting review'
        };
      case SupportStatus.inProgress:
        return {
          'label': 'In Progress',
          'color': Colors.blue,
          'description': 'Being handled'
        };
      case SupportStatus.waitingForUser:
        return {
          'label': 'Waiting',
          'color': Colors.purple,
          'description': 'Waiting for your response'
        };
      case SupportStatus.resolved:
        return {
          'label': 'Resolved',
          'color': Colors.green,
          'description': 'Issue resolved'
        };
      case SupportStatus.closed:
        return {
          'label': 'Closed',
          'color': Colors.grey,
          'description': 'Ticket closed'
        };
    }
  }

  Color _getStatusColor(SupportStatus status) {
    switch (status) {
      case SupportStatus.open:
        return Colors.orange;
      case SupportStatus.inProgress:
        return Colors.blue;
      case SupportStatus.waitingForUser:
        return Colors.purple;
      case SupportStatus.resolved:
        return Colors.green;
      case SupportStatus.closed:
        return Colors.grey;
    }
  }

  String _getStatusDescription(SupportStatus status) {
    switch (status) {
      case SupportStatus.open:
        return "Your ticket is awaiting review by our team";
      case SupportStatus.inProgress:
        return "Our team is actively working on your issue";
      case SupportStatus.waitingForUser:
        return "We're waiting for your response";
      case SupportStatus.resolved:
        return "Your issue has been resolved";
      case SupportStatus.closed:
        return "This ticket has been closed";
    }
  }

  String _getCategoryName(SupportCategory category) {
    switch (category) {
      case SupportCategory.technical:
        return "Technical";
      case SupportCategory.account:
        return "Account";
      case SupportCategory.payment:
        return "Payment";
      case SupportCategory.feature:
        return "Feature";
      case SupportCategory.bug:
        return "Bug";
      case SupportCategory.other:
        return "Other";
    }
  }

  String _getPriorityName(SupportPriority priority) {
    switch (priority) {
      case SupportPriority.low:
        return "Low";
      case SupportPriority.medium:
        return "Medium";
      case SupportPriority.high:
        return "High";
      case SupportPriority.critical:
        return "Critical";
    }
  }

  Color _getPriorityColor(SupportPriority priority) {
    switch (priority) {
      case SupportPriority.low:
        return Colors.green;
      case SupportPriority.medium:
        return Colors.orange;
      case SupportPriority.high:
        return Colors.red;
      case SupportPriority.critical:
        return Colors.purple;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) return "Just now";
    if (difference.inMinutes < 60) return "${difference.inMinutes}m ago";
    if (difference.inHours < 24) return "${difference.inHours}h ago";
    if (difference.inDays < 7) return "${difference.inDays}d ago";
    return DateFormat('dd MMM').format(time);
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}

// Helper Classes
class HelpItem {
  final String title;
  final String solution;

  HelpItem({required this.title, required this.solution});
}

// Create Ticket Dialog
class CreateTicketDialog extends StatefulWidget {
  final Function(String, String, SupportCategory, SupportPriority) onSubmit;

  const CreateTicketDialog({super.key, required this.onSubmit});

  @override
  State<CreateTicketDialog> createState() => _CreateTicketDialogState();
}

class _CreateTicketDialogState extends State<CreateTicketDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  SupportCategory _selectedCategory = SupportCategory.technical;
  SupportPriority _selectedPriority = SupportPriority.medium;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Create Support Ticket",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Our team will get back to you within 24 hours",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: "Title",
                      hintText: "Brief description of the issue",
                      prefixIcon: const Icon(Icons.title),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? "Please enter a title" : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<SupportCategory>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: "Category",
                      prefixIcon: const Icon(Icons.category),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: SupportCategory.values.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(_getCategoryName(category)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<SupportPriority>(
                    value: _selectedPriority,
                    decoration: InputDecoration(
                      labelText: "Priority",
                      prefixIcon: const Icon(Icons.priority_high),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: SupportPriority.values.map((priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _getPriorityColor(priority),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(_getPriorityName(priority)),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPriority = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: "Description",
                      hintText:
                          "Please provide detailed information about the issue...",
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) => value?.isEmpty ?? true
                        ? "Please enter a description"
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Submit"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        _titleController.text,
        _descriptionController.text,
        _selectedCategory,
        _selectedPriority,
      );
      Navigator.pop(context);
    }
  }

  String _getCategoryName(SupportCategory category) {
    switch (category) {
      case SupportCategory.technical:
        return "Technical Issue";
      case SupportCategory.account:
        return "Account Problem";
      case SupportCategory.payment:
        return "Payment Issue";
      case SupportCategory.feature:
        return "Feature Request";
      case SupportCategory.bug:
        return "Bug Report";
      case SupportCategory.other:
        return "Other";
    }
  }

  String _getPriorityName(SupportPriority priority) {
    switch (priority) {
      case SupportPriority.low:
        return "Low";
      case SupportPriority.medium:
        return "Medium";
      case SupportPriority.high:
        return "High";
      case SupportPriority.critical:
        return "Critical";
    }
  }

  Color _getPriorityColor(SupportPriority priority) {
    switch (priority) {
      case SupportPriority.low:
        return Colors.green;
      case SupportPriority.medium:
        return Colors.orange;
      case SupportPriority.high:
        return Colors.red;
      case SupportPriority.critical:
        return Colors.purple;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

// Ticket Details Screen
class TicketDetailsScreen extends StatefulWidget {
  final SupportTicket ticket;

  const TicketDetailsScreen({super.key, required this.ticket});

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  final TextEditingController _replyController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Mark messages as read when viewing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatSettingBloc>().add(MarkMessagesAsRead(widget.ticket.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.ticket.title,
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          PopupMenuButton<SupportStatus>(
            onSelected: (status) {
              context.read<ChatSettingBloc>().add(
                    UpdateTicketStatus(
                      ticketId: widget.ticket.id,
                      status: status,
                    ),
                  );
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: SupportStatus.open,
                child: Text("Mark as Open"),
              ),
              const PopupMenuItem(
                value: SupportStatus.inProgress,
                child: Text("Mark as In Progress"),
              ),
              const PopupMenuItem(
                value: SupportStatus.resolved,
                child: Text("Mark as Resolved"),
              ),
              const PopupMenuItem(
                value: SupportStatus.closed,
                child: Text("Close Ticket"),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTicketInfo(),
          Expanded(
            child: _buildMessagesList(),
          ),
          if (widget.ticket.status != SupportStatus.resolved &&
              widget.ticket.status != SupportStatus.closed)
            _buildReplyInput(),
        ],
      ),
    );
  }

  Widget _buildTicketInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getStatusColor(widget.ticket.status).withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _getStatusColor(widget.ticket.status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getStatusText(widget.ticket.status),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                "ID: ${widget.ticket.id.substring(0, 8)}",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.ticket.description,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: [
              _buildInfoItem(
                Icons.category,
                _getCategoryName(widget.ticket.category),
              ),
              _buildInfoItem(
                Icons.priority_high,
                _getPriorityName(widget.ticket.priority),
                color: _getPriorityColor(widget.ticket.priority),
              ),
              _buildInfoItem(
                Icons.access_time,
                _formatDate(widget.ticket.createdAt),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, {Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color ?? Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color ?? Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildMessagesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('support_tickets')
          .doc(widget.ticket.id)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data!.docs
            .map((doc) => SupportMessage.fromFirestore(
                  doc,
                ))
            .toList();

        if (messages.isEmpty) {
          return const Center(
            child: Text("No messages yet"),
          );
        }

        // Auto-scroll to bottom
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return _buildMessageBubble(messages[index]);
          },
        );
      },
    );
  }

  Widget _buildMessageBubble(SupportMessage message) {
    final isUser = message.isFromUser;
    final isAutoReply = message.isAutoReply;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isUser)
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 4),
                child: Text(
                  message.senderName,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser
                    ? Theme.of(context).primaryColor
                    : (isAutoReply ? Colors.grey[200] : Colors.grey[300]),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isUser
                      ? const Radius.circular(16)
                      : const Radius.circular(4),
                  bottomRight: isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(16),
                ),
              ),
              child: Text(
                message.message,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
              child: Text(
                _formatTime(message.timestamp),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _replyController,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "Type your reply...",
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _sendReply,
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendReply() {
    final message = _replyController.text.trim();
    if (message.isEmpty) return;

    context.read<ChatSettingBloc>().add(SendSupportTicketMessage(
          ticketId: widget.ticket.id,
          message: message,
          senderName: "You",
        ));
    _replyController.clear();
  }

  String _getStatusText(SupportStatus status) {
    switch (status) {
      case SupportStatus.open:
        return "OPEN";
      case SupportStatus.inProgress:
        return "IN PROGRESS";
      case SupportStatus.waitingForUser:
        return "WAITING FOR YOU";
      case SupportStatus.resolved:
        return "RESOLVED";
      case SupportStatus.closed:
        return "CLOSED";
    }
  }

  Color _getStatusColor(SupportStatus status) {
    switch (status) {
      case SupportStatus.open:
        return Colors.orange;
      case SupportStatus.inProgress:
        return Colors.blue;
      case SupportStatus.waitingForUser:
        return Colors.purple;
      case SupportStatus.resolved:
        return Colors.green;
      case SupportStatus.closed:
        return Colors.grey;
    }
  }

  String _getCategoryName(SupportCategory category) {
    switch (category) {
      case SupportCategory.technical:
        return "Technical";
      case SupportCategory.account:
        return "Account";
      case SupportCategory.payment:
        return "Payment";
      case SupportCategory.feature:
        return "Feature";
      case SupportCategory.bug:
        return "Bug";
      case SupportCategory.other:
        return "Other";
    }
  }

  String _getPriorityName(SupportPriority priority) {
    switch (priority) {
      case SupportPriority.low:
        return "Low";
      case SupportPriority.medium:
        return "Medium";
      case SupportPriority.high:
        return "High";
      case SupportPriority.critical:
        return "Critical";
    }
  }

  Color _getPriorityColor(SupportPriority priority) {
    switch (priority) {
      case SupportPriority.low:
        return Colors.green;
      case SupportPriority.medium:
        return Colors.orange;
      case SupportPriority.high:
        return Colors.red;
      case SupportPriority.critical:
        return Colors.purple;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) return "Just now";
    if (difference.inMinutes < 60) return "${difference.inMinutes}m ago";
    if (difference.inHours < 24) return "${difference.inHours}h ago";
    return DateFormat('dd MMM, hh:mm a').format(time);
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  @override
  void dispose() {
    _replyController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

// Create Ticket Bottom Sheet with Keyboard Handling
class CreateTicketBottomSheet extends StatefulWidget {
  final Function(String, String, SupportCategory, SupportPriority) onSubmit;

  const CreateTicketBottomSheet({super.key, required this.onSubmit});

  @override
  State<CreateTicketBottomSheet> createState() =>
      _CreateTicketBottomSheetState();
}

class _CreateTicketBottomSheetState extends State<CreateTicketBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  SupportCategory _selectedCategory = SupportCategory.technical;
  SupportPriority _selectedPriority = SupportPriority.medium;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: GestureDetector(
        onTap: () =>
            FocusScope.of(context).unfocus(), // Dismiss keyboard on tap outside
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height *
                0.7, // Max height 90% of screen
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header with close button
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Create Support Ticket",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context)
                        .viewInsets
                        .bottom, // Important for keyboard
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Our team will get back to you within 24 hours",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 24),
                          // Title Field
                          TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: "Title *",
                              hintText: "Brief description of the issue",
                              prefixIcon: const Icon(Icons.title),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                ),
                              ),
                            ),
                            validator: (value) => value?.isEmpty ?? true
                                ? "Please enter a title"
                                : null,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 16),
                          // Category Dropdown
                          DropdownButtonFormField<SupportCategory>(
                            value: _selectedCategory,
                            decoration: InputDecoration(
                              labelText: "Category *",
                              prefixIcon: const Icon(Icons.category),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                ),
                              ),
                            ),
                            items: SupportCategory.values.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(_getCategoryName(category)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          // Priority Dropdown
                          DropdownButtonFormField<SupportPriority>(
                            value: _selectedPriority,
                            decoration: InputDecoration(
                              labelText: "Priority *",
                              prefixIcon: const Icon(Icons.priority_high),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                ),
                              ),
                            ),
                            items: SupportPriority.values.map((priority) {
                              return DropdownMenuItem(
                                value: priority,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: _getPriorityColor(priority),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(_getPriorityName(priority)),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedPriority = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          // Description Field
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 6,
                            minLines: 3,
                            decoration: InputDecoration(
                              labelText: "Description *",
                              hintText:
                                  "Please provide detailed information about the issue...",
                              alignLabelWithHint: true,
                              prefixIcon: const Icon(Icons.description),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                ),
                              ),
                            ),
                            validator: (value) => value?.isEmpty ?? true
                                ? "Please enter a description"
                                : null,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(),
                          ),
                          const SizedBox(height: 24),
                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    side: BorderSide(
                                      color: Colors.grey[400]!,
                                    ),
                                  ),
                                  child: const Text("Cancel"),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _submit,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                  ),
                                  child: const Text(
                                    "Submit",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Dismiss keyboard before submitting
      FocusScope.of(context).unfocus();

      // Add a small delay to ensure keyboard is dismissed
      Future.delayed(const Duration(milliseconds: 100), () {
        widget.onSubmit(
          _titleController.text,
          _descriptionController.text,
          _selectedCategory,
          _selectedPriority,
        );
        Navigator.pop(context);
      });
    }
  }

  String _getCategoryName(SupportCategory category) {
    switch (category) {
      case SupportCategory.technical:
        return "Technical Issue";
      case SupportCategory.account:
        return "Account Problem";
      case SupportCategory.payment:
        return "Payment Issue";
      case SupportCategory.feature:
        return "Feature Request";
      case SupportCategory.bug:
        return "Bug Report";
      case SupportCategory.other:
        return "Other";
    }
  }

  String _getPriorityName(SupportPriority priority) {
    switch (priority) {
      case SupportPriority.low:
        return "Low";
      case SupportPriority.medium:
        return "Medium";
      case SupportPriority.high:
        return "High";
      case SupportPriority.critical:
        return "Critical";
    }
  }

  Color _getPriorityColor(SupportPriority priority) {
    switch (priority) {
      case SupportPriority.low:
        return Colors.green;
      case SupportPriority.medium:
        return Colors.orange;
      case SupportPriority.high:
        return Colors.red;
      case SupportPriority.critical:
        return Colors.purple;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
