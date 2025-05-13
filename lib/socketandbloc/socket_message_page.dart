import 'dart:convert';
import 'dart:typed_data';

import 'package:chat_app_bloc/socketandbloc/socket_chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app_bloc/App Functionality/Search User/bloc/searching_user_bloc.dart';
import 'package:chat_app_bloc/App Functionality/Search User/bloc/searching_user_event.dart';
import 'package:chat_app_bloc/App Functionality/Search User/bloc/searching_user_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

String currentUserId = '';
void getCurrentUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? userid = pref.getString('userId');
  currentUserId = userid ?? '';
}

class SocketMessagePage extends StatefulWidget {
  const SocketMessagePage({super.key});

  @override
  State<SocketMessagePage> createState() => _SocketMessagePageState();
}

class _SocketMessagePageState extends State<SocketMessagePage> {
  late SearchingUserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
    _userBloc = SearchingUserBloc(FirebaseFirestore.instance);
    _userBloc.add(LoadAllUsers());
  }

  @override
  void dispose() {
    _userBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _userBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Socket Message Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<SearchingUserBloc, SearchingUserState>(
            builder: (context, state) {
              if (state is SearchingUserLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SearchingUserLoaded) {
                final users = state.users;

                return Column(
                  children: [
                    Container(
                      height: 100,
                      padding: const EdgeInsets.all(5),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return _buildRecentContacts(context, user.displayName,
                              user.id, user.profileImage);
                        },
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30),
                          ),
                          color: const Color.fromARGB(92, 159, 190, 160),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];
                              return _buildMessageTile(
                                  context,
                                  user.displayName,
                                  user.email,
                                  "10:00 AM",
                                  user.id,
                                  user.profileImage);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is SearchingUserError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRecentContacts(
    BuildContext context,
    String name,
    String receiverId,
    String profile,
  ) {
    Uint8List? bytes;

    try {
      bytes = base64.decode(profile);
    } catch (e) {
      debugPrint("Error decoding profile image: $e");
      bytes = null;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SocketChatPage(
              senderId: currentUserId,
              receiverId: receiverId,
              receiverName: name,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: bytes != null
                  ? MemoryImage(bytes)
                  : const AssetImage("assets/images/default_profile.png")
                      as ImageProvider,
              backgroundColor: Colors.blue,
            ),
            const SizedBox(height: 5),
            Text(
              name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMessageTile(
    BuildContext context,
    String name,
    String message,
    String time,
    String receiverId,
    String profile,
  ) {
    Uint8List? bytes;

    try {
      bytes = base64.decode(profile);
    } catch (e) {
      debugPrint("Error decoding profile image: $e");
      bytes = null;
    }

    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: bytes != null
            ? MemoryImage(bytes)
            : const AssetImage("assets/images/default_profile.png")
                as ImageProvider,
        backgroundColor: Colors.blue,
      ),
      title: Text(name),
      subtitle: Text(message),
      trailing: Text(time),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SocketChatPage(
            senderId: currentUserId,
            receiverId: receiverId,
            receiverName: name,
          ),
        ),
      ),
    );
  }
}
