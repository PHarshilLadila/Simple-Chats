// // // import 'package:flutter/material.dart';

// // // class SocketChatPage extends StatelessWidget {
// // //   const SocketChatPage({super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //         appBar: AppBar(
// // //           leading: Padding(
// // //             padding: const EdgeInsets.all(8.0),
// // //             child: CircleAvatar(
// // //               backgroundImage: NetworkImage(
// // //                 "https://mir-s3-cdn-cf.behance.net/project_modules/hd/d95c1f148207527.62d1246c25004.jpg",
// // //               ),
// // //               backgroundColor: Colors.blue,
// // //             ),
// // //           ),
// // //           title: const Text('Lois merain'),
// // //           actions: [
// // //             IconButton(
// // //               icon: const Icon(Icons.call),
// // //               onPressed: () {
// // //                 // Handle call action
// // //               },
// // //             ),
// // //             IconButton(
// // //               icon: const Icon(Icons.video_call),
// // //               onPressed: () {
// // //                 // Handle video call action
// // //               },
// // //             ),
// // //           ],
// // //         ),
// // //         body: Column(
// // //           children: [
// // //             Expanded(
// // //                 child: ListView(
// // //               padding: EdgeInsets.all(20),
// // //               children: [
// // //                 _buildRecivedMessage("Hello, how are you?"),
// // //                 _buildRecivedMessage("I am fine, thank you!"),
// // //                 _buildRecivedMessage("What about you?"),
// // //                 _buildRecivedMessage("I am doing great!"),
// // //                 _buildRecivedMessage("Let's meet up tomorrow."),
// // //                 _buildRecivedMessage("Sure, sounds good!"),
// // //                 _buildSentMessage("Hello, how are you?"),
// // //                 _buildSentMessage("I am fine, thank you!"),
// // //                 _buildSentMessage("What about you?"),
// // //               ],
// // //             )),
// // //             _buildMessageInput(context),
// // //           ],
// // //         ));
// // //   }
// // // }

// // // Widget _buildRecivedMessage(String message) {
// // //   return Align(
// // //     alignment: Alignment.centerLeft,
// // //     child: Container(
// // //       padding: EdgeInsets.all(10),
// // //       margin: EdgeInsets.only(bottom: 10, left: 10, right: 30),
// // //       decoration: BoxDecoration(
// // //         color: Colors.grey[300],
// // //         borderRadius: BorderRadius.circular(10),
// // //       ),
// // //       child: Text(message),
// // //     ),
// // //   );
// // // }

// // // Widget _buildSentMessage(String message) {
// // //   return Align(
// // //     alignment: Alignment.centerRight,
// // //     child: Container(
// // //       padding: EdgeInsets.all(10),
// // //       margin: EdgeInsets.only(bottom: 10, left: 30, right: 10),
// // //       decoration: BoxDecoration(
// // //         color: const Color.fromARGB(255, 194, 228, 255),
// // //         borderRadius: BorderRadius.circular(10),
// // //       ),
// // //       child: Text(message),
// // //     ),
// // //   );
// // // }

// // // Widget _buildMessageInput(BuildContext context) {
// // //   return Container(
// // //     padding: const EdgeInsets.all(10),
// // //     decoration: BoxDecoration(
// // //       color: Colors.white,
// // //       borderRadius: BorderRadius.circular(30),
// // //     ),
// // //     child: Row(
// // //       children: [
// // //         IconButton(
// // //           icon: const Icon(Icons.emoji_emotions_outlined),
// // //           onPressed: () {
// // //             // Handle emoji button press
// // //           },
// // //         ),
// // //         Expanded(
// // //           child: TextField(
// // //             decoration: InputDecoration(
// // //               hintText: 'Type a message',
// // //               border: InputBorder.none,
// // //             ),
// // //           ),
// // //         ),
// // //         IconButton(
// // //           icon: const Icon(Icons.send),
// // //           onPressed: () {
// // //             // Handle send button press
// // //           },
// // //         ),
// // //       ],
// // //     ),
// // //   );
// // // }

// // import 'dart:io';
// // import 'package:chat_app_bloc/socketandbloc/bloc/socket_chat_bloc.dart';
// // import 'package:chat_app_bloc/socketandbloc/bloc/socket_chat_event.dart';
// // import 'package:chat_app_bloc/socketandbloc/bloc/socket_chat_state.dart';
// // import 'package:chat_app_bloc/socketandbloc/model/chat_message_model.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:image_picker/image_picker.dart';

// // class SocketChatPage extends StatefulWidget {
// //   const SocketChatPage({super.key});

// //   @override
// //   State<SocketChatPage> createState() => _SocketChatPageState();
// // }

// // class _SocketChatPageState extends State<SocketChatPage> {
// //   final TextEditingController _controller = TextEditingController();
// //   final ImagePicker _picker = ImagePicker();

// //   void _sendTextMessage() {
// //     if (_controller.text.trim().isEmpty) return;

// //     context.read<SocketChatBloc>().add(
// //           SocketSendMessageEvent(
// //             MessageModel(
// //               sender: 'Me',
// //               receiver: 'Lois',
// //               content: _controller.text,
// //               type: MessageType.text,
// //             ),
// //           ),
// //         );
// //     _controller.clear();
// //   }

