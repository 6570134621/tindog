import 'dart:io';
import 'package:bangkaew/src/config/theme.dart' as custom_theme;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bangkaew/src/pages/home/widgets/ProfileWidget.dart';
import 'package:bangkaew/src/pages/home/widgets/another_profile.dart';

class InfoAMyDog extends StatefulWidget {
  final Map<String, dynamic> dogData;
  final String ownerUid;
  final int index;

  InfoAMyDog(
      {required this.dogData, required this.ownerUid, required this.index});

  @override
  State<InfoAMyDog> createState() => _InfoAMyDogState();
}

class _InfoAMyDogState extends State<InfoAMyDog> {
  String imageName = '';
  XFile? imagePath;
  TextEditingController nameDogController = TextEditingController();
  TextEditingController ageDogController = TextEditingController();
  TextEditingController speciesDogController = TextEditingController();
  TextEditingController statusDogController = TextEditingController();
  TextEditingController descriptionDogController = TextEditingController();
  TextEditingController descriptionDogAddress = TextEditingController();
  String? _selectedStatus;
  FirebaseStorage StorageRef = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  String? showImg;
  String? uid = FirebaseAuth.instance.currentUser?.uid;

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
  void initState() {
    super.initState();
    nameDogController.text = widget.dogData['dogName'];
    ageDogController.text = widget.dogData['dogAge'].toString();
    speciesDogController.text = widget.dogData['dogSpecies'];
    statusDogController.text = widget.dogData['dogStatus'];
    descriptionDogController.text = widget.dogData['dogDescription'];
    descriptionDogAddress.text = widget.dogData['address'];
    showImg = widget.dogData['image'];
  }

  @override
  Widget build(BuildContext context) {
    print('showImg : ${showImg}');
    print('รูปภาพนี้คือ index ลำดับที่ ${widget.index.toString()}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Dog Details'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: custom_theme.Theme.gradient,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _uploadImg();
              Navigator.pop(context);
            },
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

          ),
          SizedBox(
              width: 3), // เพิ่มระยะห่างระหว่างปุ่ม Save และขอบขวาของ AppBar
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dog image and upload button
              Stack(
                children: [
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
                            image: imagePath != null
                                ? FileImage(File(imagePath!.path))
                                    as ImageProvider<Object>
                                : NetworkImage(widget.dogData['image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 20,
                    child: FloatingActionButton(
                      child: Icon(Icons.camera_alt),
                      onPressed: () {
                        imagePicker();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Dog information
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
                    _buildTextFormField(
                        'dogName', 'Name', Icons.pets, 1, nameDogController),
                    SizedBox(
                      height: 15,
                    ),
                    _buildTextFormField('dogAge', 'Age',
                        Icons.watch_later_outlined, 1, ageDogController),
                    SizedBox(
                      height: 15,
                    ),
                    _buildTextFormField('dogSpecies', 'Species',
                        Icons.nature_people, 1, speciesDogController),
                    SizedBox(
                      height: 15,
                    ),
                    _buildTextFormField('address', 'Address',
                        Icons.home, 1, descriptionDogAddress),
                    SizedBox(
                      height: 15,
                    ),
                    _buildTextFormField('dogDescription', 'Description',
                        Icons.description, 2, descriptionDogController),

                    SizedBox(height: 8),
                    buildSelectedStatus(),
                    // Add more TextFormField widgets for other fields
                    // TODO: Save changes to the other fields
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildSelectedStatus() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Status   ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          DropdownButton<String>(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            //dropdownColor: Color(0xFFF2DEBA),
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
          SizedBox(height: 20),
        ],
      ),
    );
  }

  TextFormField _buildTextFormField(String info, String text, IconData theIcon,
      int num_line, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      //initialValue: widget.dogData[info],
      style: TextStyle(fontSize: 18),
      maxLines: num_line,
      decoration: InputDecoration(
        labelText: text,
        labelStyle: TextStyle(fontSize: 16, color: Colors.blueGrey[800]),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        hintText: 'Enter dog name',
        hintStyle: TextStyle(color: Colors.blueGrey[400]),
        prefixIcon: Icon(theIcon, color: Colors.blueGrey[800]),
        contentPadding: EdgeInsets.symmetric(
            vertical: 18.0, horizontal: 10.0), // เพิ่มความสูงของ TextFormField
      ),
      // TODO: Save changes to dogName
    );
  }

  imagePicker() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imagePath = image;
        imageName = imagePath!.name.toString();
        print('imagePath!.path : ${imagePath!.path}');
      });
    }
  }

  Future<void> _uploadImg() async {
    String uploadFileName =
        DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
    Reference reference = StorageRef.ref().child('users').child(uploadFileName);
    UploadTask uploadTask = reference.putFile(File(imagePath!.path));

    await uploadTask.whenComplete(() async {
      var uploadPath = await uploadTask.snapshot.ref.getDownloadURL();
      print("this is uploadPath : ${uploadPath}");

      if (uploadPath.isNotEmpty) {
        DocumentSnapshot userSnapshot =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        Map<String, dynamic> allPhoto =
            Map<String, dynamic>.from(userSnapshot['photo']);
        allPhoto[widget.index.toString()] = {
          'dogName': nameDogController.text.toString(),
          'dogAge': int.parse(ageDogController.text),
          'dogSpecies': speciesDogController.text.toString().toLowerCase(),
          'address': descriptionDogAddress.text.toString().toLowerCase(),
          'dogDescription': descriptionDogController.text.toString(),
          'dogStatus': _selectedStatus.toString(),
          'Owwner': uid,
          'image': uploadPath
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .update({'photo': allPhoto}).then((value) {
          print('Map field updated successfully!');
        }).catchError((error) {
          print('Error updating map field: $error');
        });
      }
    });
  }
}
