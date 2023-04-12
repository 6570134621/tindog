import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:faker/faker.dart';


class UploadsImage extends StatefulWidget {
  const UploadsImage({Key? key}) : super(key: key);

  @override
  State<UploadsImage> createState() => _UploadsImageState();
}

class _UploadsImageState extends State<UploadsImage> {
  Future<List<String>> getBreed() async {
    String contents = await rootBundle.loadString('assets/model/my_labels_breeds.txt');

    List<String> breedList = [];

    for (var line in LineSplitter().convert(contents)) {
      // แปลงเป็นตัวพิมพ์เล็กและแทนที่ _ ด้วยช่องว่าง
      final breedName = line.toLowerCase().replaceAll('_', ' ');
      breedList.add(breedName);
    }
    return breedList;

  }
  List<String> _breedList = [];

  // document IDs
  List<String> docIDs = [];
  String imageName = "";
  XFile? imagePath;
  final ImagePicker _picker = ImagePicker();
  var descriptionController = new TextEditingController();
  var dogNameController = new TextEditingController();
  var dogAgeController = new TextEditingController();
  var dogSpeciesController = new TextEditingController();
  var dogGenderController = new TextEditingController();
  var addressController = new TextEditingController();
  String? _selectedStatus;
  String? _breed;
  //var dogGenderController = new TextEditingController();
  FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
  // firestoreRef ใช้เข้าถึง Firestore ในโปรเจ็กต์ปัจจุบัน ใช้ในการเข้าถึงเอกสารและคอลเล็กชันใน Firestore
  FirebaseStorage storageRef = FirebaseStorage.instance; // ใช้อัพโหลด และดาวน์โหลดไฟล์จาก firebase storage
  String collectionName = "users";
  bool _isLoading = false;
  @override

  @override
  void initState() {
    super.initState();

    getBreed().then((breeds) {
      breeds.insertAll(0, ['bulldog','pitbull','shiba']);
      setState(() {
        _breedList = breeds;
      });
    });
  }

