import 'package:flutter/widgets.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:io';

class SocketService {
  late IO.Socket socket;

  void connect(String userId) {
    String socketUrl = Platform.isAndroid
        ? "http://192.168.1.14:3000" // Use local IP
        : "http://192.168.1.14:3000"; // Replace with your actual server IP

    socket = IO.io(socketUrl, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      "forceNew": true,
    });

    socket.connect();

    socket.onConnect((_) {
      debugPrint("=> Connected to Socket.IO Server");
      socket.emit("join_room", userId);
    });

    socket.onConnectError((error) {
      debugPrint("=> Socket Connection Error: $error");
    });

    socket.onError((error) {
      debugPrint("=> Socket Error: $error");
    });

    socket.onDisconnect(
        (_) => debugPrint("=> Disconnected from Socket.IO Server"));
  }

  void sendMessage(
      String senderId, String receiverId, Map<String, dynamic> message) {
    debugPrint("=> Sending Message via Socket.IO: $message");

    socket.emit("send_message", {
      "senderId": senderId,
      "receiverId": receiverId,
      "message": message,
    });
  }

  void listenForMessages(Function(Map<String, dynamic>) onMessageReceived) {
    debugPrint("=> Listening for Messages via Socket.IO");

    socket.on("receive_message", (data) {
      debugPrint("=> Received Message from Socket.IO: $data");

      if (data is Map<String, dynamic>) {
        onMessageReceived(data);
        debugPrint("This is data of Socket.io receiver:  -->> $data");
      } else {
        debugPrint("=> Received data is not a valid Map: $data");
      }
    });
  }

  void disconnect() {
    socket.disconnect();
  }
}
