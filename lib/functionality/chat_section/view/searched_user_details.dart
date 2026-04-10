// import 'dart:convert';

// import 'package:chat_app_bloc/App%20Functionality/Chat%20Screen/view/image_view.dart';
// import 'package:chat_app_bloc/Constent/app_color.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';

// class SearchedUserDetails extends StatelessWidget {
//   final String? username;
//   final String? userMobile;
//   final String? userProfile;
//   final String? userEmail;
//   const SearchedUserDetails({
//     super.key,
//     this.username,
//     this.userMobile,
//     this.userProfile,
//     this.userEmail,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.backgroundColor,
//       appBar: AppBar(
//         toolbarHeight: 70,
//         automaticallyImplyLeading: false,
//         leading: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: GestureDetector(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                   color: Colors.transparent,
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.white)),
//               child: const Center(
//                 child: FaIcon(
//                   FontAwesomeIcons.arrowLeft,
//                   size: 18,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         backgroundColor: Theme.of(context).primaryColor,
//         centerTitle: true,
//         title: const Text(
//           "User Details",
//           style: TextStyle(
//             fontSize: 20,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Center(
//               child: ClipOval(
//                 child: GestureDetector(
//                   onDoubleTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ImageView(imageUrl: userProfile!),
//                       ),
//                     );
//                   },
//                   child: Image.memory(
//                     height: 150,
//                     width: 150,
//                     base64Decode(userProfile!),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Container(
//               width: double.infinity,
//               height: 40,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5),
//                 color: Theme.of(context).primaryColor,
//               ),
//               child: Center(
//                 child: Text(
//                   "$username",
//                   style: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             Container(
//               decoration: BoxDecoration(
//                   color: const Color.fromARGB(255, 217, 240, 237),
//                   borderRadius: BorderRadius.circular(10)),
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Mobile",
//                           style: GoogleFonts.poppins(
//                             color: Colors.black,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           "$userMobile",
//                           style: GoogleFonts.poppins(
//                             color: Colors.black,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 7,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Email",
//                           style: GoogleFonts.poppins(
//                             color: Colors.black,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           "$userEmail",
//                           style: GoogleFonts.poppins(
//                             color: Colors.black,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:chat_app_bloc/app_widget/app_appbar.dart';
import 'package:chat_app_bloc/functionality/chat_section/view/image_view.dart';
import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchedUserDetails extends StatefulWidget {
  final String? username;
  final String? userMobile;
  final String? userProfile;
  final String? userEmail;
  const SearchedUserDetails({
    super.key,
    this.username,
    this.userMobile,
    this.userProfile,
    this.userEmail,
  });

  @override
  State<SearchedUserDetails> createState() => _SearchedUserDetailsState();
}

class _SearchedUserDetailsState extends State<SearchedUserDetails>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation1;
  late Animation<Offset> _slideAnimation2;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _slideAnimation1 = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );

    _slideAnimation2 = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.9, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: CustomeAppBar(
        automaticallyImplyLeadings: false,
        titleWidget: Text(
          "User Details",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: isColorValidation(context),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 12),
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
      // AppBar(
      //   toolbarHeight: 70,
      //   automaticallyImplyLeading: false,
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      //   leading: GestureDetector(
      //     onTap: () {
      //       Navigator.pop(context);
      //     },
      //     child: Container(
      //       margin: const EdgeInsets.only(left: 12),
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
      //     "User Details",
      //     style: GoogleFonts.poppins(
      //       fontSize: 20,
      //       fontWeight: FontWeight.w600,
      //       color: const Color(0xFF1F2937),
      //     ),
      //   ),
      // ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Image with Animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onDoubleTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ImageView(imageUrl: widget.userProfile!),
                          ),
                        );
                      },
                      child: Hero(
                        tag: 'profile-${widget.username}',
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.memory(
                              height: 150,
                              width: 150,
                              base64Decode(widget.userProfile!),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 150,
                                  width: 150,
                                  color: Theme.of(context).primaryColor,
                                  child: const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Hint text for double tap
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  "Double tap on image to view full screen",
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF9CA3AF),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Username Container with Animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation1,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        widget.username ?? "User Name",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Details Card with Animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation2,
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
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Mobile Row
                          _buildInfoRow(
                            icon: FontAwesomeIcons.mobile,
                            label: "Mobile Number",
                            value: widget.userMobile ?? "Not provided",
                            iconColor: Theme.of(context).primaryColor,
                          ),

                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Divider(
                              color: Color(0xFFE5E7EB),
                              thickness: 1,
                              height: 1,
                            ),
                          ),

                          // Email Row
                          _buildInfoRow(
                            icon: FontAwesomeIcons.envelope,
                            label: "Email Address",
                            value: widget.userEmail ?? "Not provided",
                            iconColor: Theme.of(context).primaryColor,
                          ),

                          // const SizedBox(height: 8),

                          // // Action Buttons
                          // const SizedBox(height: 16),
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: _buildActionButton(
                          //         icon: FontAwesomeIcons.solidMessage,
                          //         label: "Message",
                          //         color: const Color(0xFF6366F1),
                          //         onTap: () {
                          //           ScaffoldMessenger.of(context).showSnackBar(
                          //             SnackBar(
                          //               content:
                          //                   Text("Message feature coming soon"),
                          //               behavior: SnackBarBehavior.floating,
                          //               shape: RoundedRectangleBorder(
                          //                 borderRadius:
                          //                     BorderRadius.circular(10),
                          //               ),
                          //             ),
                          //           );
                          //         },
                          //       ),
                          //     ),
                          //     const SizedBox(width: 12),
                          //     Expanded(
                          //       child: _buildActionButton(
                          //         icon: FontAwesomeIcons.phone,
                          //         label: "Call",
                          //         color: const Color(0xFF10B981),
                          //         onTap: () {
                          //           ScaffoldMessenger.of(context).showSnackBar(
                          //             SnackBar(
                          //               content:
                          //                   Text("Call feature coming soon"),
                          //               behavior: SnackBarBehavior.floating,
                          //               shape: RoundedRectangleBorder(
                          //                 borderRadius:
                          //                     BorderRadius.circular(10),
                          //               ),
                          //             ),
                          //           );
                          //         },
                          //       ),
                          //     ),
                          //   ],
                          // ),
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: FaIcon(
            icon,
            size: 18,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF6B7280),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF1F2937),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildActionButton({
  //   required IconData icon,
  //   required String label,
  //   required Color color,
  //   required VoidCallback onTap,
  // }) {
  //   return Material(
  //     color: Colors.transparent,
  //     child: InkWell(
  //       onTap: onTap,
  //       borderRadius: BorderRadius.circular(12),
  //       child: Container(
  //         padding: const EdgeInsets.symmetric(vertical: 12),
  //         decoration: BoxDecoration(
  //           color: color.withOpacity(0.1),
  //           borderRadius: BorderRadius.circular(12),
  //           border: Border.all(
  //             color: color.withOpacity(0.2),
  //             width: 1,
  //           ),
  //         ),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             FaIcon(
  //               icon,
  //               size: 16,
  //               color: color,
  //             ),
  //             const SizedBox(width: 8),
  //             Text(
  //               label,
  //               style: GoogleFonts.poppins(
  //                 color: color,
  //                 fontSize: 14,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