  Widget build(BuildContext context) {
    print('_breedList = breeds : ${_breedList}');
    return Scaffold(
      backgroundColor: Color(0xFFFFEFD6),
      appBar: AppBar(
        backgroundColor: Color(0xFF3A8891),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0E5E6F),
                Color(0xFF3A8891),
              ],
            ),
          ),
        ),
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(18, 20, 18, 10),
            child: _isLoading ?
            Center(child: CircularProgressIndicator()) : Container(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    imageName == "" ? Container() : Text("${imageName}"),
                    OutlinedButton(onPressed: (){
                      imagePicker();
                    }, child: Text("Select Image")),
                    SizedBox(height: 12,),
                    TextFormField(
                      controller: dogNameController,
                      decoration: InputDecoration(
                          labelText: "Dog Name", border: OutlineInputBorder()
                      ),
                    ),
                    SizedBox(height: 12,),
                    TextFormField(
                      controller: dogAgeController,
                      decoration: InputDecoration(
                          labelText: "Age", border: OutlineInputBorder()
                      ),
                    ),
                    SizedBox(height: 12,),
                    TextFormField(
                      controller: dogGenderController,
                      decoration: InputDecoration(
                          labelText: "Gender", border: OutlineInputBorder()
                      ),
                    ),
                    SizedBox(height: 12,),
                    TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                          labelText: "Address", border: OutlineInputBorder()
                      ),
                    ),
                    SizedBox(height: 12,),
                    TextFormField(
                      controller: descriptionController,
                      minLines: 3,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: "Description", border: OutlineInputBorder()
                      ),
                    ),
                    SizedBox(height: 8,),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFF2DEBA),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownButton<String>(
                            dropdownColor: Color(0xFFF2DEBA),
                            value: _selectedStatus,
                            items: [
                              DropdownMenuItem<String>(
                                child: Text(
                                  'Ready to breed  🟢',
                                  style: TextStyle(fontSize: 16),
                                ),
                                value: 'ready_to_breed',
                              ),
                              DropdownMenuItem<String>(
                                child: Text(
                                  'Have a mating pair  🟡',
                                  style: TextStyle(fontSize: 16),
                                ),
                                value: 'have_a_mating_pair',
                              ),
                              DropdownMenuItem<String>(
                                child: Text(
                                  'Unavailable  🔴',
                                  style: TextStyle(fontSize: 16),
                                ),
                                value: 'unavailable',
                              ),
                            ],
                            onChanged: (String? value) {
                              setState(() {
                                _selectedStatus = value;
                              });
                            },
                            hint: Text(
                              'Choose status',
                              style: TextStyle(fontSize: 16),
                            ),
                            iconSize: 30,
                            elevation: 16,
                            style: TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                          DropdownButton<String>(
                            dropdownColor: Color(0xFFF2DEBA),
                            value: _breed,
                            items: _breedList.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _breed = value;
                              });
                            },
                            hint: Text(
                              'Choose breed 🐾',
                              style: TextStyle(fontSize: 16),
                            ),
                            iconSize: 30,
                            elevation: 16,
                            style: TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                          ),


                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _uploadImage();
                      },
                      child: Text('Add dog  🦴'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple,
                        onPrimary: Colors.white,
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  imagePicker () async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null){
      setState(() {
        imagePath = image;
        imageName = imagePath!.name.toString();
        print("imagePath : ${imagePath}");
        print("imageName : ${imageName}");
        print("DateTime.now().millisecondsSinceEpoch.toString() : ${DateTime.now().millisecondsSinceEpoch.toString()}");

      });
    }
  }

  _uploadImage() async {
    setState(() {
      _isLoading = true;
    });
    String uploadFileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
    Reference reference = storageRef.ref().child(collectionName).child(uploadFileName);
    UploadTask uploadTask = reference.putFile(File(imagePath!.path));

    uploadTask.snapshotEvents.listen((event) {
      print('event.bytesTransferred.toString()  + event.totalBytes.toString() : ${event.bytesTransferred.toString() + "\t" + event.totalBytes.toString()}');

    });

    await uploadTask.whenComplete(() async {
      var uploadPath = await uploadTask.snapshot.ref.getDownloadURL();
      print("this is uploadPath : ${uploadPath}");

      Map<int, List<String>> myMap ;
      List<String> theDog = [
        dogNameController.text,
        dogAgeController.text,
        dogSpeciesController.text,
        dogGenderController.text,
        addressController.text,
        descriptionController.text,
        uploadPath
      ];
      print("This is theDogList");
      print(theDog);

      if(uploadPath.isNotEmpty) {
        DocumentReference docRef = await firestoreRef.collection(collectionName).doc(getCurrentUserUid());
        DocumentSnapshot docSnap = await docRef.get();
        final data = docSnap.data() as Map<dynamic, dynamic>;
       // print(data);
       // print("data.containsKey('dogName') : ${data.containsKey('dogName')}");
       // print("at first time data.containsKey('myMap') : ${data.containsKey('myMap')}");
         if (data.containsKey('photo')) {
           // อ่านข้อมูลที่มีอยู่จาก Firestore
           DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(getCurrentUserUid()).get();

           Map<String, dynamic> allPhoto = Map<String, dynamic>.from(userSnapshot['photo']);
           allPhoto[allPhoto.length.toString()] = {
             'dogName': dogNameController.text.toString(),
             'dogAge': int.parse(dogAgeController.text),
             'dogSpecies': _breed.toString(),
             'dogGender': dogGenderController.text.toString(),
             'dogDescription': descriptionController.text.toString(),
             'dogStatus' : _selectedStatus.toString(),
             'address' : addressController.text.toString(),
             'Owwner' : getCurrentUserUid(),
             'image' : uploadPath
           };

            await FirebaseFirestore.instance.collection('users').doc(getCurrentUserUid()).update({
               'photo' : allPhoto
             }).then((value) {
               print('Map field updated successfully!');
               Navigator.pop(context);
             }).catchError((error) {
               print('Error updating map field: $error');
             });

           } else {
             FirebaseFirestore.instance.collection('users').doc(getCurrentUserUid()).update({
               'photo' : {
                 '0' : {
                   'dogName' : dogNameController.text,
                   'dogAge' : dogAgeController.text,
                   'dogSpecies': _breed.toString(),
                   'dogGender' : dogGenderController.text,
                   'address' : addressController.toString(),
                   'dogDescription' : descriptionController.text,
                   'image' : uploadPath
                 }
               }
             }).then((value) {
               print('Map field updated successfully!');
             }).catchError((error) {
               print('Error updating map field: $error');
             });
           }

      } else {
        _showMessage("Something While Uploading Image.");
      }
      setState(() {
        _isLoading = false;
      });
    });
  }


  String? getCurrentUserUid() {
    FirebaseAuth auth = FirebaseAuth.instance;

    // เข้าถึงข้อมูลของผู้ใช้ปัจจุบันที่ล็อกอินอยู่
    User? currentUser = auth.currentUser;

    // อ่านค่า UID จากผู้ใช้ปัจจุบัน (หากไม่มีผู้ใช้ล็อกอิน จะได้ค่าเป็น null)
    String? uid = currentUser?.uid;
    return uid;
  }
  _showMessage(String msg){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 3),
    ));
  }
  Future getUserData() async {
    await FirebaseFirestore.instance.collection('users').where('uid').where('uid', isEqualTo: getCurrentUserUid()).get().then(
            (snapshot) => snapshot.docs.forEach((element) {

          print("print element: ${element.reference}"); //print element: DocumentReference<Map<String, dynamic>>(users/DtRpCnMWUrVaLSvsGl9yyekyLo52)
          docIDs.add(element.reference.id);
          print("docIDs : ${docIDs}"); // docIDs : [DtRpCnMWUrVaLSvsGl9yyekyLo52]
        }));
  }
}
