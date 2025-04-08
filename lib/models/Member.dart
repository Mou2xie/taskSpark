import 'package:flutter/material.dart';

class Member {
  final String name;
  final CircleAvatar? avatar;

  Member({
    required this.name,
    this.avatar,
  });

  // 如果没有设置头像，则使用名字的第一个字母作为默认头像
  Widget get defaultAvatar {
    return avatar ?? CircleAvatar(
      backgroundColor: Colors.blue,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}