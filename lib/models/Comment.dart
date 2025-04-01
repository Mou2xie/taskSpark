class Comment {
  final String content;
  final DateTime createTime;

  Comment({
    required this.content,
  }) : createTime = DateTime.now();
} 