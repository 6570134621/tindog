import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tindog/src/pages/home/widgets/ProfileWidget.dart';
import 'package:tindog/src/pages/home/widgets/edit_profile_page.dart';
import 'package:tindog/src/pages/mydog/info_a_mydog.dart';

class MyDogFirebasePage extends StatefulWidget {
  const MyDogFirebasePage({super.key});

  @override
  State<MyDogFirebasePage> createState() => _MyDogFirebasePageState();
}

class _MyDogFirebasePageState extends State<MyDogFirebasePage> {
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
        appBar: AppBar(
          title: Text('Modern GridView'),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                  future: getUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data = snapshot.data!.docs.first
                          .data() as Map<String, dynamic>;
                      //print("data['photo'] at mydog_firebase : ${data['photo']}");
                      //print("snapshot.data!.docs.first : ${snapshot.data!.docs.first}");
                      List<dynamic> infoDog = data['photo'].values.toList();
                      print("infoDog : ${infoDog}");
                      return ModernGridView(data: infoDog);
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            )
          ],
        ));
  }
}

class ModernGridView extends StatefulWidget {
  final List<dynamic> data;
  const ModernGridView({super.key, required this.data});

  @override
  State<ModernGridView> createState() => _ModernGridViewState();
}

class _ModernGridViewState extends State<ModernGridView> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(5),
      itemCount: widget.data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InfoAMyDog(
                  index: index,
                  dogData: widget.data[index],
                  ownerUid: FirebaseAuth.instance.currentUser!
                      .uid, // แทนที่ด้วย uid ของเจ้าของจริง
                ),
              ),
            );
          },
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5, // กำหนดระดับเงาของ Card
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.network(
                    widget.data[index]['image']!,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(
                                  child: Text("🏷️ : ",
                                      style: TextStyle(fontSize: 16))),
                              TextSpan(
                                text: widget.data[index]['dogName'],
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Text(widget.data[index]['dogStatus'] ==
                                  'ready_to_breed'
                              ? '🟢'
                              : (widget.data[index]['dogStatus'] ==
                                      'unavailable'
                                  ? '🔴'
                                  : '🟡'))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
