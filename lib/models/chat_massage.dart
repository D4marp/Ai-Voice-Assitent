class ChatMassage {
  final String role;
  final String content;

  ChatMassage({required this.role, required this.content});

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }
}