import 'package:chat_app_bloc/app_widget/app_appbar.dart';
import 'package:chat_app_bloc/app_widget/app_snackbar.dart';
import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  List<FAQ> faqList = [];
  List<FAQ> filteredFaqList = [];
  TextEditingController searchController = TextEditingController();
  String selectedCategory = "All";
  List<String> categories = [
    "All",
    "General",
    "Messages",
    "Privacy",
    "Technical"
  ];

  @override
  void initState() {
    super.initState();
    loadFAQData();
    filteredFaqList = faqList;
  }

  void loadFAQData() {
    faqList = [
      FAQ(
        question: "How do I send a message?",
        answer:
            "To send a message, type your text in the message input field at the bottom of the chat screen and tap the send button (paper airplane icon). You can also press Enter if enabled in settings.",
        category: "Messages",
      ),
      FAQ(
        question: "How to send images or files?",
        answer:
            "Tap the attachment icon (paperclip) in the message input field. You can choose images from gallery, take a photo, or select files from your device. The attachment will be uploaded and sent with your message.",
        category: "General",
      ),
      FAQ(
        question: "Is my data secure?",
        answer:
            "Yes, all messages are encrypted end-to-end. Your conversations are private and secure. We use industry-standard encryption protocols to protect your data.",
        category: "Privacy",
      ),
      FAQ(
        question: "How to delete a message?",
        answer:
            "Tap and hold on any message you've sent. From the popup menu, select 'Delete'. You can delete messages for yourself or for everyone (if within time limit).",
        category: "Messages",
      ),
      FAQ(
        question: "Why am I not receiving notifications?",
        answer:
            "Please check your device settings: 1) Ensure app notifications are enabled in system settings 2) Check if Do Not Disturb mode is off 3) Verify that in-app notification settings are enabled 4) Ensure you have stable internet connection.",
        category: "Technical",
      ),
      FAQ(
        question: "How to block a user?",
        answer:
            "Open the user's profile by tapping their name/avatar, then tap the three-dot menu and select 'Block User'. Blocked users cannot send you messages or see your online status.",
        category: "Privacy",
      ),
      FAQ(
        question: "Can I recall a sent message?",
        answer:
            "Yes, you can recall messages within 5 minutes of sending. Tap and hold the message, then select 'Recall'. The message will be removed from both parties' chat.",
        category: "Messages",
      ),
      FAQ(
        question: "How to change chat background?",
        answer:
            "Go to Settings > Chat Settings > Chat Background. You can choose from default themes, solid colors, or upload your own image from gallery.",
        category: "General",
      ),
      FAQ(
        question: "What is the message character limit?",
        answer:
            "Each message can contain up to 5000 characters. For longer content, we recommend splitting into multiple messages or using the file sharing feature.",
        category: "Technical",
      ),
      FAQ(
        question: "How to mute notifications?",
        answer:
            "Open the chat, tap on the contact/group name, select 'Mute Notifications'. You can mute for 1 hour, 8 hours, 1 week, or permanently.",
        category: "Privacy",
      ),
      FAQ(
        question: "How to backup my chats?",
        answer:
            "Go to Settings > Chats > Chat Backup. You can backup to Google Drive or iCloud. Auto-backup can be scheduled daily, weekly, or monthly.",
        category: "Technical",
      ),
      FAQ(
        question: "What happens if I clear chat history?",
        answer:
            "Clearing chat history removes all messages from your device only. Other participants will still have their copies. This action cannot be undone.",
        category: "General",
      ),
      FAQ(
        question: "How to report inappropriate content?",
        answer:
            "Tap and hold the message, select 'Report'. Our moderation team will review the content and take appropriate action if it violates our terms of service.",
        category: "Privacy",
      ),
      FAQ(
        question: "Can I use the app offline?",
        answer:
            "You can view previously loaded messages offline. To send/receive new messages, you need an active internet connection (Wi-Fi or mobile data).",
        category: "Technical",
      ),
    ];
  }

  void filterFAQ(String query) {
    setState(() {
      filteredFaqList = faqList.where((faq) {
        final matchesCategory =
            selectedCategory == "All" || faq.category == selectedCategory;
        final matchesSearch =
            faq.question.toLowerCase().contains(query.toLowerCase()) ||
                faq.answer.toLowerCase().contains(query.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  void filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
      filterFAQ(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomeAppBar(
        automaticallyImplyLeadings: false,
        titleWidget: Text(
          "Frequently Asked Questions",
          style: GoogleFonts.poppins(
            color: isColorValidation(context),
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
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
      // AppBar(
      //   title: const Text("Frequently Asked Questions"),
      //   backgroundColor: Theme.of(context).primaryColor,
      //   elevation: 0,
      //   bottom: PreferredSize(
      //     preferredSize: const Size.fromHeight(60),
      //     child: Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: TextField(
      //         controller: searchController,
      //         decoration: InputDecoration(
      //           hintText: "Search questions...",
      //           prefixIcon: const Icon(Icons.search),
      //           filled: true,
      //           fillColor: Colors.white,
      //           border: OutlineInputBorder(
      //             borderRadius: BorderRadius.circular(10),
      //             borderSide: BorderSide.none,
      //           ),
      //           contentPadding:
      //               const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      //         ),
      //         onChanged: filterFAQ,
      //       ),
      //     ),
      //   ),
      // ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) => filterByCategory(category),
                    backgroundColor: Colors.grey[200],
                    selectedColor:
                        Theme.of(context).primaryColor.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          // FAQ List
          Expanded(
            child: filteredFaqList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.help_outline,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No questions found",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Try different search terms",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredFaqList.length,
                    itemBuilder: (context, index) {
                      return FAQItem(faq: filteredFaqList[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class FAQ {
  final String question;
  final String answer;
  final String? category;
  final bool isExpanded;

  FAQ({
    required this.question,
    required this.answer,
    this.category,
    this.isExpanded = false,
  });
}

class FAQItem extends StatefulWidget {
  final FAQ faq;

  const FAQItem({Key? key, required this.faq}) : super(key: key);

  @override
  State<FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: _isExpanded ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.faq.question,
              style: TextStyle(
                fontWeight: _isExpanded ? FontWeight.bold : FontWeight.w500,
                fontSize: 16,
              ),
            ),
            trailing: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.faq.answer,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: widget.faq.answer));
                          AppSnackbar.success(
                              context, "Answer copied to clipboard");
                        },
                        icon: const Icon(Icons.copy, size: 16),
                        label: const Text("Copy"),
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () {
                          Share.share(
                              "${widget.faq.question}\n\n${widget.faq.answer}");
                        },
                        icon: const Icon(Icons.share, size: 16),
                        label: const Text("Share"),
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
