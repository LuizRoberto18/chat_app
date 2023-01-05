class ChatMessage {
  final String id;
  final String text;
  final DateTime createAr;

  final String userId;
  final String userName;
  final String userImageUrl;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.createAr,
    required this.userId,
    required this.userName,
    required this.userImageUrl,
  });
}
