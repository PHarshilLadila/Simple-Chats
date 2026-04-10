// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:chat_app_bloc/functionality/home/bloc/searching_user_bloc.dart';
import 'package:chat_app_bloc/functionality/home/bloc/searching_user_event.dart';
import 'package:chat_app_bloc/functionality/chat_section/view/chat_screen.dart';
import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app_bloc/functionality/home/model/searched_user_model.dart';
import 'package:chat_app_bloc/functionality/home/widgets/user_profile_picture.dart';
import 'package:chat_app_bloc/service/analytics_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchedUserList extends StatefulWidget {
  const SearchedUserList({
    super.key,
    required this.searchedUser,
  });
  final SearchedUserModel searchedUser;

  @override
  State<SearchedUserList> createState() => _SearchedUserListState();
}

class _SearchedUserListState extends State<SearchedUserList> {
  @override
  void initState() {
    super.initState();
    getDetails();
  }

  final AnalyticsService service = AnalyticsService();

  String? mainUserid;
  String? mainCurretnUserName;
  Future<void> getDetails() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final User? firebaseUser = firebaseAuth.currentUser;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .get();
    final mainUserids = firebaseUser.uid;
    final mainCurretnUser = userDoc['name'];

    mainUserid = mainUserids;
    setState(() {
      mainCurretnUserName = mainCurretnUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    String chatRoomId(String user1, String user2) {
      if (user1.isEmpty || user2.isEmpty) {
        throw ArgumentError("User Name Not Must Be Empty");
      }
      if (user1[0].toLowerCase().codeUnits[0] >
          user2[0].toLowerCase().codeUnits[0]) {
        debugPrint(
            "=> This is user 1 and user 2 (Searched user list): $user1 $user2");
        return "$user1$user2";
      } else {
        debugPrint(
            "=> This is user 2 and user 1 (Searched user list): $user2 $user1");
        return "$user2$user1";
      }
    }

    final userchatId = chatRoomId(
        mainCurretnUserName ?? "non", widget.searchedUser.displayName);
    debugPrint("=> This is searched user list chatId : $userchatId");

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatId: userchatId,
              currentUserName: mainCurretnUserName,
              senderName: mainCurretnUserName,
              receiverName: widget.searchedUser.displayName,
              senderUid: mainUserid,
              receiverUid: widget.searchedUser.id,
              userEmail: widget.searchedUser.email,
              mobileNumber: widget.searchedUser.mobileNumber,
              receiverFCM: widget.searchedUser.receiverFCm,
              profileImage: widget.searchedUser.profileImage,
            ),
          ),
        );
        service.logchatIdOpen(userchatId);
        if (mounted) {
          context.read<SearchingUserBloc>().add(LoadAllUsers());
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 16), // 👈 Increased padding for shadow space
        child: Material(
          elevation: 0,
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColor.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 2,
                  spreadRadius: 2,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        // 👈 Wrapped in Expanded to prevent overflow
                        child: Row(
                          children: [
                            ProfileAvatar(
                                base64Image: widget.searchedUser.profileImage),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.searchedUser.displayName,
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          Text(
                            widget.searchedUser.mobileNumber,
                            style: GoogleFonts.poppins(
                              color: Colors.grey[700],
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          if (widget.searchedUser.unreadCount > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${widget.searchedUser.unreadCount}',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 2),
                    child: Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Email:",
                            style: GoogleFonts.poppins(
                              color: Colors.grey[700],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.searchedUser.email,
                            style: GoogleFonts.poppins(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: isColorValidation(context),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
