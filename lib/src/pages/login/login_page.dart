import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bangkaew/src/config/route.dart' as custom_route;
import 'package:bangkaew/src/config/theme.dart' as custom_theme;
import 'package:bangkaew/src/pages/login/widgets/header.dart';
import 'package:bangkaew/src/pages/login/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
              gradient: custom_theme.Theme.gradient,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                SizedBox(height: 100,),
                Header(),
                SizedBox(height: 10,),
                LoginForm(),
                SizedBox(height: 30,),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(onPressed: (){
                      Navigator.pushNamed(context, custom_route.Route.detailform);
                    }, child: Row(
                      children: [
                        FaIcon(FontAwesomeIcons.userPlus, color: Colors.white),
                        SizedBox(width: 10,),
                        Text("Sign Up", style: Theme.of(context).textTheme.headline1,)
                        ],
                      ))],
              )
            ],
          ),
        )
      ],
    ));
  }

  TextButton _buildFlatButton(
    String text, {
    required VoidCallback onPressed,
    double fontSize = 18,
  }) =>
      TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.normal),
          ));

  // Row _signUpOption() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       const Text()
  //     ],
  //   )
  // }
}
