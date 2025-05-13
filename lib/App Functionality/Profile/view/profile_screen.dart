// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:typed_data';
import 'package:chat_app_bloc/App%20Functionality/Auth/bloc/authentication_bloc.dart';
import 'package:chat_app_bloc/App%20Functionality/Auth/bloc/authentication_event.dart';
import 'package:chat_app_bloc/App%20Functionality/Auth/view/signin_screen.dart';
import 'package:chat_app_bloc/App%20Functionality/Profile/animation/stagger_animation.dart';
import 'package:chat_app_bloc/App%20Functionality/Profile/bloc/profile_bloc.dart';
import 'package:chat_app_bloc/App%20Functionality/Profile/bloc/profile_event.dart';
import 'package:chat_app_bloc/App%20Functionality/Profile/bloc/profile_state.dart';
import 'package:chat_app_bloc/Constent/app_appbar.dart';
import 'package:chat_app_bloc/Constent/app_color.dart';
import 'package:chat_app_bloc/Constent/app_string.dart';
import 'package:chat_app_bloc/Service/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  Tween<double> tweenSize = Tween(begin: 1, end: 1);
  late AnimationController _controller;
  late AnimationController _controller2;

  late Animation<double> _opacityAnimation = _controller.drive(tweenSize);
  late Animation<Offset> _slideAnimation1;
  late Animation<Offset> _slideAnimation2;
  String? profileImage;
  String? mobileNumber;
  final AnalyticsService? analyticsService = AnalyticsService();

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    BlocProvider.of<ProfileBloc>(context).add(GetProfileImage());
  }

  void _logScreenView() async {
    await analyticsService!.logScreenView("ProfileScreen");
  }

  @override
  void initState() {
    super.initState();
    debugPrint("=> ProfileScreen initialized: Fetching user data...");
    _logScreenView();
    BlocProvider.of<ProfileBloc>(context).add(GetProfileData());
    BlocProvider.of<ProfileBloc>(context).add(GetProfileImage());

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacityAnimation = tweenSize.animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation1 =
        Tween<Offset>(begin: const Offset(0, 50), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _slideAnimation2 =
        Tween<Offset>(begin: const Offset(0, -50), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  bool isClicked = false;

  Future<void> playForwardAnimation() async {
    try {
      await _controller2.forward().orCancel;
    } on TickerCanceled {
      debugPrint("play Forward stop");
    }
  }

  Future<void> playReverseAnimation() async {
    try {
      await _controller2.reverse().orCancel;
    } on TickerCanceled {
      debugPrint("play Reverse stop");
    }
  }

  void handleTap() {
    if (isClicked) {
      playReverseAnimation();
    } else {
      playForwardAnimation();
    }
    setState(() {
      isClicked = !isClicked;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showModal(BuildContext context) {
    showModalBottomSheet<void>(
      isDismissible: true,
      elevation: 50,
      context: context,
      builder: (_) {
        return Container(
          height: 120,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: AppColor.mainColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.image,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: () async {
                          final image = await ImagePicker().pickImage(
                            imageQuality: 20,
                            source: ImageSource.gallery,
                          );
                          if (image != null) {
                            final imageTemp = XFile(image.path);
                            Uint8List imageBytes =
                                await imageTemp.readAsBytes();
                            String base64image = base64Encode(imageBytes);
                            setState(() {
                              profileImage = base64image;
                            });
                            context.read<ProfileBloc>().add(
                                  SelectProfile(profileImage!),
                                );
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const Text(
                      "Image",
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: AppColor.mainColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.camera,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: () async {
                          final image = await ImagePicker().pickImage(
                            imageQuality: 20,
                            source: ImageSource.camera,
                          );
                          if (image != null) {
                            final imageTemp = XFile(image.path);
                            Uint8List imageBytes =
                                await imageTemp.readAsBytes();
                            String base64image = base64Encode(imageBytes);
                            setState(() {
                              profileImage = base64image;
                            });
                            context.read<ProfileBloc>().add(
                                  SelectProfile(profileImage!),
                                );
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const Text(
                      "Camera",
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.mainColor,
      appBar: CustomeAppBar(
        actions: [
          IconButton(
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(SignOutUser());
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SigninScreen()),
              );
              analyticsService?.logLogOut('User LogOut');
              debugPrint('=>User Logout Successfully');
            },
            icon: const FaIcon(
              // ignore: deprecated_member_use
              FontAwesomeIcons.signOutAlt,
              color: Colors.white,
            ),
          ),
        ],
        automaticallyImplyLeadings: false,
        titleWidget: Text(
          "Profile",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            debugPrint("=> Loading user data...");
            return Center(
              child: CircularProgressIndicator(
                color: AppColor.backgroundColor,
              ),
            );
          } else if (state is ProfileLoaded) {
            final user = state.user;
            profileImage = user.profileImage ?? AppString.demoImgurl;
            debugPrint(
              "=> User data loaded: ${user.displayName}, ${user.email}",
            );
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SlideTransition(
                      position: _slideAnimation2,
                      child: AnimatedOpacity(
                        opacity: _opacityAnimation.value,
                        duration: const Duration(milliseconds: 700),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: profileImage != null
                                  ? GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          anchorPoint: const Offset(5, 1),
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SimpleDialog(
                                              title: Center(
                                                child: Text(
                                                  "Profile Image",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 18,
                                                      vertical: 5),
                                                  child: Text(
                                                    "Tap to show Profile with Animation",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  behavior:
                                                      HitTestBehavior.opaque,
                                                  onTap: () {
                                                    handleTap();
                                                  },
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: StaggerAnimation(
                                                        controller:
                                                            _controller2.view,
                                                        imageurl: profileImage!,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: ClipOval(
                                        child: Image.memory(
                                          base64Decode(profileImage!),
                                          fit: BoxFit.cover,
                                          width: 120,
                                          height: 120,
                                        ),
                                      ),
                                    )
                                  : ClipOval(
                                      child: Image.memory(
                                        base64Decode(AppString.demoImgurl),
                                        fit: BoxFit.cover,
                                        width: 120,
                                        height: 120,
                                      ),
                                    ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  showModal(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColor.mainColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FaIcon(
                                      FontAwesomeIcons.pen,
                                      size: 18,
                                      color: AppColor.mainColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SlideTransition(
                      position: _slideAnimation2,
                      child: AnimatedOpacity(
                        opacity: _opacityAnimation.value,
                        duration: const Duration(milliseconds: 700),
                        child: Text(
                          '${user.displayName}',
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                    SlideTransition(
                      position: _slideAnimation2,
                      child: AnimatedOpacity(
                        opacity: _opacityAnimation.value,
                        duration: const Duration(milliseconds: 700),
                        child: Text(
                          '${user.email}',
                          style: GoogleFonts.poppins(
                              color: Colors.grey.shade300, fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    SlideTransition(
                      position: _slideAnimation1,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 700),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 230, 230, 230),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 25),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'User Id',
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey, fontSize: 15),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 3,
                                    ),
                                    child: Text(
                                      '${user.id}',
                                      style: GoogleFonts.poppins(
                                          color: Colors.black, fontSize: 17),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 7),
                              const Divider(),
                              const SizedBox(height: 7),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Display Name',
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey, fontSize: 15),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 3,
                                    ),
                                    child: Text(
                                      '${user.displayName}',
                                      style: GoogleFonts.poppins(
                                          color: Colors.black, fontSize: 17),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 7),
                              const Divider(),
                              const SizedBox(height: 7),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email Address',
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey, fontSize: 15),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 3,
                                    ),
                                    child: Text(
                                      '${user.email}',
                                      style: GoogleFonts.poppins(
                                          color: Colors.black, fontSize: 17),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 7),
                              const Divider(),
                              const SizedBox(height: 7),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Phone Number',
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey, fontSize: 15),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 3,
                                    ),
                                    child: Text(
                                      '${user.mobileNumber}',
                                      style: GoogleFonts.poppins(
                                          color: Colors.black, fontSize: 17),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.mainColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  onPressed: () {
                                    BlocProvider.of<AuthenticationBloc>(context)
                                        .add(SignOutUser());
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SigninScreen()),
                                    );
                                    analyticsService?.logLogOut('User LogOut');
                                    debugPrint('=>User Logout Successfully');
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const FaIcon(
                                        // ignore: deprecated_member_use
                                        FontAwesomeIcons.signOutAlt,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        'Log Out',
                                        style: GoogleFonts.poppins(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
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
          } else if (state is ProfileError) {
            debugPrint("=> Error loading user: ${state.errorMessage}");
            return Center(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/sorry.png",
                    height: 150,
                    width: 150,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    state.errorMessage,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          } else {
            debugPrint("=> No user data available.");
            return const Center(
                child: Text(
              'No user data available',
              style: TextStyle(color: Colors.white),
            ));
          }
        },
      ),
    );
  }
}
