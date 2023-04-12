import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tindog/src/config/route.dart' as custom_route;
import 'package:tindog/src/config/theme.dart' as custom_theme;
import 'package:tindog/src/pages/detailform/reuseableTextField.dart';
class CreateProfile extends StatefulWidget {
  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _jobController = TextEditingController();
  final _telController = TextEditingController();

  String? _selectedStatus;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Color(0xFF6C5DD3),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF4A4E69),
                Color(0xFF6C5DD3),
              ],
            ),
          ),
        ),
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: custom_theme.Theme.gradient,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 40,),
                  Image.asset('assets/images/logo.png',),
                  reuseableTextField('Enter Name', Icons.person, false, _nameController),
                  SizedBox(height: 20,),
                  reuseableTextField('Enter E-mail', Icons.email_outlined, false, _emailController),
                  SizedBox(height: 20,),
                  reuseableTextField('Enter Password', Icons.lock_outline, false, _passwordController),
                  SizedBox(height: 20,),
                  reuseableTextField('Enter Phone Number', Icons.phone, false, _telController),
                  SizedBox(height: 20,),
                  reuseableTextField('Enter Job', Icons.work_outline, false, _jobController),
                  SizedBox(height: 20,),
                  reuseableTextField('Enter Age', Icons.timeline_sharp, false, _ageController),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF6C5DD3),
                      ),
                      onPressed: () {
                        FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text).then((userCredential) {
                              String uid = userCredential.user!.uid;

                              FirebaseFirestore.instance.collection('users').doc(uid).set({
                                'Name' : _nameController.text,
                                'Email' : _emailController.text,
                                'Tel' : _telController.text,
                                'Job' : _jobController.text,
                                'Age' : _ageController.text,
                                'uid' : uid,
                                'photo' : {},
                              }).then((value) {
                                print("create account");
                                Navigator.pushNamed(context, custom_route.Route.home);
                              });

                            });
                      },
                      child: Text('SUBMIT', style: TextStyle(fontSize: 25),),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
