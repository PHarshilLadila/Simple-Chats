import 'package:chat_app_bloc/App%20Functionality/Notification/bloc/show_notification_bloc.dart';
import 'package:chat_app_bloc/App%20Functionality/Notification/bloc/show_notification_event.dart';
import 'package:chat_app_bloc/App%20Functionality/Notification/bloc/show_notification_state.dart';
import 'package:chat_app_bloc/Constent/app_appbar.dart';
import 'package:chat_app_bloc/Constent/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var isRefresh = false;
  List<Map<String, dynamic>> notifications = [];

  Future<void> showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
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

  @override
  Widget build(BuildContext context) {
    final List<Color> selectedColors = [
      const Color.fromARGB(255, 245, 192, 210),
      const Color.fromARGB(255, 238, 232, 181),
      const Color.fromARGB(255, 200, 224, 243),
      const Color.fromARGB(255, 203, 238, 204),
    ];
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: CustomeAppBar(
        automaticallyImplyLeadings: false,
        titleWidget: Text(
          "Notifications",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => NotificationBloc()..add(LoadNotifications()),
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationLoaded) {
              notifications = state.notifications;
              return notifications.isEmpty
                  ? const Center(child: Text("No notifications"))
                  : RefreshIndicator(
                      color: AppColor.mainColor,
                      onRefresh: () async {
                        context
                            .read<NotificationBloc>()
                            .add(LoadNotifications());
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          var notification = notifications[index];

                          Map<String, dynamic> notificationData = notification;

                          Timestamp timestamp =
                              notificationData["timestamp"] as Timestamp;
                          String formattedTime =
                              DateFormat('hh:mm a').format(timestamp.toDate());

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              tileColor:
                                  selectedColors[index % selectedColors.length],
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${notificationData['senderName'] ?? 'Unknown'}",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    formattedTime,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              leading: notificationData['isImage'] == true
                                  ? const Icon(
                                      Icons.image,
                                      color: Colors.black,
                                    )
                                  : const Icon(
                                      Icons.message,
                                      color: Colors.black,
                                    ),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      notificationData['isImage'] == true
                                          ? "Image"
                                          : "${notificationData['message'] ?? 'No message'}",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
            } else if (state is NotificationError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text("No notifications"));
          },
        ),
      ),
    );
  }
}
