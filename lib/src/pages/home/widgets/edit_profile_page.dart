import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tindog/src/pages/home/get_user_name.dart';
import 'package:tindog/src/pages/home/widgets/ProfileWidget.dart';
import 'package:tindog/src/pages/home/widgets/textfield_widget.dart';
import 'package:tindog/src/config/route.dart' as custom_route;
class EditProfilePage extends StatefulWidget {
  final String? imageURL;
  const EditProfilePage(this.imageURL, {Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController jobController;
  late final TextEditingController telController;
  late final TextEditingController aboutController;
  FirebaseStorage StorageRef = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String imageName = '';
  XFile? imagePath;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? _imageURL;

  Future<QuerySnapshot> getUserData() {
    return FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: user!.uid).get();
  }
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    jobController = TextEditingController();
    telController = TextEditingController();
    aboutController = TextEditingController();
    _imageURL = widget.imageURL;
  }
  // @override
  // void dispose() {
  //   nameController.dispose();
  //   emailController.dispose();
  //   jobController.dispose();
  //   telController.dispose();
  //   aboutController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    print("FirebaseAuth.instance.currentUser! : ${user}");
    print('-----------------------------------------');

    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder<QuerySnapshot> (
                future: getUserData(),
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator(),);
                  } else if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
                    return ListView(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      physics: BouncingScrollPhysics(),
                      children: [
                        SizedBox(height: 14,),
                        // ProfileWidget(
                        //   imagePath: _imageFile == null
                        //     ? 'https://cdn.pixabay.com/animation/2022/08/09/00/46/00-46-39-186_512.gif'
                        //     : Image.file(_imageFile),
                        //   isEdit: true,
                        //   onClicked: (){
                        //     _modalPickerImage();
                        //   },
                        //),
                        _buildPreviewImage(),
                        _buildPickerImage(),

                        SizedBox(height: 14,),
                        TextFieldWidget(
                          label: 'Full Name',
                          text: data['Name'],
                          onChanged: (name) {},
                          controller: nameController,
                        ),
                        const SizedBox(height: 14),
                        TextFieldWidget(
                          label: 'Email',
                          text: data['Email'],
                          onChanged: (email) {},
                          controller: emailController,
                        ),
                        const SizedBox(height: 14),
                        TextFieldWidget(
                          label: 'Job',
                          text: data['Job'],
                          onChanged: (email) {},
                          controller: jobController,
                        ),
                        const SizedBox(height: 14),
                        TextFieldWidget(
                          label: 'Phone Number',
                          text: data['Tel'],
                          onChanged: (email) {},
                          controller: telController,
                        ),
                        const SizedBox(height: 14),
                        TextFieldWidget(
                          label: 'About',
                          text: "add something for someone",
                          maxLines: 4,
                          onChanged: (about) {},
                          controller: aboutController,

                        ),
                      ],
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }
              )
          ),
        ],
      )
    );
  }

  AppBar buildAppBar() {
    return AppBar(
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
        "Edit Profile",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      actions: [
        ElevatedButton.icon(
        icon: FaIcon(FontAwesomeIcons.save),
        onPressed: (){
          final String name = nameController.text;
          final String email = emailController.text;
          final String job = jobController.text;
          final String tel = telController.text;
          final String about = aboutController.text;
          _uploadImg();
          print('Name: $name');
          print('email: $email');
          print('job: $job');
          print('tel: $tel');
          print('about: $about');
        },
        label: Text('Save'),
        style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6C5DD3)),
        ),
      ],
    );
  }

  OutlinedButton _buildPickerImage() => OutlinedButton.icon(
    onPressed: () {
      _modalPickerImage();
    },
    style: OutlinedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      backgroundColor: Colors.white,
      side: BorderSide(width: 0, color: Colors.transparent),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    label: Text('image'),
    icon: FaIcon(FontAwesomeIcons.image),
  );

  void _modalPickerImage() {
    final buildListTile = (IconData icon, String title, ImageSource imageSource) => ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        _pickImage(imageSource);
      },
    );
   showModalBottomSheet(
       context: context, 
       builder: (builder) => SafeArea(
           child: Column(
             mainAxisSize: MainAxisSize.min,
             children: <Widget>[
               buildListTile(
                 Icons.photo_camera,
                 "Take a picture from camera",
                 ImageSource.camera
               ),
               buildListTile(
                 Icons.photo_library,
                 "Choose from photo library",
                 ImageSource.gallery
               )
             ],
           )
       )
    );
  }

  void _pickImage(ImageSource imageSource) {
    _picker.pickImage(
      source: imageSource,
      imageQuality: 70,
      maxHeight: 500,
      maxWidth: 500
    ).then((file) {
      if(file != null){
        _cropImage(file.path);
      }
    });
  }

  void _cropImage(String file) {
    ImageCropper().cropImage(
      sourcePath: file,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    ).then((file) {
      if (file != null) {
        setState(() {
          _imageFile = File(file.path);
          //widget.callBack(_imageFile);
          _imageURL = null;
        });
      }
    });
  }

  dynamic _buildPreviewImage() {
    if ((_imageURL == null || _imageURL!.isEmpty) && _imageFile == null) {
      return SizedBox();
    }
    
    final container = (Widget child) => Container(
      margin: EdgeInsets.only(top: 4),
      alignment: Alignment.center,
      height: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[100],
      ),
      child: child
    );
    return _imageURL != null
        ? container(Image.network(_imageURL!))
        : Stack(
      children: [
        container(Image.file(File(_imageFile!.path))),
        _buildDeleteImageButton(),
      ],
    );
  }

  Positioned _buildDeleteImageButton() => Positioned(
      right: 0,
      child: IconButton(
        onPressed: () {
          setState(() {
            _imageFile = null;
          });
          print('กดปุ่ม _buildDeleteImageButton()');
          print("_imageFile : ${_imageFile}");
        },
        icon: Icon(
          Icons.clear,
          color: Colors.black54,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      )
  );

  Future<void> _uploadImg() async {
    String uploadFileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
    Reference reference = StorageRef.ref().child('users').child(uploadFileName);
    UploadTask uploadTask = reference.putFile(_imageFile!);

    final String name = nameController.text;
    final String email = emailController.text;
    final String job = jobController.text;
    final String tel = telController.text;
    final String about = aboutController.text;

    await uploadTask.whenComplete(() async {
      var uploadPath = await uploadTask.snapshot.ref.getDownloadURL();
      print("this is uploadPath from edit porfile: ${uploadPath}");

      if(uploadPath.isNotEmpty) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'Name' : name,
          'Email' : email,
          'Tel' : tel,
          'Job' : job,
          'about' : about,
          'ProfileImage' : uploadPath
        }).then((value) {
          print("edit account");
          Navigator.pushNamed(context, custom_route.Route.home);
        });


      }
    });
  }

}