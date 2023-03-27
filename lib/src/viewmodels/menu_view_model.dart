import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tindog/src/config/route.dart' as custom_route;


class Menu {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Function(BuildContext context) onTap;

  const Menu(
      this.title, {
        required this.icon,
        required this.iconColor,
        required this.onTap,
      });
}

class MenuViewModel {
  List<Menu> get items => <Menu>[
    Menu(
      'Profile',
      icon: FontAwesomeIcons.users,
      iconColor: Colors.deepOrange,
      onTap: (context) {
        Navigator.pushNamed(context, custom_route.Route.profile);
      },
    ),
    Menu(
      'MyDog',
      icon: FontAwesomeIcons.dog,
      iconColor: Colors.green,
      onTap: (context) {
        Navigator.pushNamed(context, custom_route.Route.mydog);
      },
    ),
    Menu(
      'Inbox',
      icon: FontAwesomeIcons.inbox,
      iconColor: Colors.amber,
      onTap: (context) {
        Navigator.pushNamed(context, custom_route.Route.chats);
      },
    ),
    Menu(
      'Upload Image From Firebase',
      icon: FontAwesomeIcons.google,
      iconColor: Colors.blueGrey,
      onTap: (context) {
      Navigator.pushNamed(context, custom_route.Route.uploadimage);
      },
    )
  ];
}
