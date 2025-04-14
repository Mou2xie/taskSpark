import 'package:flutter/material.dart';

class Member {
  final int? id;
  final String name;
  final CircleAvatar? avatar;

  Member({
    this.id,
    required this.name,
    this.avatar,
  });

  // if avatar is null, return a default avatar with the first letter of the name
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