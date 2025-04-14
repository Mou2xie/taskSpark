class Comment {
  final String content;
  final DateTime createTime;

  Comment({
    required this.content,
    DateTime? createTime,
  }) : createTime = createTime ?? DateTime.now();
} 