// //   Future<void> _sendImageMessage() async {
// //     final image = await _picker.pickImage(source: ImageSource.gallery);
// //     if (image != null) {
// //       context.read<SocketChatBloc>().add(
// //             SocketSendMessageEvent(
// //               MessageModel(
// //                 sender: 'Me',
// //                 receiver: 'Lois',
// //                 content: image.path,
// //                 type: MessageType.image,
// //               ),
// //             ),
// //           );
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Socket Chat')),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: BlocBuilder<SocketChatBloc, SocketChatState>(
// //               builder: (context, state) {
// //                 return ListView.builder(
// //                   padding: const EdgeInsets.all(8),
// //                   itemCount: state.messages.length,
// //                   itemBuilder: (context, index) {
// //                     final msg = state.messages[index];
// //                     return Align(
// //                       alignment: msg.sender == 'Me'
// //                           ? Alignment.centerRight
// //                           : Alignment.centerLeft,
// //                       child: Container(
// //                         margin: const EdgeInsets.symmetric(vertical: 5),
// //                         padding: const EdgeInsets.all(10),
// //                         decoration: BoxDecoration(
// //                           color: msg.sender == 'Me'
// //                               ? Colors.blue[100]
// //                               : Colors.grey[300],
// //                           borderRadius: BorderRadius.circular(10),
// //                         ),
// //                         child: msg.type == MessageType.image
// //                             ? Image.file(File(msg.content), width: 150)
// //                             : Text(msg.content),
// //                       ),
// //                     );
// //                   },
// //                 );
// //               },
// //             ),
// //           ),
// //           Row(
// //             children: [
// //               IconButton(
// //                 icon: const Icon(Icons.photo),
// //                 onPressed: _sendImageMessage,
// //               ),
// //               Expanded(
// //                 child: TextField(
// //                   controller: _controller,
// //                   decoration: const InputDecoration(hintText: 'Type a message'),
// //                 ),
// //               ),
// //               IconButton(
// //                 icon: const Icon(Icons.send),
// //                 onPressed: _sendTextMessage,
// //               ),
// //             ],
// //           )
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _SocketChatView extends StatefulWidget {
// //   const _SocketChatView({super.key});

// //   @override
// //   State<_SocketChatView> createState() => _SocketChatViewState();
// // }

// // class _SocketChatViewState extends State<_SocketChatView> {
// //   final TextEditingController _controller = TextEditingController();
// //   final ImagePicker _picker = ImagePicker();

// //   late final String senderId;
// //   late final String receiverId;

// //   @override
// //   void initState() {
// //     super.initState();
// //     final bloc = context.read<SocketChatBloc>();
// //     senderId = bloc.senderId;
// //     receiverId = bloc.receiverId;
// //   }

// //   void _sendTextMessage() {
// //     if (_controller.text.trim().isEmpty) return;

// //     context.read<SocketChatBloc>().add(
// //           SocketSendMessageEvent(
// //             MessageModel(
// //               sender: senderId,
// //               receiver: receiverId,
// //               content: _controller.text,
// //               type: MessageType.text,
// //             ),
// //           ),

// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'bloc/socket_chat_bloc.dart';
import 'bloc/socket_chat_event.dart';
import 'bloc/socket_chat_state.dart';
import 'model/chat_message_model.dart';

class SocketChatPage extends StatelessWidget {
  final String senderId;
  final String receiverId;
  final String receiverName;

  const SocketChatPage({
    super.key,
    required this.senderId,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(receiverName)),
      body: _SocketChatView(senderId: senderId, receiverId: receiverId),
    );
  }
}

class _SocketChatView extends StatefulWidget {
  final String senderId;
  final String receiverId;

  const _SocketChatView({
    required this.senderId,
    required this.receiverId,
  });

  @override
  State<_SocketChatView> createState() => _SocketChatViewState();
}

class _SocketChatViewState extends State<_SocketChatView> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  void _sendTextMessage() {
    if (_controller.text.trim().isEmpty) return;

    context.read<SocketChatBloc>().add(
          SocketSendMessageEvent(
            MessageModel(
              sender: widget.senderId,
              receiver: widget.receiverId,
              content: _controller.text,
              type: MessageType.text,
            ),
          ),
        );
    _controller.clear();
  }

  Future<void> _sendImageMessage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      context.read<SocketChatBloc>().add(
            SocketSendMessageEvent(
              MessageModel(
                sender: widget.senderId,
                receiver: widget.receiverId,
                content: image.path,
                type: MessageType.image,
              ),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<SocketChatBloc, SocketChatState>(
            builder: (context, state) {
              final filteredMessages = state.messages
                  .where((msg) =>
                      (msg.sender == widget.senderId &&
                          msg.receiver == widget.receiverId) ||
                      (msg.sender == widget.receiverId &&
                          msg.receiver == widget.senderId))
                  .toList();
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: filteredMessages.length,
                itemBuilder: (context, index) {
                  final msg = filteredMessages[index];
                  return Align(
                    alignment: msg.sender == widget.senderId
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: msg.sender == widget.senderId
                            ? Colors.blue[100]
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: msg.type == MessageType.image
                          ? Image.file(File(msg.content), width: 150)
                          : Text(msg.content),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.photo),
                onPressed: _sendImageMessage,
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                      hintText: 'Type a message', border: InputBorder.none),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendTextMessage,
              ),
            ],
          ),
        )
      ],
    );
  }
}
