
import 'package:flutter/cupertino.dart';
import 'package:tindog/src/pages/chats/chats_page.dart';
import 'package:tindog/src/pages/detailform/detail_form.dart';
import 'package:tindog/src/pages/home/home_page.dart';
import 'package:tindog/src/pages/home/widgets/ProfilePage.dart';
import 'package:tindog/src/pages/login/login_page.dart';
import 'package:tindog/src/pages/management/management_page.dart';
import 'package:tindog/src/pages/mydog/mydog_page.dart';
import 'package:tindog/src/pages/home/widgets/edit_profile_page.dart';
import 'package:tindog/src/pages/upload_images/upload_image_firebase.dart';




class Route{
  static const home = '/home';
  static const login = '/login';
  static const profile = '/profile';
  static const mydog = '/mydog';
  static const chats = '/chats';
  static const management = '/management';
  static const detailform = '/detailform';
  static const uploadimage = '/upload_images';
  static const editpage = '/edit_page';




  static Map<String, WidgetBuilder> getAll() => _route;
  static final Map<String, WidgetBuilder> _route ={
    home : (context) => HomePage(),
    login : (context) => LoginPage(),
    mydog : (context) => AllDog(),
    profile : (context) => ProfilePage(),
    chats : (context) => Chats(),
    management : (context) => ManagementPage(),
    detailform : (context) => CreateProfile(),
    uploadimage : (context) => UploadsImage(),
    editpage : (context) => EditProfilePage(),
  };
}