// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:convert';
import 'dart:typed_data';
import 'package:chat_app_bloc/functionality/Auth/bloc/authentication_bloc.dart';
import 'package:chat_app_bloc/functionality/Auth/bloc/authentication_event.dart';
import 'package:chat_app_bloc/functionality/Auth/view/signin_screen.dart';
import 'package:chat_app_bloc/functionality/profile/bloc/profile_bloc.dart';
import 'package:chat_app_bloc/functionality/profile/bloc/profile_event.dart';
import 'package:chat_app_bloc/functionality/profile/bloc/profile_state.dart';
import 'package:chat_app_bloc/app_widget/app_appbar.dart';
import 'package:chat_app_bloc/functionality/settings/help_and_support/screens/about_scree.dart';
import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:chat_app_bloc/utils/constent/app_string.dart';
import 'package:chat_app_bloc/functionality/settings/appearance/appearance_screen.dart';
import 'package:chat_app_bloc/functionality/settings/chat_setting/chat_setting_screen.dart';
import 'package:chat_app_bloc/functionality/settings/help_and_support/help_screen.dart';
import 'package:chat_app_bloc/functionality/settings/notification_setting/notification_setting_screen.dart';
import 'package:chat_app_bloc/functionality/profile/view/profile_full_image.dart';
import 'package:chat_app_bloc/functionality/settings/privacy_and_policy/privacy_and_policy_screen.dart';
import 'package:chat_app_bloc/service/analytics_service.dart';
import 'package:chat_app_bloc/app_widget/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController animController;
  late AnimationController animController2;
  late AnimationController shimmerController;

  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation1;
  late Animation<Offset> slideAnimation2;
  late Animation<double> scaleAnimation;

  String? profileImage;
  String? mobileNumber;
  final AnalyticsService? analyticsService = AnalyticsService();

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    BlocProvider.of<ProfileBloc>(context).add(GetProfileImage());
  }

  void logScreenView() async {
    await analyticsService!.logScreenView("ProfileScreen");
  }

  @override
  void initState() {
    super.initState();
    debugPrint("=> ProfileScreen initialized: Fetching user data...");
    logScreenView();
    BlocProvider.of<ProfileBloc>(context).add(GetProfileData());
    BlocProvider.of<ProfileBloc>(context).add(GetProfileImage());

    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    animController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: animController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    slideAnimation1 = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );

    slideAnimation2 = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animController,
        curve: const Interval(0.1, 0.5, curve: Curves.easeOut),
      ),
    );

    animController.forward();
  }

  bool isClicked = false;

  Future<void> playForwardAnimation() async {
    try {
      await animController2.forward().orCancel;
    } on TickerCanceled {
      debugPrint("play Forward stop");
    }
  }

  Future<void> playReverseAnimation() async {
    try {
      await animController2.reverse().orCancel;
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
    animController.dispose();
    animController2.dispose();
    shimmerController.dispose();
    super.dispose();
  }

  void showModal(BuildContext context) {
    showModalBottomSheet<void>(
      isDismissible: true,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (_) {
        return Container(
          height: 180,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 12),
                  child: Text(
                    'Choose Profile Picture',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    bottomModalOptionToChangeProfilePic(
                      icon: FontAwesomeIcons.image,
                      label: 'Gallery',
                      color: Theme.of(context).primaryColor,
                      onTap: () async {
                        final image = await ImagePicker().pickImage(
                          imageQuality: 20,
                          source: ImageSource.gallery,
                        );
                        if (image != null) {
                          final imageTemp = XFile(image.path);
                          Uint8List imageBytes = await imageTemp.readAsBytes();
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
                    const SizedBox(width: 20),
                    bottomModalOptionToChangeProfilePic(
                      icon: FontAwesomeIcons.camera,
                      label: 'Camera',
                      color: Theme.of(context).primaryColor,
                      onTap: () async {
                        final image = await ImagePicker().pickImage(
                          imageQuality: 20,
                          source: ImageSource.camera,
                        );
                        if (image != null) {
                          final imageTemp = XFile(image.path);
                          Uint8List imageBytes = await imageTemp.readAsBytes();
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
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget bottomModalOptionToChangeProfilePic({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: FaIcon(
                  icon,
                  color: isColorValidation(context),
                  size: 22,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: AppColor.blackColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget shimmerLoader() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              period: const Duration(milliseconds: 1500),
              child: Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              period: const Duration(milliseconds: 1500),
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
              period: const Duration(milliseconds: 1500),
              child: Container(
                width: 150,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              period: const Duration(milliseconds: 1500),
              child: Container(
                width: double.infinity,
                height: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoRow(String label, String value, {bool isLast = false}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 6),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColor.blackColor.withOpacity(0.03),
        border: Border.all(color: AppColor.blackColor.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.grey[600],
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.grey[900],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.6)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.arrowRightFromBracket,
                    color: isColorValidation(context),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Sign Out',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Are you sure you want to sign out?',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          BlocProvider.of<AuthenticationBloc>(context)
                              .add(SignOutUser());
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SigninScreen()),
                          );
                          analyticsService?.logLogOut('User LogOut');
                          debugPrint('=>User Logout Successfully');
                          AppSnackbar.success(
                            context,
                            'User Logout Successfully',
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).primaryColor.withOpacity(0.6),
                                Theme.of(context).primaryColor,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Sign Out',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isColorValidation(context),
                              ),
                            ),
                          ),
                        ),
                      ),
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
      backgroundColor: AppColor.backgroundColor,
      appBar: CustomeAppBar(
        actions: [
          IconButton(
            onPressed: () => showSignOutDialog(context),
            // () {
            //   BlocProvider.of<AuthenticationBloc>(context).add(SignOutUser());
            //   Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(builder: (context) => const SigninScreen()),
            //   );
            //   analyticsService?.logLogOut('User LogOut');
            //   debugPrint('=>User Logout Successfully');
            // },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: FaIcon(
                FontAwesomeIcons.arrowRightFromBracket,
                color: isColorValidation(context),
                size: 18,
              ),
            ),
          ),
        ],
        automaticallyImplyLeadings: false,
        titleWidget: Text(
          "Profile",
          style: GoogleFonts.poppins(
            color: isColorValidation(context),
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            debugPrint("=> Loading user data...");
            return shimmerLoader();
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
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: fadeAnimation,
                      child: ScaleTransition(
                        scale: scaleAnimation,
                        child: SlideTransition(
                          position: slideAnimation2,
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 20,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 20,
                                            spreadRadius: 2,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: profileImage != null
                                          ? GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProfileFullImage(
                                                      imageurl: profileImage!,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.white,
                                                    width: 3,
                                                  ),
                                                ),
                                                child: ClipOval(
                                                  child: Image.memory(
                                                    base64Decode(profileImage!),
                                                    fit: BoxFit.cover,
                                                    width: 120,
                                                    height: 120,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : ClipOval(
                                              child: Image.memory(
                                                base64Decode(
                                                    AppString.demoImgurl),
                                                fit: BoxFit.cover,
                                                width: 120,
                                                height: 120,
                                              ),
                                            ),
                                    ),
                                    Positioned(
                                      bottom: 5,
                                      right: 5,
                                      child: GestureDetector(
                                        onTap: () {
                                          showModal(context);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.3),
                                                blurRadius: 8,
                                                spreadRadius: 1,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: FaIcon(
                                            FontAwesomeIcons.pencil,
                                            size: 16,
                                            color: isColorValidation(context),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                FadeTransition(
                                  opacity: fadeAnimation,
                                  child: SlideTransition(
                                    position: slideAnimation2,
                                    child: Column(
                                      children: [
                                        Text(
                                          user.displayName ?? 'User Name',
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey[900],
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          user.email ?? 'email@example.com',
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
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
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeTransition(
                      opacity: fadeAnimation,
                      child: SlideTransition(
                        position: slideAnimation1,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                spreadRadius: 0,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "User Details",
                                  style: GoogleFonts.poppins(
                                    color: AppColor.blackColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 12),
                                infoRow('User ID', user.id ?? 'N/A'),
                                infoRow(
                                    'Display Name', user.displayName ?? 'N/A'),
                                infoRow('Email', user.email ?? 'N/A'),
                                infoRow('Phone Number',
                                    user.mobileNumber ?? 'Not added',
                                    isLast: true),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    FadeTransition(
                      opacity: fadeAnimation,
                      child: SlideTransition(
                        position: slideAnimation1,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                spreadRadius: 0,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Settings",
                                  style: GoogleFonts.poppins(
                                    color: AppColor.blackColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                SettingTile(
                                  icon: Icons.notifications,
                                  title: "Notifications",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const NotificationSettingScreen()),
                                    );
                                  },
                                ),
                                SettingTile(
                                  icon: Icons.chat,
                                  title: "Chats",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ChatSettingScreen(),
                                      ),
                                    );
                                  },
                                ),
                                SettingTile(
                                  icon: Icons.color_lens,
                                  title: "Appearance",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AppearanceScreen(),
                                      ),
                                    );
                                  },
                                ),
                                SettingTile(
                                  icon: Icons.lock,
                                  title: "Privacy & Policy",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const PrivacyPolicyScreen(),
                                      ),
                                    );
                                  },
                                ),
                                SettingTile(
                                  icon: Icons.help,
                                  title: "Help Center",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const HelpScreen(),
                                      ),
                                    );
                                  },
                                ),
                                SettingTile(
                                  icon: Icons.info,
                                  title: "About",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AboutScreen(),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      foregroundColor: Colors.black,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    onPressed: () {
                                      showSignOutDialog(context);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons
                                              .arrowRightFromBracket,
                                          color: isColorValidation(context),
                                          size: 18,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Log Out',
                                          style: GoogleFonts.poppins(
                                            color: isColorValidation(context),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.triangleExclamation,
                      color: Color(0xFFEF4444),
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Oops! Something went wrong',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[900],
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.errorMessage,
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      BlocProvider.of<ProfileBloc>(context)
                          .add(GetProfileData());
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          } else {
            debugPrint("=> No user data available.");
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.userSlash,
                      color: Color(0xFF9CA3AF),
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No user data available',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[900],
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subTitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const SettingTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
    this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkSurface
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColor.darkBorderColor
              : AppColor.borderColor,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor, size: 20),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            if (subTitle != null) SizedBox(height: 0),
            if (subTitle != null)
              Text(
                subTitle!,
                style: GoogleFonts.poppins(
                    fontSize: 12, fontWeight: FontWeight.w300),
              ),
          ],
        ),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
