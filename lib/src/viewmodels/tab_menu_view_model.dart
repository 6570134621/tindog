
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tindog/src/pages/home/widgets/messages.dart';
import 'package:tindog/src/pages/home/widgets/nearme.dart';

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
      'NEARME',
      NearMe(),
      icon: FontAwesomeIcons.mapLocation,
    ),
    TabMenu(
      'MESSAGES',
      Messages(),
      icon: FontAwesomeIcons.message,
    ),


  ];
}