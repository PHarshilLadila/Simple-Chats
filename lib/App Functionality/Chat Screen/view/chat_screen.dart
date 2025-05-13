// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:chat_app_bloc/App%20Functionality/Chat%20Screen/bloc/chat_screen_bloc.dart';
import 'package:chat_app_bloc/App%20Functionality/Chat%20Screen/bloc/chat_screen_events.dart';
import 'package:chat_app_bloc/App%20Functionality/Chat%20Screen/bloc/chat_screen_state.dart';
import 'package:chat_app_bloc/App%20Functionality/Chat%20Screen/view/all_images.dart';
import 'package:chat_app_bloc/App%20Functionality/Chat%20Screen/view/image_view.dart';
import 'package:chat_app_bloc/App%20Functionality/Chat%20Screen/view/searched_user_details.dart';
import 'package:chat_app_bloc/Constent/app_appbar.dart';
import 'package:chat_app_bloc/Constent/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String? chatId;
  final String? currentUserName;
  final String? senderName;
  final String? receiverName;
  final String? senderUid;
  final String? receiverUid;
  final String? useremail;
  final String? mobileNumber;
  final String? receiverFCM;
  final String? profileImage;

  const ChatScreen(
      {super.key,
      this.chatId,
      this.currentUserName,
      this.senderName,
      this.receiverName,
      this.senderUid,
      this.receiverUid,
      this.useremail,
      this.mobileNumber,
      this.receiverFCM,
      this.profileImage});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

final TextEditingController messageController = TextEditingController();
final ImagePicker picker = ImagePicker();
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final ScrollController _scrollController = ScrollController();

late final File cameraFile;

