// import 'package:chat_app_bloc/constent/app_appbar.dart';
// import 'package:chat_app_bloc/constent/app_color.dart';
// import 'package:chat_app_bloc/functionality/notification/bloc/show_notification_bloc.dart';
// import 'package:chat_app_bloc/functionality/notification/bloc/show_notification_event.dart';
// import 'package:chat_app_bloc/functionality/notification/bloc/show_notification_state.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';

// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});

//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   var isRefresh = false;
//   List<Map<String, dynamic>> notifications = [];

//   Future<void> showAlertDialog() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('AlertDialog Title'),
//           content: const SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text('This is a demo alert dialog.'),
//                 Text('Would you like to approve of this message?'),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Approve'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Color> selectedColors = [
//       const Color.fromARGB(255, 245, 225, 232),
//       const Color.fromARGB(255, 244, 241, 224),
//       const Color.fromARGB(255, 226, 237, 246),
//       const Color.fromARGB(255, 225, 245, 225),
//     ];
//     return Scaffold(
//       backgroundColor: AppColor.backgroundColor,
//       appBar: CustomeAppBar(
//         automaticallyImplyLeadings: false,
//         titleWidget: Text(
//           "Notifications",
//           style: GoogleFonts.poppins(
//             color: isColorValidation(context),
//             fontWeight: FontWeight.w600,
//             fontSize: 20,
//           ),
//         ),
//       ),
//       body: BlocProvider(
//         create: (context) => NotificationBloc()..add(LoadNotifications()),
//         child: BlocBuilder<NotificationBloc, NotificationState>(
//           builder: (context, state) {
//             if (state is NotificationLoading) {
//               return Center(
//                   child: CircularProgressIndicator(
//                       color: Theme.of(context).primaryColor));
//             } else if (state is NotificationLoaded) {
//               notifications = state.notifications;
//               return notifications.isEmpty
//                   ? const Center(child: Text("No notifications"))
//                   : RefreshIndicator(
//                       color: Theme.of(context).primaryColor,
//                       onRefresh: () async {
//                         context
//                             .read<NotificationBloc>()
//                             .add(LoadNotifications());
//                       },
//                       child: ListView.builder(
//                         physics: const AlwaysScrollableScrollPhysics(),
//                         itemCount: notifications.length,
//                         itemBuilder: (context, index) {
//                           var notification = notifications[index];

//                           Map<String, dynamic> notificationData = notification;

//                           Timestamp timestamp =
//                               notificationData["timestamp"] as Timestamp;
//                           String formattedTime =
//                               DateFormat('hh:mm a').format(timestamp.toDate());

//                           return Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 8.0, vertical: 4),
//                             child: ListTile(
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10)),
//                               tileColor:
//                                   selectedColors[index % selectedColors.length],
//                               title: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     "${notificationData['senderName'] ?? 'Unknown'}",
//                                     style: GoogleFonts.poppins(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                     formattedTime,
//                                     style: GoogleFonts.poppins(
//                                       color: Colors.black,
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               leading: notificationData['isImage'] == true
//                                   ? const Icon(
//                                       Icons.image,
//                                       color: Colors.black,
//                                     )
//                                   : const Icon(
//                                       Icons.message,
//                                       color: Colors.black,
//                                     ),
//                               subtitle: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Expanded(
//                                     child: Text(
//                                       notificationData['isImage'] == true
//                                           ? "Image"
//                                           : "${notificationData['message'] ?? 'No message'}",
//                                       style: GoogleFonts.poppins(
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       softWrap: true,
//                                       textAlign: TextAlign.start,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//             } else if (state is NotificationError) {
//               return Center(child: Text(state.message));
//             }
//             return const Center(child: Text("No notifications"));
//           },
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

