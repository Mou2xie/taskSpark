import 'package:flutter/material.dart';

enum Member {
  sam,
  xie,
  isha,
  shamshad;

  String get name {
    switch (this) {
      case Member.sam:
        return 'Sam';
      case Member.xie:
        return 'Xie';
      case Member.isha:
        return 'Isha';
      case Member.shamshad:
        return 'Shamshad';
    }
  }

  Widget get avatar {
    switch (this) {
      case Member.sam:
        return CircleAvatar(
          backgroundImage: AssetImage('lib/assets/images/sam.png'),
        );
      case Member.xie:
        return CircleAvatar(
          backgroundImage: AssetImage('lib/assets/images/xie.png'),
        );
      case Member.isha:
        return CircleAvatar(
          backgroundImage: AssetImage('lib/assets/images/isha.png'),
        );
      case Member.shamshad:
        return CircleAvatar(
          backgroundImage: AssetImage('lib/assets/images/sham.png'),
        );
    }
  }
}