
import 'package:bangkaew/src/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bangkaew/src/pages/home/widgets/messages.dart';
import 'package:bangkaew/src/pages/home/widgets/wtd.dart';

import '../pages/home/widgets/alldog.dart';

class TabMenu {
  final String title;
  final IconData icon;
  final Widget widget;

  const TabMenu(this.title, this.widget, {required this.icon});
}

class TabMenuViewModel {
  List<TabMenu> get items => <TabMenu>[
    TabMenu(
      'ALLDOG',
      DogGrid(),
      icon: FontAwesomeIcons.dog,
    ),
    TabMenu(
      'W.T.D.',
      WTD(),
      icon: FontAwesomeIcons.search,
    ),
    TabMenu(
      'MESSAGES',
      Chat(),
      icon: FontAwesomeIcons.message,
    ),


  ];
}