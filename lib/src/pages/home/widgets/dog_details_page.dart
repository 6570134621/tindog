import 'package:bangkaew/src/chat/chatpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bangkaew/src/pages/home/widgets/ProfileWidget.dart';
import 'package:bangkaew/src/pages/home/widgets/another_profile.dart';
import 'package:bangkaew/src/config/theme.dart' as custom_theme;
class DogDetailsPage extends StatefulWidget {
  final Map<String, dynamic> dogData;
  final String ownerUid;

  DogDetailsPage({required this.dogData, required this.ownerUid});

  @override
  State<DogDetailsPage> createState() => _DogDetailsPageState();
}

class _DogDetailsPageState extends State<DogDetailsPage> {
  Future<Map<String, dynamic>> getUserData(String uid) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    DocumentSnapshot userSnapshot =
        await _firestore.collection('users').doc(uid).get();

    return userSnapshot.data() as Map<String, dynamic>;
  }

  Future<QuerySnapshot> UserData() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: widget.ownerUid)
        .get();
  }

  String getStatusEmoji(String status) {
    switch (status) {
      case 'ready_to_breed':
        return '🟢';
      case 'unavailable':
        return '🔴';
      case 'have_a_mating_pair':
        return '🟡';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: custom_theme.Theme.gradient,
          ),
        ),
        title: Text('Dog Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dog information
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.285,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                      image: DecorationImage(
                        image: NetworkImage(
                          widget.dogData['image'],
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dog Name: ${widget.dogData['dogName']}',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[800]),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Status: ${getStatusEmoji(widget.dogData['dogStatus'])}',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueGrey[700]),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Gender: ${widget.dogData['dogGender']}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey[700]),
                        ),
                        Text(
                          'Species: ${widget.dogData['dogSpecies']}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey[700]),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Age: ${widget.dogData['dogAge']}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey[700]),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Description: ${widget.dogData['dogDescription']}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.blueGrey[600]),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Owner information
              Text(
                'Owner Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800],
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      offset: Offset(1.5, 1.5),
                      blurRadius: 3.0,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8),
              FutureBuilder<QuerySnapshot>(
                future: UserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data = snapshot.data!.docs.first.data()
                        as Map<String, dynamic>;
                    print("data : ${data}");
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),
                            Row(
                              children: [
                                ClipOval(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Ink.image(
                                      image: NetworkImage(
                                          data['ProfileImage'] != null
                                              ? data['ProfileImage']
                                              : 'https://cdn-icons-png.flaticon.com/512/3616/3616929.png'
                                      ),
                                      fit: BoxFit.cover,
                                      width: 128,
                                      height: 128,
                                      child: InkWell(onTap: () {}),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Name: ${data['Name']}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.blueGrey[700])),
                                      SizedBox(height: 8),
                                      Text('Email: ${data['Email']}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.blueGrey[700])),
                                      SizedBox(height: 8),
                                      Text('Phone: ${data['Tel']}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.blueGrey[700])),
                                      SizedBox(height: 16),
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      anotherProfile(
                                                    ownerUid: data['uid'], // แทนที่ด้วย uid ของเจ้าของจริง
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text('View Profile'),
                                          ),
                                          SizedBox(width: 8),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatPage(
                                                        id: data['uid'],
                                                        name: data['Name'],
                                                      )
                                                ),
                                              );
                                            },
                                            child: Text('Chat'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
