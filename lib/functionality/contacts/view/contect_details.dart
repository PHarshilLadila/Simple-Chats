// import 'package:chat_app_bloc/Constent/app_color.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ContactDetails extends StatefulWidget {
//   final String? fLatter;
//   final String? mobilenumber;
//   final String? contactName;
//   const ContactDetails({
//     super.key,
//     this.fLatter,
//     this.mobilenumber,
//     this.contactName,
//   });

//   @override
//   State<ContactDetails> createState() => _ContactDetailsState();
// }

// class _ContactDetailsState extends State<ContactDetails>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   Tween<Offset> tweenController1 =
//       Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0));
//   Tween<Offset> tweenController2 =
//       Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0));
//   Tween<Offset> tweenController3 =
//       Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0));
//   @override
//   void initState() {
//     super.initState();

//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );

//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _callContact(String phoneNumber) async {
//     final Uri url = Uri(scheme: 'tel', path: phoneNumber); // Use Uri.parse

//     if (await canLaunchUrl(url)) {
//       // Use canLaunchUrl
//       await launchUrl(url);
//     } else {
//       debugPrint("=> Could not launch $url");
//     }
//   }

//   void _messageContact(String phoneNumber) async {
//     final Uri url = Uri(scheme: 'sms', path: phoneNumber); // Use Uri.parse

//     if (await canLaunchUrl(url)) {
//       // Use canLaunchUrl
//       await launchUrl(url);
//     } else {
//       debugPrint("=> Could not launch $url");
//     }
//   }

//   void launchWhatsapp() async {
//     var whatsapp = "${widget.mobilenumber}";
//     var whatsappAndroid =
//         Uri.parse("whatsapp://send?phone=$whatsapp&text=hello");
//     if (await canLaunchUrl(whatsappAndroid)) {
//       await launchUrl(whatsappAndroid);
//     } else {
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("WhatsApp is not installed on the device"),
//         ),
//       );
//     }
//   }

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   getcallLog();
//   // }

