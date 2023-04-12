import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class WTD extends StatefulWidget {
  const WTD({Key? key}) : super(key: key);

  @override
  _WTDState createState() => _WTDState();
}

class _WTDState extends State<WTD> {

  late File _image;
  late List _results;
  bool imageSelect=false;
  @override
  void initState()
  {
    super.initState();
    loadModel();
  }
  Future loadModel()
  async {
    Tflite.close();
    String res;
    res=(await Tflite.loadModel(model: "assets/model/modelV1.tflite",labels: "assets/model/my_labels_breeds.txt"))!;
    print("Models loading status: $res วันอังคาร");
  }

  Future imageClassification(File image)
  async {
    final List? recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _results=recognitions!;
      _image=image;
      imageSelect=true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          (imageSelect) ? Card(
            margin: const EdgeInsets.fromLTRB(16, 15, 16, 10),
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)),
            child: Container(
              padding: EdgeInsets.all(6),
              child: Image.file(
                  _image,
                  width: 200, // กำหนดความกว้างของภาพ
                  height: 350, // กำหนดความสูงของภาพ
                  fit: BoxFit.contain,
              ),
            ),
          ):Container(
            margin: const EdgeInsets.all(20),
            child: const Opacity(
              opacity: 0.8,
              child: Center(
                child: Text(
                    "Select a picture of a dog for breed analysis 🔎",
                    style: TextStyle(color: Colors.black,
                        fontSize: 18, fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: (imageSelect)?_results.map((result) {
                return Card(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "${result['label']} :  ${(result['confidence']*100).toStringAsFixed(2)} %",
                      style: const TextStyle(color: Colors.black,
                          fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  ),
                );
              }).toList():[],

            ),
          )
        ],
      ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 16, right: 16),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: OutlinedButton(
              onPressed: pickImage,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('What species :  ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                  const Icon(Icons.image),
                ],
              ),
            ),
          ),
        ),

    );
  }
  Future pickImage()
  async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    File image=File(pickedFile!.path);
    imageClassification(image);
  }
}