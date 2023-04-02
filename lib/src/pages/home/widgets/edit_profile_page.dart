import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tindog/src/pages/home/get_user_name.dart';
import 'package:tindog/src/pages/home/widgets/ProfileWidget.dart';
import 'package:tindog/src/pages/home/widgets/textfield_widget.dart';
import 'package:tindog/src/config/route.dart' as custom_route;
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController jobController;
  late final TextEditingController telController;
  late final TextEditingController aboutController;

  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future<QuerySnapshot> getUserData() {
    return FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: uid).get();
  }
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    jobController = TextEditingController();
    telController = TextEditingController();
    aboutController = TextEditingController();
  }
  // @override
  // void dispose() {
  //   nameController.dispose();
  //   emailController.dispose();
  //   jobController.dispose();
  //   telController.dispose();
  //   aboutController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder<QuerySnapshot> (
                future: getUserData(),
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator(),);
                  } else if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
                    return ListView(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      physics: BouncingScrollPhysics(),
                      children: [
                        SizedBox(height: 14,),
                        ProfileWidget(
                          imagePath: 'https://cdn.pixabay.com/photo/2018/05/07/10/48/husky-3380548_1280.jpg',
                          isEdit: true,
                          onClicked: (){},
                        ),
                        SizedBox(height: 14,),
                        TextFieldWidget(
                          label: 'Full Name',
                          text: data['Name'],
                          onChanged: (name) {},
                          controller: nameController,
                        ),
                        const SizedBox(height: 14),
                        TextFieldWidget(
                          label: 'Email',
                          text: data['Email'],
                          onChanged: (email) {},
                          controller: emailController,
                        ),
                        const SizedBox(height: 14),
                        TextFieldWidget(
                          label: 'Job',
                          text: data['Job'],
                          onChanged: (email) {},
                          controller: jobController,
                        ),
                        const SizedBox(height: 14),
                        TextFieldWidget(
                          label: 'Phone Number',
                          text: data['Tel'],
                          onChanged: (email) {},
                          controller: telController,
                        ),
                        const SizedBox(height: 14),
                        TextFieldWidget(
                          label: 'About',
                          text: data['about'],
                          maxLines: 4,
                          onChanged: (about) {},
                          controller: aboutController,

                        ),
                      ],
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }
              )
          ),
        ],
      )
    );
  }

  AppBar buildAppBar() {
    return AppBar(
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
        "Edit Profile",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      actions: [
        ElevatedButton.icon(
        icon: FaIcon(FontAwesomeIcons.save),
        onPressed: (){
          final String name = nameController.text;
          final String email = emailController.text;
          final String job = jobController.text;
          final String tel = telController.text;
          final String about = aboutController.text;
          print('Name: $name');
          print('email: $email');
          print('job: $job');
          print('tel: $tel');
          print('about: $about');
          FirebaseFirestore.instance.collection('users').doc(uid).update({
            'Name' : name,
            'Email' : email,
            'Tel' : tel,
            'Job' : job,
            'about' : about,
          }).then((value) {
            print("edit account");
            Navigator.pushNamed(context, custom_route.Route.home);
            });
        },
        label: Text('Save'),
        style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6C5DD3)),
        ),
      ],
    );
  }
}