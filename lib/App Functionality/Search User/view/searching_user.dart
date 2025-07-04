// ignore_for_file: deprecated_member_use

import 'package:chat_app_bloc/App%20Functionality/Search%20User/widgets/searched_user_list.dart';
import 'package:chat_app_bloc/Constent/app_color.dart';
import 'package:chat_app_bloc/App%20Functionality/Search%20User/bloc/searching_user_bloc.dart';
import 'package:chat_app_bloc/App%20Functionality/Search%20User/bloc/searching_user_event.dart';
import 'package:chat_app_bloc/App%20Functionality/Search%20User/bloc/searching_user_state.dart';
import 'package:chat_app_bloc/Service/analytics_service.dart';
import 'package:chat_app_bloc/socketandbloc/socket_message_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class SearchingUserScreen extends StatefulWidget {
  const SearchingUserScreen({super.key});

  @override
  State<SearchingUserScreen> createState() => _SearchingUserScreenState();
}

class _SearchingUserScreenState extends State<SearchingUserScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  late SearchingUserBloc searchingUserBloc;
  final AnalyticsService services = AnalyticsService();
  bool isSelected = true;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late AnimationController _animationController;

  void toggleSwitch(bool value) {
    setState(() {
      isSelected = value;
      services.logSearchBarToggle(isSelected.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    searchingUserBloc = SearchingUserBloc(FirebaseFirestore.instance);
    searchingUserBloc.add(LoadAllUsers());
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    searchController.addListener(() {
      final query = searchController.text.trim();
      if (query.isEmpty) {
        searchingUserBloc.add(LoadAllUsers());
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchingUserBloc.close();
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedUserList(List users) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: users.length,
      itemBuilder: (context, index, animation) {
        final searchedUser = users[index];
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(
                (1 / users.length) * index,
                1.0,
                curve: Curves.easeOut,
              ),
            ),
          ),
          child: FadeTransition(
            opacity: animation,
            child: SearchedUserList(searchedUser: searchedUser),
          ),
        );
      },
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
        child:
            // Shimmer.fromColors(
            //   baseColor: Colors.grey[300]!,
            //   highlightColor: Colors.grey[100]!,
            //   child: Container(
            //     width: double.infinity,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(12),
            //       color: AppColor.whiteColor,
            //     ),
            //     child: Padding(
            //       padding: const EdgeInsets.all(15),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Row(
            //             children: [
            //               Container(
            //                 width: 40,
            //                 height: 40,
            //                 decoration: BoxDecoration(
            //                   color: Colors.grey[300],
            //                   shape: BoxShape.circle,
            //                 ),
            //               ),
            //               const SizedBox(width: 10),
            //               Container(
            //                 width: 100,
            //                 height: 18,
            //                 color: Colors.grey[300],
            //               ),
            //             ],
            //           ),
            //           const SizedBox(height: 10),
            //           Container(
            //             width: 60,
            //             height: 12,
            //             color: Colors.grey[300],
            //           ),
            //           const SizedBox(height: 8),
            //           Container(
            //             width: 180,
            //             height: 14,
            //             color: Colors.grey[300],
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColor.whiteColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 100,
                        height: 18,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 60,
                    height: 12,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 180,
                    height: 14,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => searchingUserBloc,
      child: Scaffold(
        backgroundColor: AppColor.backgroundColor,
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: AppColor.mainColor,
          elevation: 0,
          title: Row(
            children: [
              const FaIcon(FontAwesomeIcons.userGroup,
                  color: Colors.white, size: 26),
              const SizedBox(width: 10),
              Text(
                "Simple Chat",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.solidMessage,
                  color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SocketMessagePage(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.mainColor.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: TextFormField(
                          controller: searchController,
                          enabled: isSelected,
                          readOnly: !isSelected,
                          style: GoogleFonts.poppins(fontSize: 16),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 0),
                            hintText: isSelected
                                ? "Search by name, email, or phone"
                                : "Search is disabled",
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontSize: 15,
                            ),
                            border: InputBorder.none,
                            prefixIcon:
                                const Icon(Icons.search, color: Colors.grey),
                          ),
                          onFieldSubmitted: (query) {
                            if (isSelected && query.trim().isNotEmpty) {
                              searchingUserBloc
                                  .add(SearchingUsers(query.trim()));
                              services.logSearchEvent(query.trim());
                            }
                          },
                        ),
                      ),
                    ),
                    Switch(
                      thumbIcon: const WidgetStatePropertyAll(
                        Icon(Icons.search),
                      ),
                      inactiveThumbColor: AppColor.whiteColor,
                      inactiveTrackColor: Colors.grey,
                      activeTrackColor: AppColor.mainColor,
                      activeColor: AppColor.whiteColor,
                      trackOutlineColor:
                          const WidgetStatePropertyAll(Colors.white),
                      value: isSelected,
                      onChanged: toggleSwitch,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.circleInfo,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Search Contact with Name, Mobile Number or Email Address",
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              Expanded(
                child: BlocConsumer<SearchingUserBloc, SearchingUserState>(
                  listener: (context, state) {
                    if (state is SearchingUserLoaded) {
                      _animationController.forward(from: 0);
                    }
                  },
                  builder: (context, state) {
                    if (state is SearchingUserLoading) {
                      return _buildShimmerList();
                    } else if (state is SearchingUserLoaded) {
                      if (state.users.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/nouser.png", width: 120),
                            const SizedBox(height: 10),
                            Text(
                              "No User Found!",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      }
                      return _buildAnimatedUserList(state.users);
                    } else if (state is SearchingUserError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/nouser.png", width: 120),
                            const SizedBox(height: 10),
                            Text(
                              state.message,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
