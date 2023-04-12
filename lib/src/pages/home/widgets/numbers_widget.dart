import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NumbersWidget extends StatefulWidget {
  final String uid;
  const NumbersWidget({ required this.uid});
  @override
  State<NumbersWidget> createState() => _NumbersWidgetState();
}

class _NumbersWidgetState extends State<NumbersWidget> {
  int count_ready = 0;
  int count_unavailable = 0;
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    Future<QuerySnapshot> getUserData() {
      return FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: widget.uid).get();
    }
    return FutureBuilder<QuerySnapshot>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          } else if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
            data['photo'].forEach((key, value){
              print("${value['dogStatus']}");
              if (value['dogStatus'] == 'ready_to_breed'){
                count_ready += 1;
              } else if (value['dogStatus'] == 'unavailable') {
                count_unavailable += 1;
              }
            });
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildButton(context, data['photo'].length.toString(), 'Total dogs'),
                buildDivider(),
                buildButton(context, count_ready.toString() , 'Active dogs'),
                buildDivider(),
                buildButton(context, count_unavailable.toString() , 'Unavailable'),
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


