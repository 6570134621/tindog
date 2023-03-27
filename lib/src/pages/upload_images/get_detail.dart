
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetDetail extends StatelessWidget {
  final String documentId;
  const GetDetail({Key? key, required this.documentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(documentId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            return Text('Name : ${data['Name']},\n'
                'Email : ${data['Email']},\n'
                'Age : ${data['Age']},\n'
                'Job : ${data['Job']},\n'
                'Phone Number : ${data['Tel']}\n');
          }
          return Text("Loading ....");
        });
  }
}
