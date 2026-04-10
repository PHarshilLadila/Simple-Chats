// // ignore_for_file: deprecated_member_use

// import 'package:chat_app_bloc/App%20Functionality/Search%20User/widgets/searched_user_list.dart';
// import 'package:chat_app_bloc/Constent/app_color.dart';
// import 'package:chat_app_bloc/App%20Functionality/Search%20User/bloc/searching_user_bloc.dart';
// import 'package:chat_app_bloc/App%20Functionality/Search%20User/bloc/searching_user_event.dart';
// import 'package:chat_app_bloc/App%20Functionality/Search%20User/bloc/searching_user_state.dart';
// import 'package:chat_app_bloc/Constent/app_font_style.dart';
// import 'package:chat_app_bloc/Service/analytics_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shimmer/shimmer.dart';

// class SearchingUserScreen extends StatefulWidget {
//   const SearchingUserScreen({super.key});

//   @override
//   State<SearchingUserScreen> createState() => _SearchingUserScreenState();
// }

// class _SearchingUserScreenState extends State<SearchingUserScreen>
//     with SingleTickerProviderStateMixin {
//   final TextEditingController searchController = TextEditingController();
//   late SearchingUserBloc searchingUserBloc;
//   final AnalyticsService services = AnalyticsService();
//   bool isSelected = true;
//   late AnimationController _animationController;

//   void toggleSwitch(bool value) {
//     setState(() {
//       isSelected = value;
//       services.logSearchBarToggle(isSelected.toString());
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     searchingUserBloc = SearchingUserBloc(FirebaseFirestore.instance);
//     searchingUserBloc.add(LoadAllUsers());
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );
//     searchController.addListener(() {
//       final query = searchController.text.trim();
//       if (query.isEmpty) {
//         searchingUserBloc.add(LoadAllUsers());
//       }
//     });
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     searchingUserBloc.close();
//     _animationController.dispose();
//     super.dispose();
//   }

