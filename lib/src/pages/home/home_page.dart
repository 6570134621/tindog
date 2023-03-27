
import 'package:flutter/material.dart';
import 'package:tindog/src/pages/home/widgets/customTabBar.dart';
import 'package:tindog/src/pages/home/widgets/custom_drawer.dart';
import 'package:tindog/src/viewmodels/tab_menu_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _tabsMenu = TabMenuViewModel().items;
  @override

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabsMenu.length,
      child: Scaffold(
        appBar: _buildAppBar(),
        drawer: CustomDrawer(),
        body: TabBarView(
          children: _tabsMenu.map((item) => item.widget).toList(),
        ),
      ),
    );
  }
  AppBar _buildAppBar() {
    return AppBar(
      title: Text('TinDog'),
      bottom: CustomTabBar(_tabsMenu),
      actions: [
        IconButton(
          icon: Icon(Icons.bookmark_border),
          onPressed: () {
            //todo
          },
        ),
        IconButton(
          icon: Icon(Icons.qr_code),
          onPressed: () {
            //todo
          },
        ),
      ],
    );
  }
}
