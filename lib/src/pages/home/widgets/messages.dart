
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bangkaew/src/pages/chats/chats_page.dart';

//class Messages extends StatelessWidget {
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image.network('https://cdn.pixabay.com/photo/2019/12/27/08/36/coming-soon-hour-glass-4721933_1280.png'),
          )
        ],
      )
    );
  }
}

