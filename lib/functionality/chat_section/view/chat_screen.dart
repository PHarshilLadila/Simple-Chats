// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chat_app_bloc/app_widget/app_appbar.dart';
import 'package:chat_app_bloc/app_widget/app_snackbar.dart';
import 'package:chat_app_bloc/functionality/chat_section/bloc/chat_screen_bloc.dart';
import 'package:chat_app_bloc/functionality/chat_section/bloc/chat_screen_events.dart';
import 'package:chat_app_bloc/functionality/chat_section/bloc/chat_screen_state.dart';
import 'package:chat_app_bloc/functionality/chat_section/helper/call_service.dart';
import 'package:chat_app_bloc/functionality/chat_section/view/all_images.dart';
import 'package:chat_app_bloc/functionality/chat_section/view/image_view.dart';
import 'package:chat_app_bloc/functionality/chat_section/view/searched_user_details.dart';
import 'package:chat_app_bloc/functionality/settings/chat_setting/bloc/chat_setting_bloc.dart';
import 'package:chat_app_bloc/functionality/settings/chat_setting/bloc/chat_setting_state.dart';
import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:chat_app_bloc/utils/constent/app_string.dart';
import 'package:chat_app_bloc/utils/helpers/app_permission_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final String? chatId;
  final String? currentUserName;
  final String? senderName;
  final String? receiverName;
  final String? senderUid;
  final String? receiverUid;
  final String? userEmail;
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
      this.userEmail,
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
String generateCallID(String userA, String userB) {
  final ids = [userA, userB]..sort();
  return ids.join("_");
}

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
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.image,
                        color: isColorValidation(context),
                        size: 22,
                      ),
                      onPressed: () async {
                        bool hasPermission =
                            await AppPermissionManager.checkMediaFilePermission(
                                context);

                        if (!hasPermission) return;
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
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.camera,
                        color: isColorValidation(context),
                        size: 22,
                      ),
                      // onPressed: () async {
                      //   // ignore: unused_local_variable
                      //   final XFile? pickedFiles = await picker.pickImage(
                      //       source: ImageSource.camera, imageQuality: 5);
                      //   List<String> base64Images = [];
                      //   if (pickedFiles != null) {
                      //     File imageFile = File(pickedFiles.path);
                      //     List<int> imageBytes = await imageFile.readAsBytes();

                      //     String base64Image = base64Encode(imageBytes);
                      //     base64Images.add(base64Image);

                      //     context
                      //         .read<ChatScreenBloc>()
                      //         .add(OnSendImage(base64Images));
                      //   }
                      //   Navigator.pop(context);
                      // },
                      onPressed: () async {
                        bool hasPermission =
                            await AppPermissionManager.checkCameraPermission(
                                context);

                        if (!hasPermission) return;

                        final XFile? pickedFiles = await picker.pickImage(
                          source: ImageSource.camera,
                          imageQuality: 5,
                        );

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
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.solidFile,
                        color: isColorValidation(context),
                        size: 22,
                      ),
                      onPressed: () async {
                        AppSnackbar.info(context, 'Send Documents.');
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

Widget _buildBeautifulDialog(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.85,
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor
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
          child: Icon(
            Icons.delete_sweep,
            size: 40,
            color: isColorValidation(context),
          ),
        ),
        const SizedBox(height: 20),

        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor
            ],
          ).createShader(bounds),
          child: Text(
            "Clear Conversation",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isColorValidation(context),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Description
        Text(
          "Are you sure you want to delete all messages and media in this chat?",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),

        // Bullet points
        _buildBulletPoint("All messages will be permanently deleted"),
        const SizedBox(height: 8),
        _buildBulletPoint("Photos and videos will be removed"),
        const SizedBox(height: 8),
        _buildBulletPoint("This action cannot be undone"),
        const SizedBox(height: 24),

        // Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                  side: BorderSide(color: Colors.grey[300]!),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Keep Chat",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<ChatScreenBloc>().add(ClearMessages());

                  AppSnackbar.success(context, "Chat cleared successfully");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: isColorValidation(context),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Clear Now",
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isColorValidation(context)),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildBulletPoint(String text) {
  return Row(
    children: [
      Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.close,
          size: 14,
          color: Colors.red,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
      ),
    ],
  );
}

