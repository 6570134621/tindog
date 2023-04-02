import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NumbersWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    Future<QuerySnapshot> getUserData() {
      return FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: uid).get();
    }
    return FutureBuilder<QuerySnapshot>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          } else if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
            print("data['photo'] : ${data['photo']}");
            print("data['photo'].length : ${data['photo'].length}");
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildButton(context, data['photo'].length.toString(), 'Total dogs'),
                buildDivider(),
                buildButton(context, 'null', 'Active dogs'),
                buildDivider(),
                buildButton(context, '4.7', 'Rating'),
              ],
            );
          }
          return Center(child: CircularProgressIndicator(),);
        }
    );
  }
  Widget buildDivider() => Container(
    height: 24,
    child: VerticalDivider(),
  );

  Widget buildButton(BuildContext context, String value, String text) {
    return MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
  }
}


