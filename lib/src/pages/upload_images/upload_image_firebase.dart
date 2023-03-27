import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:faker/faker.dart';


class UploadsImage extends StatefulWidget {
  const UploadsImage({Key? key}) : super(key: key);

  @override
  State<UploadsImage> createState() => _UploadsImageState();
}

class _UploadsImageState extends State<UploadsImage> {
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
  //var dogGenderController = new TextEditingController();
  FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
  // firestoreRef ใช้เข้าถึง Firestore ในโปรเจ็กต์ปัจจุบัน ใช้ในการเข้าถึงเอกสารและคอลเล็กชันใน Firestore
  FirebaseStorage storageRef = FirebaseStorage.instance; // ใช้อัพโหลด และดาวน์โหลดไฟล์จาก firebase storage
  String collectionName = "users";
  bool _isLoading = false;
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
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: _isLoading ?
          Center(child: CircularProgressIndicator()) : Column(
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
                controller: dogSpeciesController,
                decoration: InputDecoration(
                    labelText: "Species", border: OutlineInputBorder()
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
              SizedBox(height: 12,),
              //OutlinedButton(onPressed: (){}, child: Text("Submit")),
              ElevatedButton(onPressed: (){
                _uploadImage();
              }, child: Text("Submit")),
            ],
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
      print(event.bytesTransferred.toString() + "\t" + event.totalBytes.toString());

    });

    await uploadTask.whenComplete(() async {
      var uploadPath = await uploadTask.snapshot.ref.getDownloadURL();
      print("this is uploadPath : ${uploadPath}");
      // Upload image to Firebase Storage
      //final uploadTask = storageRef.child("images/${Path.basename(imageFile.path)}").putFile(imageFile);
      // [name, age, species, gender, description, image]
      // Add all data to a single Map object
      Map<int, List<String>> myMap ;
      List<String> theDog = [
        dogNameController.text,
        dogAgeController.text,
        dogSpeciesController.text,
        dogGenderController.text,
        descriptionController.text,
        uploadPath
      ];
      print("This is theDogList");
      print(theDog);
      //print("this is theDog :");
      //print(theDog);
      // insert record inside database regarding url
      if(uploadPath.isNotEmpty) {
        DocumentReference docRef = await firestoreRef.collection(collectionName).doc(getCurrentUserUid());
        DocumentSnapshot docSnap = await docRef.get();
        final data = docSnap.data() as Map<dynamic, dynamic>;
        print(data);
        print("data.containsKey('dogName') : ${data.containsKey('dogName')}");
        print("at first time data.containsKey('myMap') : ${data.containsKey('myMap')}");
         if (data.containsKey('photo')) {
           // อ่านข้อมูลที่มีอยู่จาก Firestore
           DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(getCurrentUserUid()).get();

           Map<String, dynamic> allPhoto = Map<String, dynamic>.from(userSnapshot['photo']);
           allPhoto[allPhoto.length.toString()] = {
             'dogName': dogNameController.text.toString(),
             'dogAge': dogAgeController.text.toString(),
             'dogSpecies': dogSpeciesController.text.toString(),
             'dogGender': dogGenderController.text.toString(),
             'dogDescription': descriptionController.text.toString(),
             'image' : uploadPath
           };

            await FirebaseFirestore.instance.collection('users').doc(getCurrentUserUid()).update({
               'photo' : allPhoto
             }).then((value) {
               print('Map field updated successfully!');
             }).catchError((error) {
               print('Error updating map field: $error');
             });

           } else {
             FirebaseFirestore.instance.collection('users').doc(getCurrentUserUid()).update({
               'photo' : {
                 '0' : {
                   'dogName' : dogNameController.text,
                   'dogAge' : dogAgeController.text,
                   'dogSpecies' : dogSpeciesController.text,
                   'dogGender' : dogGenderController.text,
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

        // ทำการอัปเดตค่าใน Firestore
        // FirebaseFirestore.instance.collection('users').doc(getCurrentUserUid()).update({
        //   'myMap': myMap
        // }).then((value) {
        //   print('Map field updated successfully!');
        // }).catchError((error) {
        //   print('Error updating map field: $error');
        // });


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