class _ChatScreenState extends State<ChatScreen> {
  bool enterIsSend = false;

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      enterIsSend = prefs.getBool('enterIsSend') ?? false;
    });
  }

  ImageProvider _getWallpaperImage(String path) {
    if (path.startsWith('http')) {
      return NetworkImage(path);
    } else {
      return AssetImage(path);
    }
  }

  @override
  void dispose() {
    // ZegoService.uninit();
    super.dispose();
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
        widget.receiverUid ?? "",
        widget.receiverFCM!,
      )
        ..add(Loadmessages())
        ..add(StartListeningMessages()),
      child: BlocBuilder<ChatScreenBloc, ChatScreenState>(
        builder: (context, chatState) {
          final selectedMessageIds = chatState is ChatScreenLoaded
              ? chatState.selectedMessageIds
              : const <String>{};
          final isSelectionMode = selectedMessageIds.isNotEmpty;

          return Scaffold(
            backgroundColor: AppColor.backgroundColor,
            appBar: isSelectionMode
                ? _buildSelectionAppBar(context, selectedMessageIds)
                : _buildNormalAppBar(context),
            body: BlocBuilder<ChatSettingBloc, ChatSettingState>(
              builder: (context, settingState) {
                return BlocConsumer<ChatScreenBloc, ChatScreenState>(
                  buildWhen: (previous, current) {
                    return previous is Loadmessages ==
                        current is StartListeningMessages;
                  },
                  listener: (context, state) {
                    debugPrint("=> BlocConsumer is called");
                    if (state is ChatScreenLoaded ||
                        state is ChatScreenLoading) {
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => _scrollToBottom());
                    }
                  },
                  builder: (context, state) {
                    if (state is ChatScreenLoaded ||
                        state is ChatScreenLoading) {
                      debugPrint("=> ChatScreenState is called");
                      final ids = state is ChatScreenLoaded
                          ? state.selectedMessageIds
                          : const <String>{};
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                _getWallpaperImage(settingState.wallpaperPath),
                          ),
                        ),
                        child: ShowMessagesRealTime(
                          widget: widget,
                          size: size,
                          enterIsSend: enterIsSend,
                          selectedMessageIds: ids,
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
                );
              },
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildSelectionAppBar(
      BuildContext context, Set<String> selectedIds) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.white),
        onPressed: () {
          context.read<ChatScreenBloc>().add(ClearMessageSelection());
        },
      ),
      title: Text(
        '${selectedIds.length} selected',
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.white),
          tooltip: 'Delete selected',
          onPressed: () {
            _showDeleteConfirmationDialog(context, selectedIds);
          },
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext ctx, Set<String> selectedIds) {
    showDialog(
      context: ctx,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Icon(Icons.delete_outline, color: Theme.of(ctx).primaryColor),
            const SizedBox(width: 8),
            const Text('Delete Messages'),
          ],
        ),
        content: Text(
          'Delete ${selectedIds.length} selected message${selectedIds.length > 1 ? 's' : ''}? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              ctx.read<ChatScreenBloc>().add(
                    DeleteSelectedMessages(selectedIds.toList()),
                  );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildNormalAppBar(BuildContext context) {
    return CustomeAppBar(
      centerTitle: false,
      automaticallyImplyLeadings: false,
      titleSpacing: 12,
      titleWidget: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchedUserDetails(
                userMobile: widget.mobileNumber,
                userProfile: widget.profileImage,
                username: widget.receiverName,
                userEmail: widget.userEmail,
              ),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipOval(
              child: Image.memory(
                height: 40,
                width: 40,
                base64Decode(widget.profileImage ?? AppString.demoImgurl),
                errorBuilder: (context, error, stackTrace) {
                  return Image.memory(
                    base64Decode(AppString.demoImgurl),
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  );
                },
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.receiverName!,
                      style: TextStyle(
                        fontSize: 20,
                        color: isColorValidation(context),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.mobileNumber!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isColorValidation(context).withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // leading: BackButton(
      //   onPressed: () {
      //     Navigator.pop(context);
      //   },
      // ),
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          margin: const EdgeInsets.only(left: 16),
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
      // leading: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: GestureDetector(
      //     onTap: () {
      //       Navigator.pop(context);
      //     },
      //     child: Container(
      //       decoration: BoxDecoration(
      //           color: Colors.transparent,
      //           shape: BoxShape.circle,
      //           border: Border.all(color: Colors.white)),
      //       child: const Center(
      //         child: FaIcon(
      //           FontAwesomeIcons.arrowLeft,
      //           size: 18,
      //           color: Colors.white,
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      actions: [
        IconButton.filled(
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          constraints: const BoxConstraints(),
          onPressed: () async {
            try {
              if (!ZegoService.initialized) {
                AppSnackbar.error(
                    context, "Call service not ready. Please try again.");
                return;
              }

              await ZegoService.sendCallInvitation(
                senderUid: widget.senderUid!,
                receiverUid: widget.receiverUid!,
                receiverName: widget.receiverName!,
                isVideoCall: true,
              );
            } catch (e) {
              AppSnackbar.error(
                  context, "Failed to start call: ${e.toString()}");
              debugPrint("Call initiation error: $e");
            }
          },
          icon: Icon(
            FontAwesomeIcons.video,
            size: 18,
            color: isColorValidation(context).withOpacity(0.9),
          ),
        ),
        SizedBox(
          width: 18,
        ),
        IconButton.filled(
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          constraints: const BoxConstraints(),
          onPressed: () async {
            await ZegoService.sendCallInvitation(
              senderUid: widget.senderUid!,
              receiverUid: widget.receiverUid!,
              receiverName: widget.receiverName!,
              isVideoCall: false,
            );
          },
          icon: Icon(
            FontAwesomeIcons.phone,
            color: isColorValidation(context).withOpacity(0.9),
            size: 18,
          ),
        ),
        PopupMenuButton(
          iconColor: isColorValidation(context).withOpacity(0.9),
          color: AppColor.backgroundColor,
          padding: EdgeInsets.all(2),
          menuPadding: const EdgeInsets.all(4),
          itemBuilder: (context) => <PopupMenuItem<int>>[
            // PopupMenuItem(
            //   onTap: () {
            //     context.read<ChatScreenBloc>().add(ClearMessages());
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(
            //         margin: const EdgeInsets.all(15),
            //         behavior: SnackBarBehavior.floating,
            //         elevation: 50.0,
            //         shape: const RoundedRectangleBorder(
            //           borderRadius: BorderRadius.all(Radius.circular(15)),
            //         ),
            //         backgroundColor: Theme.of(context).primaryColor,
            //         content: const Text(
            //           "Your Chat And Media Clear Successfully",
            //           style: TextStyle(
            //             color: Colors.white,
            //           ),
            //         ),
            //       ),
            //     );
            //   },
            //   child: const Text(
            //     "Clear Chat",
            //     style: TextStyle(color: Colors.black),
            //   ),
            // ),
            PopupMenuItem(
              onTap: () {
                showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: MaterialLocalizations.of(context)
                      .modalBarrierDismissLabel,
                  barrierColor: Colors.black.withOpacity(0.5),
                  transitionDuration: const Duration(milliseconds: 300),
                  pageBuilder: (context, animation1, animation2) {
                    return Container();
                  },
                  transitionBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOut,
                      ),
                      child: ScaleTransition(
                        scale: CurvedAnimation(
                          parent: animation,
                          curve: Curves.elasticOut,
                        ),
                        child: AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          contentPadding: EdgeInsets.zero,
                          content: _buildBeautifulDialog(context),
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Text(
                "Clear Chat",
                style: TextStyle(color: Colors.black),
              ),
            ),

            // PopupMenuItem(
            //   onTap: () {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(
            //         showCloseIcon: true,
            //         margin: const EdgeInsets.all(15),
            //         behavior: SnackBarBehavior.floating,
            //         elevation: 50.0,
            //         shape: const RoundedRectangleBorder(
            //           borderRadius: BorderRadius.all(Radius.circular(15)),
            //         ),
            //         backgroundColor: Theme.of(context).primaryColor,
            //         content: const Text(
            //           "Opening Setting..!",
            //           style: TextStyle(
            //             color: Colors.white,
            //           ),
            //         ),
            //       ),
            //     );
            //   },
            //   child: const Text(
            //     "Setting",
            //     style: TextStyle(color: Colors.black),
            //   ),
            // ),
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
    );
  }
}

class ShowMessagesRealTime extends StatelessWidget {
  const ShowMessagesRealTime({
    super.key,
    required this.widget,
    required this.size,
    required this.enterIsSend,
    required this.selectedMessageIds,
  });

  final ChatScreen widget;
  final Size size;
  final bool enterIsSend;
  final Set<String> selectedMessageIds;

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
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
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
                  final doc = snapShot.data!.docs[index];
                  Map<String, dynamic> messages =
                      doc.data() as Map<String, dynamic>;
                  final docId = doc.id;
                  final isCurrentUser =
                      messages['sendby'] == widget.currentUserName;
                  final timestamp = (messages['time'] is Timestamp)
                      ? messages['time'] as Timestamp
                      : Timestamp.now();
                  final DateTime dateTime = timestamp.toDate();
                  final String formattedTime =
                      DateFormat('hh:mm a').format(dateTime);
                  final isSelected = selectedMessageIds.contains(docId);

                  if (messages["isImage"] == true) {
                    return ImageMessage(
                      message: messages,
                      isCurrentUser: isCurrentUser,
                      formattedTime: formattedTime,
                      docId: docId,
                      isSelected: isSelected,
                    );
                  } else {
                    return MessageData(
                      isCurrentUser: isCurrentUser,
                      message: messages,
                      formattedTime: formattedTime,
                      docId: docId,
                      isSelected: isSelected,
                    );
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
                  textInputAction: enterIsSend
                      ? TextInputAction.send
                      : TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  onFieldSubmitted: (value) {
                    if (enterIsSend) {
                      final messageText = messageController.text.trim();
                      if (messageText.isNotEmpty) {
                        context
                            .read<ChatScreenBloc>()
                            .add(OnSendMessage(messageText));
                        context
                            .read<ChatScreenBloc>()
                            .add(StartListeningMessages());
                        messageController.clear();
                      }
                    }
                  },
                  maxLines: 5,
                  minLines: 1,
                  expands: false,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _showModal(context);
                      },
                      icon: FaIcon(
                        FontAwesomeIcons.paperclip,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                    ),
                    hintStyle:
                        TextStyle(color: AppColor.blackColor, fontSize: 14),
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
                  color: Theme.of(context).primaryColor,
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
                        // AppSnackbar.error(context, "Enter message to send.");
                        log("Enter message to send.");
                      }
                    },
                    icon: Icon(
                      Icons.send,
                      color: isColorValidation(context),
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
    required this.message,
    required this.isCurrentUser,
    required this.formattedTime,
    required this.docId,
    required this.isSelected,
  });

  final Map<String, dynamic> message;
  final bool isCurrentUser;
  final String formattedTime;
  final String docId;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final images = List<String>.from(message['message'] ?? []);
    return GestureDetector(
      onLongPress: () {
        context.read<ChatScreenBloc>().add(ToggleMessageSelection(docId));
      },
      onTap: () {
        final bloc = context.read<ChatScreenBloc>();
        final state = bloc.state;
        if (state is ChatScreenLoaded && state.selectedMessageIds.isNotEmpty) {
          bloc.add(ToggleMessageSelection(docId));
        } else if (images.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageView(imageUrl: images[0]),
            ),
          );
        }
      },
      child: Container(
        color: isSelected ? Colors.blue.withOpacity(0.15) : Colors.transparent,
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
                      color: isCurrentUser
                          ? Theme.of(context).primaryColor
                          : Colors.grey[350],
                      border: isSelected
                          ? Border.all(color: Colors.blue, width: 2)
                          : null,
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
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                formattedTime,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isCurrentUser
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              if (isCurrentUser) ...[
                                const SizedBox(width: 4),
                                _buildStatusIcon(),
                              ],
                            ],
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
      ),
    );
  }

  Widget _buildStatusIcon() {
    final isRead = message['isRead'] ?? false;
    final isDelivered = message['isDelivered'] ?? false;

    if (isRead) {
      return const Icon(
        Icons.done_all,
        size: 14,
        color: Colors.blue,
      );
    } else if (isDelivered) {
      return const Icon(
        Icons.done_all,
        size: 14,
        color: Colors.grey,
      );
    } else {
      return const Icon(
        Icons.done,
        size: 14,
        color: Colors.grey,
      );
    }
  }
}

class MessageData extends StatelessWidget {
  const MessageData({
    super.key,
    required this.isCurrentUser,
    required this.message,
    required this.formattedTime,
    required this.docId,
    required this.isSelected,
  });

  final bool isCurrentUser;
  final Map<String, dynamic> message;
  final String formattedTime;
  final String docId;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        context.read<ChatScreenBloc>().add(ToggleMessageSelection(docId));
      },
      onTap: () {
        final bloc = context.read<ChatScreenBloc>();
        final state = bloc.state;
        if (state is ChatScreenLoaded && state.selectedMessageIds.isNotEmpty) {
          bloc.add(ToggleMessageSelection(docId));
        }
      },
      child: Container(
        color: isSelected ? Colors.blue.withOpacity(0.15) : Colors.transparent,
        child: Align(
          alignment:
              isCurrentUser ? Alignment.bottomRight : Alignment.centerLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: isCurrentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 250),
                margin: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 2, top: 6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isCurrentUser
                      ? Theme.of(context).primaryColor
                      : Colors.grey[350],
                  borderRadius: isCurrentUser
                      ? const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                          topLeft: Radius.circular(15))
                      : const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                          topRight: Radius.circular(15)),
                  border: isSelected
                      ? Border.all(color: Colors.blue, width: 2)
                      : null,
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
                          color: isCurrentUser
                              ? isColorValidation(context)
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formattedTime,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: 4),
                      _buildStatusIcon(),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    final isRead = message['isRead'] ?? false;
    final isDelivered = message['isDelivered'] ?? false;

    if (isRead) {
      return const Icon(
        Icons.done_all,
        size: 14,
        color: Colors.blue,
      );
    } else if (isDelivered) {
      return const Icon(
        Icons.done_all,
        size: 14,
        color: Colors.grey,
      );
    } else {
      return const Icon(
        Icons.done,
        size: 14,
        color: Colors.grey,
      );
    }
  }
}
