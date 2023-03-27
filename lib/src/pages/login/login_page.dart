import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tindog/src/config/route.dart' as custom_route;
import 'package:tindog/src/config/theme.dart' as custom_theme;
import 'package:tindog/src/pages/login/widgets/header.dart';
import 'package:tindog/src/pages/login/widgets/login_form.dart';

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
              SizedBox(
                height: 30,
              ),
              // _buildFlatButton(
              //     "Forgot Password ?",
              //     onPressed: () {
              //       // todo
              //     },
              // ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: (){
                    Navigator.pushNamed(context, custom_route.Route.detailform);
                  }, child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.userPlus, color: Colors.white),
                      SizedBox(width: 10,),
                      Text("Sign Up", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white),)
                    ],
                  ))
                ],
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
