import 'package:chat_app_bloc/App%20Functionality/Search%20User/widgets/searched_user_list.dart';
import 'package:chat_app_bloc/Constent/app_color.dart';
import 'package:chat_app_bloc/App%20Functionality/Search%20User/bloc/searching_user_bloc.dart';
import 'package:chat_app_bloc/App%20Functionality/Search%20User/bloc/searching_user_event.dart';
import 'package:chat_app_bloc/App%20Functionality/Search%20User/bloc/searching_user_state.dart';
import 'package:chat_app_bloc/Service/analytics_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchingUserScreen extends StatefulWidget {
  const SearchingUserScreen({super.key});

  @override
  State<SearchingUserScreen> createState() => _SearchingUserScreenState();
}

class _SearchingUserScreenState extends State<SearchingUserScreen> {
  final TextEditingController searchController = TextEditingController();
  late SearchingUserBloc searchingUserBloc;
  bool isSelected = true;
  final AnalyticsService services = AnalyticsService();
  String? istoggletrue;
  void toggleSwitch(bool value) {
    setState(() {
      isSelected = value;
      String toggleState = isSelected.toString();
      services.logSearchBarToggle(toggleState); // Log event with string
    });
  }

  @override
  void initState() {
    super.initState();

    searchingUserBloc = SearchingUserBloc(FirebaseFirestore.instance);
    searchingUserBloc.add(LoadAllUsers());

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
    super.dispose();
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
          centerTitle: false,
          title: Text(
            "Simple Chat",
            style: GoogleFonts.poppins(
                fontSize: 22, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Search User? Using SearchBar",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
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
              const SizedBox(
                height: 15,
              ),
              isSelected
                  ? Column(
                      children: [
                        TextFormField(
                          controller: searchController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: AppColor.mainColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: AppColor.mainColor),
                            ),
                            hintText: "Search by name, email, or phone",
                            suffixIcon: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(15),
                                    topRight: Radius.circular(15)),
                                color: AppColor.mainColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: IconButton(
                                  icon: const FaIcon(
                                      FontAwesomeIcons.magnifyingGlass,
                                      color: Colors.white),
                                  onPressed: () {
                                    final query = searchController.text.trim();
                                    if (query.isNotEmpty) {
                                      searchingUserBloc
                                          .add(SearchingUsers(query));
                                      services.logSearchEvent(query);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.circleInfo,
                              size: 16,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                "Search Contact with Name, Mobile Number or Email Address",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<SearchingUserBloc, SearchingUserState>(
                  builder: (context, state) {
                    if (state is SearchingUserLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SearchingUserLoaded) {
                      if (state.users.isEmpty) {
                        return const Center(child: Text("No User Found!"));
                      }
                      return ListView.builder(
                        itemCount: state.users.length,
                        itemBuilder: (context, index) {
                          final searchedUser = state.users[index];
                          return SearchedUserList(searchedUser: searchedUser);
                        },
                      );
                    } else if (state is SearchingUserError) {
                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/nouser.png", width: 150),
                            Text(state.message),
                          ],
                        ),
                      );
                    }
                    return Container();
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
