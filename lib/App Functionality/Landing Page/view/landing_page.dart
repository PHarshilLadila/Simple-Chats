import 'package:chat_app_bloc/App%20Functionality/Contacts/view/contect_screen.dart';
import 'package:chat_app_bloc/App%20Functionality/Landing%20Page/bloc/landing_page_bloc.dart';
import 'package:chat_app_bloc/App%20Functionality/Landing%20Page/bloc/landing_page_event.dart';
import 'package:chat_app_bloc/App%20Functionality/Landing%20Page/bloc/landing_page_state.dart';
import 'package:chat_app_bloc/App%20Functionality/Notification/view/notification_screen.dart';
import 'package:chat_app_bloc/App%20Functionality/Profile/view/profile_screen.dart';
import 'package:chat_app_bloc/Constent/app_color.dart';
import 'package:chat_app_bloc/App%20Functionality/Search%20User/view/searching_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<BottomNavigationBarItem> bottomNavItems = <BottomNavigationBarItem>[
  BottomNavigationBarItem(
    backgroundColor: AppColor.backgroundColor,
    icon: const FaIcon(FontAwesomeIcons.comments),
    label: 'Messages',
  ),
  BottomNavigationBarItem(
    backgroundColor: AppColor.backgroundColor,
    // ignore: deprecated_member_use
    icon: const FaIcon(FontAwesomeIcons.addressBook),
    label: 'Contact',
  ),
  BottomNavigationBarItem(
    backgroundColor: AppColor.backgroundColor,
    icon: const FaIcon(FontAwesomeIcons.bell),
    label: 'Notification',
  ),
  BottomNavigationBarItem(
    backgroundColor: AppColor.backgroundColor,
    icon: const FaIcon(FontAwesomeIcons.circleUser),
    label: 'Profile',
  ),
];

List<Widget> bottomNavScreen = <Widget>[
  // Text('Index 0: Home'),

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
            body: Center(
              child: bottomNavScreen.elementAt(state.tabIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 20,
              items: bottomNavItems,
              currentIndex: state.tabIndex,
              backgroundColor: AppColor.backgroundColor,
              selectedItemColor: AppColor.mainColor,
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
