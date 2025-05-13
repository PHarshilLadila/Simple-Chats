 

// import 'dart:convert';

// import 'package:chat_app_bloc/socketandbloc/model/chat_message_model.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class SocketServiceMain {
//   static final SocketServiceMain _instance = SocketServiceMain._internal();
//   factory SocketServiceMain() => _instance;

//   late WebSocketChannel channel;
//   final String url = 'ws://192.168.1.11:3000';

//   SocketServiceMain._internal();

//   void connect(String userId) {
//     channel = WebSocketChannel.connect(Uri.parse('$url?userId=$userId'));
//   }

//   void sendMessage(MessageModel message) {
//     channel.sink.add(jsonEncode(message.toJson()));
//   }

//   Stream<MessageModel> get messages {
//     return channel.stream.map((event) {
//       final data = jsonDecode(event);
//       return MessageModel.fromJson(data);
//     });
//   }

//   void disconnect() {
//     channel.sink.close();
//   }
// }
import 'dart:convert';
import 'package:chat_app_bloc/socketandbloc/model/chat_message_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
 
class SocketServiceMain {
  static final SocketServiceMain _instance = SocketServiceMain._internal();
  factory SocketServiceMain() => _instance;

  late WebSocketChannel channel;
  final String url = 'ws://192.168.1.11:3000';

  SocketServiceMain._internal();

  void connect(String userId) {
    channel = WebSocketChannel.connect(Uri.parse('$url?userId=$userId'));
  }

  void sendMessage(MessageModel message) {
    final encoded = jsonEncode(message.toJson());
    channel.sink.add(encoded);
  }

  Stream<MessageModel> get messages {
    return channel.stream.map((event) {
      final data = jsonDecode(event);
      return MessageModel.fromJson(data);
    });
  }

  void disconnect() {
    channel.sink.close();
  }
}