//   Widget _buildAnimatedUserList(List users) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       itemCount: users.length,
//       itemBuilder: (context, index) {
//         final searchedUser = users[index];
//         return FadeTransition(
//           opacity: CurvedAnimation(
//             parent: _animationController,
//             curve: Interval(
//               (1 / users.length) * index,
//               1.0,
//               curve: Curves.easeOut,
//             ),
//           ),
//           child: SlideTransition(
//             position: Tween<Offset>(
//               begin: const Offset(1, 0),
//               end: Offset.zero,
//             ).animate(
//               CurvedAnimation(
//                 parent: _animationController,
//                 curve: Interval(
//                   (1 / users.length) * index,
//                   1.0,
//                   curve: Curves.easeOut,
//                 ),
//               ),
//             ),
//             child: SearchedUserList(searchedUser: searchedUser),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildShimmerList() {
//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       itemCount: 6,
//       itemBuilder: (context, index) => Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//         child: Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               color: Colors.white,
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         width: 45,
//                         height: 45,
//                         decoration: const BoxDecoration(
//                           color: Colors.white,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: 120,
//                               height: 16,
//                               color: Colors.white,
//                             ),
//                             const SizedBox(height: 8),
//                             Container(
//                               width: 80,
//                               height: 12,
//                               color: Colors.white,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Container(
//                     width: double.infinity,
//                     height: 1,
//                     color: Colors.white,
//                   ),
//                   const SizedBox(height: 12),
//                   Container(
//                     width: 200,
//                     height: 14,
//                     color: Colors.white,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => searchingUserBloc,
//       child: Scaffold(
//         backgroundColor: AppColor.backgroundColor,
//         appBar: AppBar(
//           toolbarHeight: 70,
//           backgroundColor: AppColor.mainColor,
//           elevation: 0,
//           title: Row(
//             children: [
//               Container(
//                 width: 45,
//                 height: 45,
//                 decoration: BoxDecoration(
//                   color: AppColor.whiteColor,
//                   shape: BoxShape.rectangle,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(2.0),
//                   child: Image.asset(
//                     "assets/images/splash.png",
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               AppText(
//                 text: "Simple Chats",
//                 color: AppColor.blackColor,
//                 fontWeight: FontWeight.bold,
//                 size: 24,
//                 wordSpacing: 0,
//               ),
//             ],
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16.0),
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.1),
//                           blurRadius: 12,
//                           spreadRadius: 2,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 4),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: TextField(
//                               controller: searchController,
//                               enabled: isSelected,
//                               style: GoogleFonts.poppins(
//                                 fontSize: 14,
//                                 color: isSelected
//                                     ? Colors.black87
//                                     : Colors.grey[500],
//                               ),
//                               decoration: InputDecoration(
//                                 hintText: isSelected
//                                     ? "Search by name, email, or phone"
//                                     : "🔍 Search is disabled",
//                                 hintStyle: GoogleFonts.poppins(
//                                   color: isSelected
//                                       ? Colors.grey[600]
//                                       : Colors.grey[400],
//                                   fontSize: 14,
//                                   fontStyle: isSelected
//                                       ? FontStyle.normal
//                                       : FontStyle.italic,
//                                 ),
//                                 border: InputBorder.none,
//                                 prefixIcon: Icon(
//                                   Icons.search,
//                                   color: isSelected
//                                       ? AppColor.mainColor
//                                       : Colors.grey[400],
//                                   size: 20,
//                                 ),
//                                 prefixIconConstraints: const BoxConstraints(
//                                   minWidth: 40,
//                                   minHeight: 24,
//                                 ),
//                                 contentPadding: const EdgeInsets.symmetric(
//                                   vertical: 12,
//                                 ),
//                               ),
//                               onSubmitted: (query) {
//                                 if (isSelected && query.trim().isNotEmpty) {
//                                   searchingUserBloc
//                                       .add(SearchingUsers(query.trim()));
//                                   services.logSearchEvent(query.trim());
//                                 }
//                               },
//                             ),
//                           ),
//                           Container(
//                             margin: const EdgeInsets.only(left: 4),
//                             decoration: BoxDecoration(
//                               color: isSelected
//                                   ? AppColor.mainColor.withOpacity(0.1)
//                                   : Colors.grey[200],
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             child: Transform.scale(
//                               scale: 0.7,
//                               child: CupertinoSwitch(
//                                 value: isSelected,
//                                 onChanged: toggleSwitch,
//                                 activeColor: AppColor.mainColor,
//                                 trackColor: Colors.grey[300],
//                                 thumbColor: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 if (isSelected)
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(left: 16, right: 16, top: 12),
//                     child: Row(
//                       children: [
//                         FaIcon(
//                           FontAwesomeIcons.circleInfo,
//                           size: 14,
//                           color: Colors.grey[500],
//                         ),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             "Search by name, mobile number or email address",
//                             style: GoogleFonts.poppins(
//                               fontSize: 12,
//                               color: Colors.grey[600],
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 const SizedBox(height: 4),
//                 BlocConsumer<SearchingUserBloc, SearchingUserState>(
//                   listener: (context, state) {
//                     if (state is SearchingUserLoaded &&
//                         state.users.isNotEmpty) {
//                       _animationController.forward(from: 0);
//                     }
//                   },
//                   builder: (context, state) {
//                     if (state is SearchingUserLoading) {
//                       return _buildShimmerList();
//                     } else if (state is SearchingUserLoaded) {
//                       if (state.users.isEmpty) {
//                         return Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(20),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey[200],
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: FaIcon(
//                                   FontAwesomeIcons.userSlash,
//                                   size: 40,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                               const SizedBox(height: 16),
//                               Text(
//                                 "No User Found",
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 18,
//                                   color: Colors.grey[800],
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 "Try searching with a different keyword",
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 14,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       }
//                       return _buildAnimatedUserList(state.users);
//                     } else if (state is SearchingUserError) {
//                       return Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(20),
//                               decoration: BoxDecoration(
//                                 color: Colors.red[50],
//                                 shape: BoxShape.circle,
//                               ),
//                               child: FaIcon(
//                                 FontAwesomeIcons.triangleExclamation,
//                                 size: 40,
//                                 color: Colors.red[400],
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             Text(
//                               "Error",
//                               style: GoogleFonts.poppins(
//                                 fontSize: 18,
//                                 color: Colors.red[800],
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               state.message,
//                               style: GoogleFonts.poppins(
//                                 fontSize: 14,
//                                 color: Colors.grey[600],
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//                     return const SizedBox.shrink();
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

import 'package:chat_app_bloc/functionality/home/widgets/searched_user_list.dart';
import 'package:chat_app_bloc/functionality/home/bloc/searching_user_bloc.dart';
import 'package:chat_app_bloc/functionality/home/bloc/searching_user_event.dart';
import 'package:chat_app_bloc/functionality/home/bloc/searching_user_state.dart';
import 'package:chat_app_bloc/service/analytics_service.dart';
import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:chat_app_bloc/utils/constent/app_font_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
    with TickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  late SearchingUserBloc searchingUserBloc;
  final AnalyticsService services = AnalyticsService();
  bool isSelected = true;
  late AnimationController _animationController;
  List<AnimationController> _itemControllers = [];

  void toggleSwitch(bool value) {
    setState(() {
      isSelected = value;
      services.logSearchBarToggle(isSelected.toString());
    });
  }

  void _disposeItemControllers() {
    for (var controller in _itemControllers) {
      controller.dispose();
    }
    _itemControllers.clear();
  }

  @override
  void initState() {
    super.initState();
    searchingUserBloc = SearchingUserBloc(FirebaseFirestore.instance);
    searchingUserBloc.add(LoadAllUsers());
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
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
    _disposeItemControllers();
    super.dispose();
  }

  Widget _buildAnimatedUserList(List users) {
    // Dispose old controllers
    _disposeItemControllers();

    // Create new controllers for each item
    _itemControllers = List.generate(users.length, (index) {
      return AnimationController(
        vsync: this,
        duration:
            Duration(milliseconds: 400 + (index * 50)), // Staggered duration
      );
    });

    // Start animations with delay
    for (int i = 0; i < _itemControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 80), () {
        if (mounted) {
          _itemControllers[i].forward();
        }
      });
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final searchedUser = users[index];
        return AnimatedBuilder(
          animation: _itemControllers[index],
          builder: (context, child) {
            return FadeTransition(
              opacity: Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(
                CurvedAnimation(
                  parent: _itemControllers[index],
                  curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
                ),
              ),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.5, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _itemControllers[index],
                    curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
                  ),
                ),
                child: child,
              ),
            );
          },
          child: SearchedUserList(searchedUser: searchedUser),
        );
      },
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 6,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          period: const Duration(milliseconds: 1200),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 120,
                              height: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 80,
                              height: 12,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 200,
                    height: 14,
                    color: Colors.white,
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
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage("assets/images/splash.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                // child: Padding(
                //   padding: const EdgeInsets.all(2.0),
                //   child: Image.asset(
                //     "assets/images/splash.png",
                //   ),
                // ),
              ),
              const SizedBox(width: 10),
              AppText(
                text: "Simple Chats",
                color: isColorValidation(context),
                // colorValidation == false
                //     ? AppColor.whiteColor
                //     : AppColor.blackColor,
                fontWeight: FontWeight.bold,
                size: 24,
                wordSpacing: 0,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 12,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              enabled: isSelected,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: isSelected
                                    ? Colors.black87
                                    : Colors.grey[500],
                              ),
                              decoration: InputDecoration(
                                hintText: isSelected
                                    ? "Search by name, email, or phone"
                                    : "Search is disabled",
                                hintStyle: GoogleFonts.poppins(
                                  color: isSelected
                                      ? Colors.grey[600]
                                      : Colors.grey[400],
                                  fontSize: 14,
                                  fontStyle: isSelected
                                      ? FontStyle.normal
                                      : FontStyle.italic,
                                ),
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: isSelected
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[400],
                                  size: 20,
                                ),
                                prefixIconConstraints: const BoxConstraints(
                                  minWidth: 40,
                                  minHeight: 24,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              onSubmitted: (query) {
                                if (isSelected && query.trim().isNotEmpty) {
                                  searchingUserBloc
                                      .add(SearchingUsers(query.trim()));
                                  services.logSearchEvent(query.trim());
                                }
                              },
                            ),
                          ),
                          Transform.scale(
                            scale: 0.7,
                            child: CupertinoSwitch(
                              value: isSelected,
                              onChanged: toggleSwitch,
                              activeColor: Theme.of(context).primaryColor,
                              trackColor: Colors.grey[300],
                              thumbColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isSelected)
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 12),
                    child: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.circleInfo,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Search by name, mobile number or email address",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 4),
                BlocConsumer<SearchingUserBloc, SearchingUserState>(
                  listener: (context, state) {
                    if (state is SearchingUserLoaded &&
                        state.users.isNotEmpty) {
                      _animationController.forward(from: 0);
                    }
                  },
                  builder: (context, state) {
                    if (state is SearchingUserLoading) {
                      return _buildShimmerList();
                    } else if (state is SearchingUserLoaded) {
                      if (state.users.isEmpty) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    shape: BoxShape.circle,
                                  ),
                                  child: FaIcon(
                                    FontAwesomeIcons.userSlash,
                                    size: 40,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "No User Found",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Try searching with a different keyword",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return _buildAnimatedUserList(state.users);
                    } else if (state is SearchingUserError) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  shape: BoxShape.circle,
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.triangleExclamation,
                                  size: 40,
                                  color: Colors.red[400],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Error",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.red[800],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                state.message,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
