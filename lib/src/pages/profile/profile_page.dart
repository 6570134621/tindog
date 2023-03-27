import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tindog/src/pages/home/get_user_name.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;

  // document IDs
  List<String> docIDs = [];

  // get docIDs
  // Future getDocId() async {
  //   await FirebaseFirestore.instance.collection('users').get().then(
  //         (snapshot) => snapshot.docs.forEach((element) {
  //       print("print element: ${element.reference}");
  //       docIDs.add(element.reference.id);
  //     }),
  //   );
  // }
  
  Future getUserData() async {
    await FirebaseFirestore.instance.collection('users').where('uid').where('uid', isEqualTo: user.uid).get().then(
            (snapshot) => snapshot.docs.forEach((element) {
              print("print element: ${element.reference}");
              docIDs.add(element.reference.id);
            }));
  }
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
          "Profile",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder(
                  future: getUserData(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                        itemCount: docIDs.length,
                        itemBuilder: (context, index) {
                          print("docIDs is : ${docIDs}");
                          return ListTile(
                            title: GetUserName(documentId: docIDs[index],),
                          );
                        });
                  },
                ))
          ],
        ),
      ),
    );
  }
}