//   // Future<void> getcallLog() async {
//   //   var now = DateTime.now();
//   //   int from = now.subtract(const Duration(days: 60)).millisecondsSinceEpoch;
//   //   int to = now.subtract(const Duration(days: 30)).millisecondsSinceEpoch;
//   //   if (await Permission.phone.request().isGranted) {
//   //     Iterable<CallLogEntry> entries = await CallLog.query(
//   //       dateFrom: from,
//   //       dateTo: to,
//   //       durationFrom: 0,
//   //       durationTo: 60,
//   //       name: widget.contactName!,
//   //       number: widget.contactName,
//   //       type: CallType.incoming,
//   //     );
//   //     debugPrint("$entries");
//   //   } else {
//   //     debugPrint("Call Read Permission Denied");
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.backgroundColor,
//       appBar: AppBar(
//         toolbarHeight: 70,
//         automaticallyImplyLeading: false,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 15.0),
//           child: GestureDetector(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                   color: Colors.transparent,
//                   shape: BoxShape.circle,
//                   border: Border.all(color: AppColor.blackColor)),
//               child: Center(
//                 child: FaIcon(
//                   FontAwesomeIcons.arrowLeft,
//                   size: 18,
//                   color: AppColor.blackColor,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         elevation: 1,
//         backgroundColor: AppColor.mainColor,
//         centerTitle: true,
//         title: Text(
//           "Contact Details",
//           style: TextStyle(
//             color: AppColor.blackColor,
//             fontWeight: FontWeight.w600,
//             fontSize: 20,
//             letterSpacing: 0.5,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         physics: const BouncingScrollPhysics(),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(
//                 height: 20,
//               ),
//               Stack(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 40.0, bottom: 20),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(vertical: 25),
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           boxShadow: const [
//                             BoxShadow(
//                                 offset: Offset(5, 2),
//                                 color: Color.fromARGB(255, 206, 206, 206),
//                                 blurRadius: 10),
//                           ],
//                           borderRadius: BorderRadius.circular(
//                             10,
//                           )),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const SizedBox(
//                             height: 50,
//                           ),
//                           Text(
//                             widget.contactName ?? "",
//                             style: GoogleFonts.poppins(
//                               color: Colors.black,
//                               fontSize: 20,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 6,
//                           ),
//                           Text(
//                             widget.mobilenumber ?? "",
//                             style: GoogleFonts.poppins(
//                               color: Colors.black,
//                               fontSize: 15,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 25,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               SlideTransition(
//                                 position: _animationController
//                                     .drive(tweenController1),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                       color: AppColor.mainColor,
//                                       shape: BoxShape.circle),
//                                   child: IconButton(
//                                     onPressed: () {
//                                       if (widget.mobilenumber!.isNotEmpty) {
//                                         _callContact(widget.mobilenumber!);
//                                       } else {
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(
//                                           const SnackBar(
//                                               content: Text(
//                                                   "No phone number available")),
//                                         );
//                                       }
//                                     },
//                                     icon: const FaIcon(
//                                       FontAwesomeIcons.phone,
//                                       color: Colors.white,
//                                       size: 20,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SlideTransition(
//                                 position: _animationController
//                                     .drive(tweenController2),
//                                 child: Container(
//                                   decoration: const BoxDecoration(
//                                       color: Colors.blue,
//                                       shape: BoxShape.circle),
//                                   child: IconButton(
//                                     onPressed: () {
//                                       if (widget.mobilenumber!.isNotEmpty) {
//                                         _messageContact(widget.mobilenumber!);
//                                       } else {
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(
//                                           const SnackBar(
//                                               content: Text(
//                                                   "No phone number available")),
//                                         );
//                                       }
//                                     },
//                                     icon: const FaIcon(
//                                       FontAwesomeIcons.solidMessage,
//                                       color: Colors.white,
//                                       size: 20,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SlideTransition(
//                                 position: _animationController
//                                     .drive(tweenController3),
//                                 child: Container(
//                                   decoration: const BoxDecoration(
//                                       color: Colors.blueGrey,
//                                       shape: BoxShape.circle),
//                                   child: IconButton(
//                                     onPressed: () {
//                                       String sharedetails =
//                                           "Contact Name : ${widget.contactName!} \nContact Number : ${widget.mobilenumber!}";
//                                       Share.share(sharedetails,
//                                           subject: "Contact Details");
//                                     },
//                                     icon: const FaIcon(
//                                       FontAwesomeIcons.share,
//                                       color: Colors.white,
//                                       size: 20,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   AnimatedBuilder(
//                     animation: _animationController,
//                     builder: (BuildContext context, Widget? child) {
//                       return Positioned(
//                         top: 0,
//                         left: 150,
//                         child: Transform.scale(
//                           scale: _animationController.value,
//                           child: SizedBox(
//                             height: 100,
//                             width: 100,
//                             child: CircleAvatar(
//                               backgroundColor:
//                                   const Color.fromARGB(255, 213, 230, 213),
//                               child: Container(
//                                 height: 60,
//                                 width: 60,
//                                 decoration: const BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Color.fromARGB(255, 225, 240, 225)),
//                                 child: Center(
//                                   child: Text(
//                                     widget.fLatter ?? "?",
//                                     style: GoogleFonts.poppins(
//                                       color: Colors.black,
//                                       fontSize: 30,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           launchWhatsapp();
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "Whatsapp",
//                                 style: GoogleFonts.poppins(
//                                   color: Colors.black,
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               FaIcon(
//                                 FontAwesomeIcons.whatsapp,
//                                 color: AppColor.mainColor,
//                                 size: 30,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Telegram",
//                               style: GoogleFonts.poppins(
//                                 color: Colors.black,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             const FaIcon(
//                               FontAwesomeIcons.telegram,
//                               color: Colors.blue,
//                               size: 30,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:chat_app_bloc/app_widget/app_appbar.dart';
import 'package:chat_app_bloc/app_widget/app_snackbar.dart';
import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart';

class ContactDetails extends StatefulWidget {
  final String? fLatter;
  final String? mobilenumber;
  final String? contactName;
  const ContactDetails({
    super.key,
    this.fLatter,
    this.mobilenumber,
    this.contactName,
  });

  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _staggerController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation1;
  late Animation<Offset> _slideAnimation2;
  late Animation<Offset> _slideAnimation3;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _slideAnimation1 = Tween<Offset>(
      begin: const Offset(-0.5, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation2 = Tween<Offset>(
      begin: const Offset(-0.5, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );

    _slideAnimation3 = Tween<Offset>(
      begin: const Offset(-0.5, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
      ),
    );

    _staggerController.forward();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  void _callContact(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint("=> Could not launch $url");
    }
  }

  void _messageContact(String phoneNumber) async {
    final Uri url = Uri(scheme: 'sms', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint("=> Could not launch $url");
    }
  }

  void launchWhatsapp() async {
    var whatsapp = "${widget.mobilenumber}";
    var whatsappAndroid =
        Uri.parse("whatsapp://send?phone=$whatsapp&text=hello");
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {
      AppSnackbar.error(context, "WhatsApp is not installed");
    }
  }

  Widget _buildShimmerLoader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            period: const Duration(milliseconds: 1200),
            child: Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            period: const Duration(milliseconds: 1200),
            child: Container(
              width: 200,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            period: const Duration(milliseconds: 1200),
            child: Container(
              width: 150,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: CustomeAppBar(
        automaticallyImplyLeadings: false,
        titleWidget: Text(
          "Contact Details",
          style: GoogleFonts.poppins(
            color: isColorValidation(context),
            fontWeight: FontWeight.w600,
            fontSize: 20,
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
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.arrowLeft,
                size: 18,
                color: Color(0xFF4B5563),
              ),
            ),
          ),
        ),
      ),
      //  AppBar(
      //   toolbarHeight: 70,
      //   automaticallyImplyLeading: false,
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      //   leading: GestureDetector(
      //     onTap: () {
      //       Navigator.pop(context);
      //     },
      //     child: Container(
      //       margin: const EdgeInsets.only(left: 16),
      //       decoration: BoxDecoration(
      //         color: Colors.white,
      //         shape: BoxShape.circle,
      //         boxShadow: [
      //           BoxShadow(
      //             color: Colors.grey.withOpacity(0.1),
      //             blurRadius: 8,
      //             spreadRadius: 0,
      //             offset: const Offset(0, 2),
      //           ),
      //         ],
      //       ),
      //       child: const Center(
      //         child: FaIcon(
      //           FontAwesomeIcons.arrowLeft,
      //           size: 18,
      //           color: Color(0xFF4B5563),
      //         ),
      //       ),
      //     ),
      //   ),
      //   centerTitle: true,
      //   title: Text(
      //     "Contact Details",
      //     style: GoogleFonts.poppins(
      //       color: const Color(0xFF1F2937),
      //       fontWeight: FontWeight.w600,
      //       fontSize: 20,
      //       letterSpacing: 0.5,
      //     ),
      //   ),
      // ),
      body: FutureBuilder(
        future: Future.delayed(
            const Duration(milliseconds: 500)), // Simulate loading
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: _buildShimmerLoader());
          }
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),

                  // Profile Card with Avatar
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            blurRadius: 20,
                            spreadRadius: 0,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            // Avatar with scale animation
                            ScaleTransition(
                              scale: _scaleAnimation,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).primaryColor,
                                      Theme.of(context).primaryColor,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 55,
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.fLatter?.toUpperCase() ?? "?",
                                        style: GoogleFonts.poppins(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 42,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Contact Name
                            Text(
                              widget.contactName ?? "Unknown Contact",
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF1F2937),
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 4),

                            // Mobile Number
                            GestureDetector(
                              onLongPress: () {
                                Clipboard.setData(ClipboardData(
                                    text: widget.mobilenumber ?? ""));
                                AppSnackbar.success(context,
                                    "Mobile number copied to clipboard");
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  widget.mobilenumber ?? "No number available",
                                  style: GoogleFonts.poppins(
                                    color: isColorValidation(context),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Action Buttons Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildActionButton(
                                  animation: _slideAnimation1,
                                  color: Colors.green,
                                  icon: FontAwesomeIcons.phone,
                                  label: "Call",
                                  onTap: () {
                                    if (widget.mobilenumber!.isNotEmpty) {
                                      _callContact(widget.mobilenumber!);
                                    } else {
                                      _showErrorSnackBar(
                                          "No phone number available");
                                    }
                                  },
                                ),
                                _buildActionButton(
                                  animation: _slideAnimation2,
                                  color: Colors.blue,
                                  icon: FontAwesomeIcons.solidMessage,
                                  label: "Message",
                                  onTap: () {
                                    if (widget.mobilenumber!.isNotEmpty) {
                                      _messageContact(widget.mobilenumber!);
                                    } else {
                                      _showErrorSnackBar(
                                          "No phone number available");
                                    }
                                  },
                                ),
                                _buildActionButton(
                                  animation: _slideAnimation3,
                                  color: Color(0xFF8E2DE2),
                                  icon: FontAwesomeIcons.share,
                                  label: "Share",
                                  onTap: () {
                                    String sharedetails =
                                        "Contact Name: ${widget.contactName!}\nContact Number: ${widget.mobilenumber!}";
                                    Share.share(sharedetails,
                                        subject: "Contact Details");
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Social Apps Section
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            blurRadius: 20,
                            spreadRadius: 0,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8, bottom: 12),
                              child: Text(
                                "Message on Apps",
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF6B7280),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                            socialAppTile(
                              icon: FontAwesomeIcons.whatsapp,
                              name: "WhatsApp",
                              color: const Color(0xFF25D366),
                              onTap: launchWhatsapp,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(
                                color: Color(0xFFE5E7EB),
                                thickness: 1,
                                height: 1,
                              ),
                            ),
                            socialAppTile(
                              icon: FontAwesomeIcons.telegram,
                              name: "Telegram",
                              color: const Color(0xFF0088cc),
                              onTap: () {
                                AppSnackbar.show(
                                  context,
                                  message: "Telegram coming soon",
                                  icon: Icons.telegram,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required Animation<Offset> animation,
    required Color color,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SlideTransition(
      position: animation,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: FaIcon(
                    icon,
                    size: 18,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget socialAppTile({
    required IconData icon,
    required String name,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: FaIcon(
                      icon,
                      color: color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF1F2937),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    AppSnackbar.error(context, message);
  }
}