void _showModal(BuildContext context) {
  showModalBottomSheet<void>(
    sheetAnimationStyle: AnimationStyle(
      curve: const Interval(5, 55),
      duration: const Duration(
        milliseconds: 500,
      ),
    ),
    backgroundColor: AppColor.backgroundColor,
    isDismissible: true,
    showDragHandle: true,
    enableDrag: true,
    elevation: 50,
    context: context,
    builder: (_) {
      return SizedBox(
        height: 150,
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
                        final List<XFile> pickedFiles =
                            await picker.pickMultiImage(imageQuality: 5);
                        if (pickedFiles.isNotEmpty) {
                          List<String> base64Images = [];
                          for (XFile pickedFile in pickedFiles) {
                            File imageFile = File(pickedFile.path);
                            List<int> imageBytes =
                                await imageFile.readAsBytes();
                            String base64Image = base64Encode(imageBytes);
                            base64Images.add(base64Image);
                          }
                          Navigator.pop(context);
                          context
                              .read<ChatScreenBloc>()
                              .add(OnSendImage(base64Images));
                        }
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
                        // ignore: unused_local_variable
                        final XFile? pickedFiles = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 5);
                        List<String> base64Images = [];
                        if (pickedFiles != null) {
                          File imageFile = File(pickedFiles.path);
                          List<int> imageBytes = await imageFile.readAsBytes();

                          String base64Image = base64Encode(imageBytes);
                          base64Images.add(base64Image);

                          context
                              .read<ChatScreenBloc>()
                              .add(OnSendImage(base64Images));
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
                        FontAwesomeIcons.solidFile,
                        color: Colors.white,
                        size: 22,
                      ),
                      onPressed: () async {
                        ScaffoldMessenger(
                          child: SnackBar(
                            margin: const EdgeInsets.all(15),
                            behavior: SnackBarBehavior.floating,
                            elevation: 50.0,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            backgroundColor: AppColor.mainColor,
                            content: const Text(
                              'Send Documents.',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Text(
                    "Files",
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

class _ChatScreenState extends State<ChatScreen> {
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => ChatScreenBloc(
        widget.chatId!,
        widget.currentUserName!,
        widget.senderName!,
        widget.receiverName!,
        widget.senderUid!,
        widget.receiverUid!,
        widget.receiverFCM!,
      )
        ..add(Loadmessages())
        ..add(StartListeningMessages()),
      child: Scaffold(
        backgroundColor: AppColor.backgroundColor,
        appBar: CustomeAppBar(
          automaticallyImplyLeadings: false,
          titleWidget: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchedUserDetails(
                    userMobile: widget.mobileNumber,
                    userProfile: widget.profileImage,
                    username: widget.receiverName,
                    userEmail: widget.useremail,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                ClipOval(
                  child: Image.memory(
                    height: 40,
                    width: 40,
                    base64Decode(widget.profileImage!),
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.receiverName!,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.mobileNumber!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white)),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.arrowLeft,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          actions: [
            PopupMenuButton(
              color: AppColor.backgroundColor,
              menuPadding: const EdgeInsets.all(4),
              itemBuilder: (context) => <PopupMenuItem<int>>[
                PopupMenuItem(
                  onTap: () {
                    context.read<ChatScreenBloc>().add(ClearMessages());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        margin: const EdgeInsets.all(15),
                        behavior: SnackBarBehavior.floating,
                        elevation: 50.0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        backgroundColor: AppColor.mainColor,
                        content: const Text(
                          "Your Chat And Media Clear Successfully",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Clear Chat",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        showCloseIcon: true,
                        margin: const EdgeInsets.all(15),
                        behavior: SnackBarBehavior.floating,
                        elevation: 50.0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        backgroundColor: AppColor.mainColor,
                        content: const Text(
                          "Opening Setting..!",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Setting",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllImages(
                          chatId: widget.chatId!,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "All Images",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: BlocConsumer<ChatScreenBloc, ChatScreenState>(
          buildWhen: (previous, current) {
            return previous is Loadmessages ==
                current is StartListeningMessages;
          },
          listener: (context, state) {
            debugPrint("=> BlocConsumer is called");
            if (state is ChatScreenLoaded || state is ChatScreenLoading) {
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _scrollToBottom());
            }
          },
          builder: (context, state) {
            if (state is ChatScreenLoaded) {
              debugPrint("=> ChatScreenLoaded is called");
              return Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      "assets/images/background.jpg",
                    ),
                  ),
                ),
                child: ShowMessagesRealTime(
                  widget: widget,
                  size: size,
                ),
              );
            } else if (state is ChatScreenLoading) {
              debugPrint("=> ChatScreenLoading is called");
              return Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      "assets/images/background.jpg",
                    ),
                  ),
                ),
                child: ShowMessagesRealTime(
                  widget: widget,
                  size: size,
                ),
              );
            }
            return const Center(
              child: Text(
                "Messages Not Loaded..!",
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
    );
  }
}

class ShowMessagesRealTime extends StatelessWidget {
  const ShowMessagesRealTime({
    super.key,
    required this.widget,
    required this.size,
  });

  final ChatScreen widget;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: firestore
                .collection('chatroom')
                .doc(widget.chatId!)
                .collection("chats")
                .orderBy("time", descending: false)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapShot.hasData || snapShot.data!.docs.isEmpty) {
                return Center(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.white,
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                      child: Text(
                        textAlign: TextAlign.center,
                        "No messages yet, Enjoy your conversation now.!",
                      ),
                    ),
                  ),
                );
              }
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                  _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent);
                }
              });

              return ListView.builder(
                controller: _scrollController,
                itemCount: snapShot.data!.docs.length,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) {
                  Map<String, dynamic> messages =
                      snapShot.data!.docs[index].data() as Map<String, dynamic>;
                  final isCurrentUser =
                      messages['sendby'] == widget.currentUserName;
                  final timestamp = (messages['time'] is Timestamp)
                      ? messages['time'] as Timestamp
                      : Timestamp.now();
                  final DateTime dateTime = timestamp.toDate();
                  final String formattedTime =
                      DateFormat('hh:mm a').format(dateTime);

                  if (messages["isImage"] == true) {
                    List<String> images = List<String>.from(
                      messages['message'],
                    );
                    return ImageMessage(
                        images: images,
                        isCurrentUser: isCurrentUser,
                        formattedTime: formattedTime);
                  } else {
                    return MessageData(
                        isCurrentUser: isCurrentUser,
                        message: messages,
                        formattedTime: formattedTime);
                  }
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: messageController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white38,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: AppColor.mainColor),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: AppColor.mainColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: AppColor.mainColor,
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _showModal(context);
                      },
                      icon: FaIcon(
                        FontAwesomeIcons.paperclip,
                        color: AppColor.mainColor,
                      ),
                    ),
                    hintText: "Send Message",
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Container(
                alignment: Alignment.center,
                height: size.height / 12,
                width: size.width / 8,
                decoration: BoxDecoration(
                  color: AppColor.mainColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: IconButton(
                    onPressed: () {
                      final messageText = messageController.text.trim();
                      if (messageText.isNotEmpty) {
                        context
                            .read<ChatScreenBloc>()
                            .add(OnSendMessage(messageText));
                        debugPrint("message sent is :~ $messageText");
                        debugPrint(
                            "message sent  :~ ${widget.currentUserName}");

                        context
                            .read<ChatScreenBloc>()
                            .add(StartListeningMessages());
                        messageController.clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Enter message to send."),
                          ),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ImageMessage extends StatelessWidget {
  const ImageMessage({
    super.key,
    required this.images,
    required this.isCurrentUser,
    required this.formattedTime,
  });

  final List<String> images;
  final bool isCurrentUser;
  final String formattedTime;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageView(imageUrl: images[0]),
          ),
        );
      },
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: images.map(
          (base64Image) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: isCurrentUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color:
                        isCurrentUser ? AppColor.mainColor : Colors.grey[350],
                  ),
                  child: Column(
                    crossAxisAlignment: isCurrentUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.memory(
                            base64Decode(base64Image),
                            height: 300,
                            width: 250,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          formattedTime,
                          style: TextStyle(
                            fontSize: 10,
                            color: isCurrentUser ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}

class MessageData extends StatelessWidget {
  const MessageData({
    super.key,
    required this.isCurrentUser,
    required this.message,
    required this.formattedTime,
  });

  final bool isCurrentUser;
  final Map<String, dynamic> message;
  final String formattedTime;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.bottomRight : Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 250),
            margin:
                const EdgeInsets.only(left: 10, right: 10, bottom: 2, top: 6),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isCurrentUser ? AppColor.mainColor : Colors.grey[350],
              borderRadius: isCurrentUser
                  ? const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      topLeft: Radius.circular(15))
                  : const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      topRight: Radius.circular(15)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    message['message'] ?? "N/A",
                    style: TextStyle(
                      color: isCurrentUser ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              formattedTime,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
