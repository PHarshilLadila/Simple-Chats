import 'package:chat_app_bloc/App%20Functionality/Chat%20Screen/view/chat_screen.dart';
import 'package:chat_app_bloc/App%20Functionality/Search%20User/model/searched_user_model.dart';
import 'package:chat_app_bloc/App%20Functionality/Search%20User/widgets/user_profile_picture.dart';
import 'package:chat_app_bloc/Constent/app_color.dart';
import 'package:chat_app_bloc/Service/analytics_service.dart';
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
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(firebaseUser!.uid).get();
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
        mainCurretnUserName ?? "non", // change here
        widget.searchedUser.displayName);
    debugPrint("=> This is searched user list chatId : $userchatId");

    return GestureDetector(
      onTap: () {
        Navigator.push(
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
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColor.whiteColor,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5,
                      offset: Offset(0, 4),
                    ),
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ProfileAvatar(
                                base64Image: widget.searchedUser.profileImage),

                            // Container(
                            //   decoration: BoxDecoration(
                            //     border: Border.all(),
                            //     shape: BoxShape.circle,
                            //   ),
                            //   width: 40,
                            //   height: 40,
                            //   child: ClipOval(
                            //     child: FutureBuilder<Uint8List>(
                            //       future: Future.delayed(
                            //           Duration(milliseconds: 100), () {
                            //         return base64Decode(
                            //             widget.searchedUser.profileImage);
                            //       }),
                            //       builder: (context, snapshot) {
                            //         if (snapshot.connectionState ==
                            //             ConnectionState.waiting) {
                            //           return const Center(
                            //             child: SizedBox(
                            //               width: 20,
                            //               height: 20,
                            //               child: CircularProgressIndicator(
                            //                   strokeWidth: 2),
                            //             ),
                            //           );
                            //         } else if (snapshot.hasError) {
                            //           return const Center(
                            //               child: Icon(Icons.error));
                            //         } else if (!snapshot.hasData) {
                            //           return const FaIcon(
                            //               FontAwesomeIcons.user);
                            //         } else {
                            //           return Image.memory(
                            //             snapshot.data!,
                            //             fit: BoxFit.cover,
                            //             width: 40,
                            //             height: 40,
                            //             errorBuilder:
                            //                 (context, error, stackTrace) {
                            //               return const FaIcon(
                            //                   FontAwesomeIcons.user);
                            //             },
                            //           );
                            //         }
                            //       },
                            //     ),
                            //   ),
                            // ),

                            // Container(
                            //   decoration: BoxDecoration(
                            //       border: Border.all(), shape: BoxShape.circle),
                            //   child: ClipOval(
                            //     child: Image.memory(
                            //       height: 40,
                            //       width: 40,
                            //       base64Decode(
                            //           widget.searchedUser.profileImage),
                            //       fit: BoxFit.cover,
                            //       errorBuilder: (context, error, stackTrace) {
                            //         return FaIcon(FontAwesomeIcons.user);
                            //       },
                            //     ),
                            //   ),
                            // ),
                            // const FaIcon(
                            //   FontAwesomeIcons.user,
                            //   size: 18,
                            // ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.searchedUser.displayName,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.searchedUser.mobileNumber,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            wordSpacing: 10,
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 100,
                      child: Divider(),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "Email :",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          widget.searchedUser.email,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
