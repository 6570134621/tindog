import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tindog/src/config/route.dart' as custom_route;
import 'package:tindog/src/constants/setting.dart';
import 'package:tindog/src/pages/home/home_page.dart';
import 'package:tindog/src/pages/login/login_page.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: custom_route.Route.getAll(),
      title: 'TinDog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: HomePage(),
      home: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final token = snapshot.data?.getString(Setting.TOKEN_PREF) ?? '';
            if (token.isNotEmpty) {
              return HomePage();
            }
            return LoginPage();
          }
          return SizedBox();
        },
      ),
    );
  }
}
