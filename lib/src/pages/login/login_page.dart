import 'package:bangkaew/src/pages/home/home_page.dart';
import 'package:bangkaew/src/provider/google_sign_in.dart';
import 'package:bangkaew/src/viewmodels/single_sign_on_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bangkaew/src/config/route.dart' as custom_route;
import 'package:bangkaew/src/config/theme.dart' as custom_theme;
import 'package:bangkaew/src/pages/login/widgets/header.dart';
import 'package:bangkaew/src/pages/login/widgets/login_form.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              ),
                  _buildDivider(),
                  SizedBox(height: 12),
                  _buildSingleSignOnButton(),
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

  Row _buildDivider() {
    final gradientColor = const [Colors.white10, Colors.white];
    final line = (List<Color> colors) => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.0, 1.0],
        ),
      ),
      width: 80.0,
      height: 1.0,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        line(gradientColor),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            'or',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 16.0,
            ),
          ),
        ),
        line(gradientColor.reversed.toList()),
      ],
    );
  }

  Padding _buildSingleSignOnButton() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 22),
    child: ElevatedButton.icon(
      icon: FaIcon(FontAwesomeIcons.google, color: Colors.red,),
      label: Text('Sign Up with Google'),
      style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Colors.black54,
          minimumSize: Size(double.infinity, 50)
      ),
      // onPressed: (){
      //   AuthService().signInWithGoogle();
      //   if (mounted) {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (_)=> HomePage())
      //     );
      //   }
      // },
      onPressed: () async {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signInSilently();
        if (googleUser != null) {
          final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          await FirebaseAuth.instance.signInWithCredential(credential);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HomePage()),
          );
        } else {
          AuthService().signInWithGoogle();
        }

      },
    )

  );
}
