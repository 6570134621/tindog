
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tindog/src/pages/home/widgets/ProfileWidget.dart';
import 'package:tindog/src/pages/home/widgets/button_widget.dart';
import 'package:tindog/src/pages/home/widgets/numbers_widget.dart';
import 'package:tindog/src/pages/home/widgets/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  Future<QuerySnapshot> getUserData() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
                future: getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(),);
                  } else if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
                    print("data : ${data}");
                    //print("snapshot.data!.docs.first : ${snapshot.data!.docs.first}");
                    return ListView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        const SizedBox(height: 24),
                        ProfileWidget(
                          imagePath: 'https://cdn.pixabay.com/photo/2023/03/15/04/30/joy-7853671_1280.jpg',
                          onClicked: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => EditProfilePage()),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        buildName(data['Name'], data['Email']),
                        const SizedBox(height: 24),
                        Center(child: buildbutton()),
                        const SizedBox(height: 24),
                        NumbersWidget(),
                        const SizedBox(height: 48),
                        buildAbout(data['about'] == null ? 'add some detail about you' : data['about']),
                      ],
                    );
                  } else {
                    return CircularProgressIndicator();
                  }

                }
            ),
          )
        ],
      )
    );
  }

  AppBar _buildAppBar() {
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
        "Profile",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildName(String user, String email) => Column(
    children: [
      Text(
          user,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      SizedBox(height: 4,),
      Text(
        email,
        style: TextStyle(color: Colors.grey),
      )
    ],
  );

  Widget buildbutton() => ButtonWidget(
    text: 'My Profile',
    onClicked: (){},
  );

  Widget buildAbout(String detail) => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          detail,
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
      ],
    ),
  );



}
