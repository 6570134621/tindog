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
      iconColor: Colors.blueGrey,
      onTap: (context) {
        Navigator.pushNamed(context, custom_route.Route.profile);
      },
    ),
    Menu(
      'MyDog',
      icon: FontAwesomeIcons.dog,
      iconColor: Colors.blueGrey,
      onTap: (context) {
        //Navigator.pushNamed(context, custom_route.Route.mydog);
        Navigator.pushNamed(context, custom_route.Route.mydogFirebase);

      },
    ),
    Menu(
      "Upload Dog Image ",
      icon: FontAwesomeIcons.upload,
      iconColor: Colors.blueGrey,
      onTap: (context) {
      Navigator.pushNamed(context, custom_route.Route.uploadimage);
      },
    ),
    Menu(
      'coming soon..',
      icon: FontAwesomeIcons.inbox,
      iconColor: Colors.black12,
      onTap: (context) {
        // Navigator.pushNamed(context, custom_route.Route.chats);
      },
    ),
  ];
}
