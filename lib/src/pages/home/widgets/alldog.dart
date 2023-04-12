import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tindog/src/bloc/species/species_bloc.dart';
import 'package:tindog/src/pages/home/widgets/dog_details_page.dart';

class DogGrid extends StatefulWidget {
  const DogGrid({Key? key}) : super(key: key);

  @override
  State<DogGrid> createState() => _DogGridState();
}

class _DogGridState extends State<DogGrid> {
  FirebaseFirestore firestoreRef = FirebaseFirestore.instance;

  // firestoreRef ใช้เข้าถึง Firestore ในโปรเจ็กต์ปัจจุบัน ใช้ในการเข้าถึงเอกสารและคอลเล็กชันใน Firestore
  FirebaseStorage storageRef = FirebaseStorage.instance;
  // ใช้อัพโหลด และดาวน์โหลดไฟล์จาก firebase storage
  String collectionName = "users";
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    String getRandomEmoji() {
      List<String> emojis = ["🐾", "🐕", "🦮", "🐩", "🐶"];
      int randomIndex = Random().nextInt(emojis.length);
      return emojis[randomIndex];
    }
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: BlocBuilder<SpeciesBloc, SpeciesState>(
                builder: (context, state) {
                  return FutureBuilder<QuerySnapshot>(

                    future: firestoreRef.collection(collectionName).get(),
                    builder: (context, snapshot) {
                      print("state.species :::: ${state.species}");
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData && snapshot.data!.docs.length > 0) {
                        List<DocumentSnapshot> arrData = snapshot.data!.docs;
                        // สร้าง List ที่จะเก็บข้อมูลที่คุณต้องการแสดง
                        List<Map<String, dynamic>> allPhotoData = [];

                        // วนลูปเพื่อดึงข้อมูลจากทุก id
                        for (var doc in arrData) {

                          if (doc.get('photo') != null){

                            Map<String, dynamic> photoData = doc['photo']; // ได้ข้อมูลรูปทั้งหมดของแต่ละ user
                            for (var photoKey in photoData.keys) {
                              //print("photoData[photoKey] : ${photoData[photoKey]['dogSpecies']}");
                              if(photoData[photoKey]['dogSpecies'] == state.species) {

                                allPhotoData.add(photoData[photoKey]);
                              } else if(state.species == 'All'){
                                allPhotoData.add(photoData[photoKey]);
                              }
                            }
                          }
                        }

                        //print(arrData[0]['photo']['0']['dogName']);
                        return ListView.builder(
                            itemCount: allPhotoData.length,
                            itemBuilder: (context, index) {
                              print("state.species ก่อนเข้า if:::: ${state.species}");
                              //if (state.species == 'All' || allPhotoData[index]['dogSpecies'] == state.species) {
                                print("state.species :::: ${state.species}");
                                print("allPhotoData[index]['Owwner'].toString(): ${allPhotoData[index]['Owwner']}");
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DogDetailsPage(
                                          dogData: allPhotoData[index],
                                          ownerUid: allPhotoData[index]['Owwner'], // แทนที่ด้วย uid ของเจ้าของจริง
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    margin: EdgeInsets.all(8),
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Image.network(
                                              allPhotoData[index]['image'],
                                              height: 120,
                                              width: 135,
                                              fit: BoxFit.fill,
                                              loadingBuilder: (context, child, loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                } else {
                                                  return Center(
                                                    child: CircularProgressIndicator(
                                                      value: loadingProgress.expectedTotalBytes != null
                                                          ? loadingProgress.cumulativeBytesLoaded /
                                                          loadingProgress.expectedTotalBytes!
                                                          : null,
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                Container(
                                                width: double.infinity, // กำหนดความกว้างของ Container ให้เท่ากับพื้นที่ในแนวนอนทั้งหมด
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text.rich(
                                                        TextSpan(
                                                          children: [
                                                            WidgetSpan(child: Text("🏷️ : ", style: TextStyle(fontSize: 16))),
                                                            TextSpan(
                                                              text: "${allPhotoData[index]['dogName']} ",
                                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Align(

                                                      alignment: Alignment.centerRight,
                                                      child: Text(allPhotoData[index]['dogStatus'] == 'ready_to_breed' ? '🟢' :
                                                        (allPhotoData[index]['dogStatus'] == 'unavailable' ? '🔴' : '🟡'))
                                                      ),

                                                  ],
                                                ),
                                              ),


                                                SizedBox(height: 3),
                                                  Text.rich(
                                                    TextSpan(
                                                      children: [
                                                        TextSpan(text: "Gender: "),
                                                        TextSpan(
                                                          text: allPhotoData[index]['dogGender'],
                                                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                                        ),
                                                        WidgetSpan(
                                                          child: allPhotoData[index]['dogGender'] == 'male'
                                                              ? Icon(Icons.male, size: 14, color: Colors.grey[600])
                                                              : Icon(Icons.female, size: 14, color: Colors.grey[600]),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  SizedBox(height: 6),
                                                  Text.rich(
                                                    TextSpan(
                                                      children: [
                                                        TextSpan(text: "Species: "),
                                                        TextSpan(
                                                          text: allPhotoData[index]['dogSpecies'],
                                                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  SizedBox(height: 6),
                                                  Text.rich(
                                                      TextSpan(
                                                        children : [
                                                          TextSpan(text: "Age: "),
                                                          TextSpan(
                                                              text: allPhotoData[index]['dogAge'].toString(),
                                                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                                          ),
                                                        ]
                                                      ),
                                                  ),
                                                  SizedBox(height: 6),
                                                  Text.rich(
                                                    TextSpan(
                                                        children : [
                                                          TextSpan(text: "Address: "),
                                                          TextSpan(
                                                            text: allPhotoData[index]['address'] != null
                                                                ? allPhotoData[index]['address'].toString()
                                                                : "No information"
                                                            ,
                                                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                                          ),
                                                        ]
                                                    ),
                                                  ),
                                                  SizedBox(height: 6),
                                                  Text.rich(
                                                    TextSpan(
                                                      children: [
                                                        TextSpan(text: "Info: "),
                                                        TextSpan(
                                                          text: allPhotoData[index]['dogDescription'].length > 30
                                                              ? allPhotoData[index]['dogDescription'].substring(0, 30) + '...'
                                                              : allPhotoData[index]['dogDescription'],
                                                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );

                              // }
                            }
                        );

                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  );
                }
              )
          )
        ],
      ),
    );
  }
}
      // body: GridView.builder(
      //   //itemCount: dogs.length,
      //   itemCount: 3,
      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //     crossAxisCount: 2,
      //     crossAxisSpacing: 8,
      //     mainAxisSpacing: 8,
      //   ),
      //   itemBuilder: (context, index) {
      //     final dog = dogs[index];
      //     return Container(
      //       decoration: BoxDecoration(
      //         color: Colors.white,
      //         borderRadius: BorderRadius.circular(16),
      //         boxShadow: [
      //           BoxShadow(
      //             color: Colors.grey.withOpacity(0.5),
      //             spreadRadius: 2,
      //             blurRadius: 5,
      //             offset: Offset(0, 3),
      //           ),
      //         ],
      //       ),
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: [
      //           Image.asset(dog.image, height: 100),
      //           Text(dog.name),
      //           Text(dog.breed),
      //           Text('${dog.age} years old'),
      //         ],
      //       ),
      //     );
      //   },
      // ),

