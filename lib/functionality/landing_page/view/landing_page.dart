// import 'package:chat_app_bloc/App%20Functionality/Contacts/view/contect_screen.dart';
// import 'package:chat_app_bloc/App%20Functionality/Landing%20Page/bloc/landing_page_bloc.dart';
// import 'package:chat_app_bloc/App%20Functionality/Landing%20Page/bloc/landing_page_event.dart';
// import 'package:chat_app_bloc/App%20Functionality/Landing%20Page/bloc/landing_page_state.dart';
// import 'package:chat_app_bloc/App%20Functionality/Notification/view/notification_screen.dart';
// import 'package:chat_app_bloc/App%20Functionality/Profile/view/profile_screen.dart';
// import 'package:chat_app_bloc/Constent/app_color.dart';
// import 'package:chat_app_bloc/App%20Functionality/Search%20User/view/searching_user.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// List<BottomNavigationBarItem> bottomNavItems = <BottomNavigationBarItem>[
//   BottomNavigationBarItem(
//     backgroundColor: AppColor.backgroundColor,
//     icon: const FaIcon(FontAwesomeIcons.solidCommentDots),
//     label: 'Messages',
//   ),
//   BottomNavigationBarItem(
//     backgroundColor: AppColor.backgroundColor,
//     // ignore: deprecated_member_use
//     icon: const FaIcon(FontAwesomeIcons.solidAddressBook),
//     label: 'Contact',
//   ),
//   BottomNavigationBarItem(
//     backgroundColor: AppColor.backgroundColor,
//     icon: const FaIcon(FontAwesomeIcons.solidBell),
//     label: 'Notification',
//   ),
//   BottomNavigationBarItem(
//     backgroundColor: AppColor.backgroundColor,
//     icon: const FaIcon(FontAwesomeIcons.solidUser),
//     label: 'Profile',
//   ),
// ];

// List<Widget> bottomNavScreen = <Widget>[
//   // Text('Index 0: Home'),

//   const SearchingUserScreen(),
//   const ContactsScreen(),
//   const NotificationScreen(),
//   const ProfileScreen(),
// ];

// class LandingPage extends StatelessWidget {
//   final int startingIndex;

//   const LandingPage({super.key, this.startingIndex = 0});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) =>
//           LandingPageBloc()..add(TabChange(tabIndex: startingIndex)),
//       child: BlocConsumer<LandingPageBloc, LandingPageState>(
//         listener: (context, state) {},
//         builder: (context, state) {
//           return Scaffold(
//             body: Center(
//               child: bottomNavScreen.elementAt(state.tabIndex),
//             ),
//             bottomNavigationBar: BottomNavigationBar(
//               elevation: 20,
//               items: bottomNavItems,
//               currentIndex: state.tabIndex,
//               backgroundColor: AppColor.backgroundColor,
//               selectedItemColor: AppColor.mainColor,
//               unselectedItemColor: Colors.grey.shade400,
//               onTap: (index) {
//                 BlocProvider.of<LandingPageBloc>(context)
//                     .add(TabChange(tabIndex: index));
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:chat_app_bloc/functionality/Contacts/view/contect_screen.dart';
import 'package:chat_app_bloc/functionality/landing_page/bloc/landing_page_bloc.dart';
import 'package:chat_app_bloc/functionality/landing_page/bloc/landing_page_event.dart';
import 'package:chat_app_bloc/functionality/landing_page/bloc/landing_page_state.dart';
import 'package:chat_app_bloc/functionality/notification/view/notification_screen.dart';
import 'package:chat_app_bloc/functionality/profile/view/profile_screen.dart';
import 'package:chat_app_bloc/functionality/home/view/searching_user.dart';
import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<BottomNavigationBarItem> bottomNavItems = <BottomNavigationBarItem>[
  BottomNavigationBarItem(
    backgroundColor: AppColor.backgroundColor,
    icon: Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        FaIcon(FontAwesomeIcons.commentDots),
        SizedBox(height: 4), // 👈 space
      ],
    ),
    activeIcon: Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        FaIcon(FontAwesomeIcons.solidCommentDots),
        SizedBox(height: 4), // 👈 space
      ],
    ),
    label: 'Messages',
  ),
  BottomNavigationBarItem(
    backgroundColor: AppColor.backgroundColor,
    icon: Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        FaIcon(FontAwesomeIcons.addressBook),
        SizedBox(height: 4),
      ],
    ),
    activeIcon: Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        FaIcon(FontAwesomeIcons.solidAddressBook),
        SizedBox(height: 4),
      ],
    ),
    label: 'Contact',
  ),
  BottomNavigationBarItem(
    backgroundColor: AppColor.backgroundColor,
    icon: Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        FaIcon(FontAwesomeIcons.bell),
        SizedBox(height: 4),
      ],
    ),
    activeIcon: Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        FaIcon(FontAwesomeIcons.solidBell),
        SizedBox(height: 4),
      ],
    ),
    label: 'Notification',
  ),
  BottomNavigationBarItem(
    backgroundColor: AppColor.backgroundColor,
    icon: Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        FaIcon(FontAwesomeIcons.user),
        SizedBox(height: 4),
      ],
    ),
    activeIcon: Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        FaIcon(FontAwesomeIcons.solidUser),
        SizedBox(height: 4),
      ],
    ),
    label: 'Profile',
  ),
];

List<Widget> bottomNavScreen = <Widget>[
  const SearchingUserScreen(),
  const ContactsScreen(),
  const NotificationScreen(),
  const ProfileScreen(),
];

class LandingPage extends StatelessWidget {
  final int startingIndex;

  const LandingPage({super.key, this.startingIndex = 0});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LandingPageBloc()..add(TabChange(tabIndex: startingIndex)),
      child: BlocConsumer<LandingPageBloc, LandingPageState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColor.backgroundColor,
            body: Center(
              child: bottomNavScreen.elementAt(state.tabIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 20,
              type: BottomNavigationBarType.shifting,
              items: bottomNavItems,
              currentIndex: state.tabIndex,
              backgroundColor: AppColor.backgroundColor,
              selectedItemColor: Theme.of(context).primaryColor,
              selectedLabelStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColor.blackColor,
              ),
              unselectedItemColor: Colors.grey.shade400,
              onTap: (index) {
                BlocProvider.of<LandingPageBloc>(context)
                    .add(TabChange(tabIndex: index));
              },
            ),
          );
        },
      ),
    );
  }
}
