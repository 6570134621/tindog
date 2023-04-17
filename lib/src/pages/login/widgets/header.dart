import 'package:flutter/material.dart';
import 'package:bangkaew/src/constants/asset.dart';


class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.only(top: 50, bottom: 35),
      child: (
        Image.asset(
            'assets/images/LogoBangkaew.png',
            height: 100)
      ),
    );
  }
}
