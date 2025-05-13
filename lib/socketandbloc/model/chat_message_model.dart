enum MessageType { text, image }

class MessageModel {
  final String sender;
  final String receiver;
  final String content;
  final MessageType type;

  MessageModel({
    required this.sender,
    required this.receiver,
    required this.content,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'sender': sender,
        'receiver': receiver,
        'content': content,
        'type': type.name,
      };

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      sender: json['sender'],
      receiver: json['receiver'],
      content: json['content'],
      type: json['type'] == 'image' ? MessageType.image : MessageType.text,
    );
  }
}
