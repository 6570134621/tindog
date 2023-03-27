// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:tindog/src/models/product.dart';
// import 'package:tindog/src/pages/home/widgets/ProductItem.dart';
// import 'package:tindog/src/services/network_service.dart';
// import 'package:tindog/src/config/route.dart' as custom_route;
// class AllDog extends StatefulWidget {
//   const AllDog({Key? key}) : super(key: key);
//
//   @override
//   State<AllDog> createState() => _AllDogState();
// }
//
// class _AllDogState extends State<AllDog> {
//   final _spacing = 4.0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _buildNetwork(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushNamed(context, custom_route.Route.management)
//               .then((value) {
//             setState(() {});
//           });
//         },
//         child: FaIcon(FontAwesomeIcons.plus),
//       ),
//     );
//   }
//
//   FutureBuilder<List<Product>> _buildNetwork() {
//     return FutureBuilder<List<Product>>(
//       future: NetworkService().getAllProduct(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           List<Product>? product = snapshot.data;
//           if (product == null || product.isEmpty) {
//             return Container(
//               margin: EdgeInsets.only(top: 22),
//               alignment: Alignment.topCenter,
//               child: Text('No data'),
//             );
//           }
//           return RefreshIndicator(
//             onRefresh: () async {
//               setState(() {});
//             },
//             child: _buildProductGridView(product),
//           );
//         }
//         if (snapshot.hasError) {
//           return Container(
//             margin: EdgeInsets.only(top: 22),
//             alignment: Alignment.topCenter,
//             child: Text('Error: ${snapshot.error}'),
//           );
//         }
//         return Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );
//   }
//
//   GridView _buildProductGridView(List<Product> products) {
//     return GridView.builder(
//       padding: EdgeInsets.only(
//         left: _spacing,
//         right: _spacing,
//         top: _spacing,
//         bottom: 150,
//       ),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: 0.8,
//         crossAxisSpacing: _spacing,
//         mainAxisSpacing: _spacing,
//       ),
//       itemBuilder: (context, index) => LayoutBuilder(
//         builder: (context, BoxConstraints constraints) {
//           final product = products[index];
//           return ProductItem(
//             constraints.maxHeight,
//             product,
//             onTap: () {
//               Navigator.pushNamed(
//                 context,
//                 custom_route.Route.management,
//                 arguments: product,
//               ).then((value) {
//                 setState(() {});
//               });
//             },
//           );
//         },
//       ),
//       itemCount: products.length,
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Dog {
  final String name;
  final String breed;
  final int age;
  final String image;

  Dog({
    required this.name,
    required this.breed,
    required this.age,
    required this.image,
  });
}

final List<Dog> dogs = [
  Dog(
    name: 'Buddy',
    breed: 'Beagle',
    age: 5,
    image: 'assets/images/beagle.jpeg',
  ),
  Dog(
    name: 'Max',
    breed: 'German Shepherd',
    age: 3,
    image: 'assets/images/pitbull.jpeg',
  ),
  Dog(
    name: 'Lucy',
    breed: 'Beagle',
    age: 2,
    image: 'assets/images/beagle.jpeg',
  ),
  Dog(
    name: 'Daisy',
    breed: 'Golden Retriever',
    age: 4,
    image: 'assets/images/pitbull.jpeg',
  ),
  Dog(
    name: 'Charlie',
    breed: 'Pitbull',
    age: 7,
    image: 'assets/images/pitbull.jpeg',
  ),
  Dog(
    name: 'Rocky',
    breed: 'Siberian Husky',
    age: 6,
    image: 'assets/images/pitbull.jpeg',
  ),
];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: firestoreRef.collection(collectionName).get(),
                builder: (context, snapshot) {
                  print("print snapshot.hasData : ${snapshot.hasData}");
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData && snapshot.data!.docs.length > 0) {
                    List<DocumentSnapshot> arrData = snapshot.data!.docs;
                    // สร้าง List ที่จะเก็บข้อมูลที่คุณต้องการแสดง
                    List<Map<String, dynamic>> allPhotoData = [];
                    print("arrData = ${arrData}");
                    // วนลูปเพื่อดึงข้อมูลจากทุก id
                    for (var doc in arrData) {

                      if (doc.get('photo') != null){
                        print("name of user : ${doc['Name']}");
                        Map<String, dynamic> photoData = doc['photo']; // ได้ข้อมูลรูปทั้งหมดของแต่ละ user
                        for (var photoKey in photoData.keys) {
                          allPhotoData.add(photoData[photoKey]);
                          print('allPhotoData : ${allPhotoData}');
                        }
                      }
                    }

                    print("ข้อมูลใน allPhotoData : ${allPhotoData}");

                    print("print arrData.length : ${arrData.length}");
                    //print(arrData[0]['photo']['0']['dogName']);
                    return ListView.builder(
                      itemCount: allPhotoData.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Row(
                            children: [
                              Image.network(allPhotoData[index]['image'],
                              //Image.network('https://firebasestorage.googleapis.com/v0/b/tindog-405fa.appspot.com/o/users%2F1679503260575.jpg?alt=media&token=bbb7f3b5-7c6f-41cf-9973-7974714ab251',
                              height: 120,
                              width: 135,
                              fit: BoxFit.fill,
                                loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes! : null
                                    ),
                                  );
                                }
                                },
                              ),
                              SizedBox(width: 15,),
                              Container(
                                child: Column(
                                  children: [
                                    //Text(arrData[index]['photo'][index.toString()]['dogName']),
                                    Text(allPhotoData[index]['dogName']),
                                    Text(allPhotoData[index]['dogGender']),
                                    Text(allPhotoData[index]['dogSpecies']),
                                    Text(allPhotoData[index]['dogAge']),
                                    // Text(arrData[index]['photo'][index.toString()]['dogGender']),
                                    // Text(arrData[index]['photo'][index.toString()]['dogSpecies']),
                                    // Text(arrData[index]['photo'][index.toString()]['dogAge']),
                                    //
                                     Text(allPhotoData[index]['dogDescription'].length > 15 ? allPhotoData[index]['dogDescription'].substring(0,15) + '...' :
                                     allPhotoData[index]['dogDescription']),

                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    );
                        
                  }
                  return Center(child: CircularProgressIndicator());
                },
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