import 'package:chat_app_bloc/app_widget/app_appbar.dart';
import 'package:chat_app_bloc/functionality/notification/bloc/show_notification_bloc.dart';
import 'package:chat_app_bloc/functionality/notification/bloc/show_notification_event.dart';
import 'package:chat_app_bloc/functionality/notification/bloc/show_notification_state.dart';
import 'package:chat_app_bloc/functionality/chat_section/view/chat_screen.dart';
import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var isRefresh = false;
  List<Map<String, dynamic>> notifications = [];
  String? currentUserId;
  String? currentUserName;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserDetails();
  }

  Future<void> _fetchCurrentUserDetails() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserId = user.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          currentUserName = userDoc['name'];
        });
      }
    }
  }

  final List<Color> notificationColors = [
    const Color(0xFFF8F0F2), // Soft pink
    const Color(0xFFF5F3E8), // Soft cream
    const Color(0xFFEDF2F7), // Soft blue
    const Color(0xFFE8F3E8), // Soft green
  ];

  Future<void> showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('AlertDialog Title'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildShimmerNotification() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      period: const Duration(milliseconds: 1500),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            height: 12,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 12,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: CustomeAppBar(
        automaticallyImplyLeadings: false,
        titleWidget: Text(
          "Notifications",
          style: GoogleFonts.poppins(
            color: isColorValidation(context),
            fontWeight: FontWeight.w600,
            fontSize: 22,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) =>
            ShowNotificationBloc()..add(ShowLoadNotifications()),
        child: BlocBuilder<ShowNotificationBloc, ShowNotificationState>(
          builder: (context, state) {
            if (state is ShowNotificationLoading) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: _buildShimmerNotification(),
              );
            } else if (state is ShowNotificationLoaded) {
              notifications = state.notifications;
              return notifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade100,
                            ),
                            child: Icon(
                              Icons.notifications_none_rounded,
                              size: 60,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No Notifications",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "You're all caught up!",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      color: Theme.of(context).primaryColor,
                      backgroundColor: Colors.white,
                      strokeWidth: 2,
                      onRefresh: () async {
                        context
                            .read<ShowNotificationBloc>()
                            .add(ShowLoadNotifications());
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          var notification = notifications[index];
                          Map<String, dynamic> notificationData = notification;

                          Timestamp timestamp =
                              notificationData["timestamp"] as Timestamp;
                          String formattedTime =
                              DateFormat('hh:mm a').format(timestamp.toDate());
                          String formattedDate =
                              DateFormat('MMM dd').format(timestamp.toDate());

                          bool isToday = DateTime.now()
                                  .difference(timestamp.toDate().toLocal()) <
                              const Duration(days: 1);

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 6),
                            child: Material(
                              elevation: 0,
                              borderRadius: BorderRadius.circular(20),
                              color: notificationColors[
                                  index % notificationColors.length],
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  // if (notificationData['chatId'] != null &&
                                  //     notificationData['senderUid'] != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                        chatId: notificationData['chatId'],
                                        currentUserName: currentUserName,
                                        senderName: currentUserName,
                                        receiverName:
                                            notificationData['senderName'],
                                        senderUid: currentUserId,
                                        receiverUid:
                                            notificationData['senderUid'],
                                        userEmail:
                                            notificationData['senderEmail'] ??
                                                "",
                                        mobileNumber:
                                            notificationData['senderMobile'] ??
                                                "",
                                        receiverFCM:
                                            notificationData['senderFCM'] ?? "",
                                        profileImage:
                                            notificationData['senderProfile'] ??
                                                "",
                                      ),
                                    ),
                                  );
                                  // } else {
                                  //   ScaffoldMessenger.of(context).showSnackBar(
                                  //     const SnackBar(
                                  //       content: Text(
                                  //           "Cannot open old notification details."),
                                  //     ),
                                  //   );
                                  // }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Icon Container
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.7),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.05),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Icon(
                                            notificationData['isImage'] == true
                                                ? Icons.image_rounded
                                                : Icons.message_rounded,
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),

                                      // Content
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    notificationData[
                                                            'senderName'] ??
                                                        'Unknown User',
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black87,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: -0.2,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Text(
                                                    isToday
                                                        ? formattedTime
                                                        : formattedDate,
                                                    style: GoogleFonts.poppins(
                                                      color:
                                                          Colors.grey.shade700,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              notificationData['isImage'] ==
                                                      true
                                                  ? "📷 Sent an image"
                                                  : notificationData[
                                                          'message'] ??
                                                      'No message',
                                              style: GoogleFonts.poppins(
                                                color: Colors.grey.shade800,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                height: 1.3,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            if (notificationData['isImage'] ==
                                                true)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Icons.image_outlined,
                                                        size: 14,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        'View Image',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 12,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
            } else if (state is ShowNotificationError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.shade50,
                      ),
                      child: Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: Colors.red.shade400,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Something went wrong",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<ShowNotificationBloc>()
                            .add(ShowLoadNotifications());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
