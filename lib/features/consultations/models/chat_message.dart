enum ChatSender { user, doctor }

class ChatMessage {
  final String id;
  final ChatSender sender;
  final String text;
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
  });
}

