import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bangkaew/src/constants/api.dart';

class ProductImage extends StatefulWidget {
  final Function(File? imageFile) callBack;
  final String? imageURL;

  const ProductImage(this.callBack, this.imageURL);

  @override
  _ProductImageState createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  //final _picker = ImagePicker();
  String? _imageURL;

  @override
  void initState() {
    _imageURL = widget.imageURL;
    super.initState();
  }

  @override
  void dispose() {
    _imageFile?.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPickerImage(),
          _buildPreviewImage(),
        ],
      ),
    );
  }

  OutlinedButton _buildPickerImage() => OutlinedButton.icon(
    onPressed: () {
      _modalPickerImage();
    },
    label: Text('image'),
    icon: FaIcon(FontAwesomeIcons.image),
  );

  dynamic _buildPreviewImage() {
    if ((_imageURL == null || _imageURL!.isEmpty) && _imageFile == null) {
      return SizedBox();
    }

    final container = (Widget child) => Container(
      color: Colors.grey[100],
      margin: EdgeInsets.only(top: 4),
      alignment: Alignment.center,
      height: 350,
      child: child,
    );

    return _imageURL != null
        ? container(Image.network('${API.IMAGE_URL}/$_imageURL'))
        : Stack(
      children: [
        container(Image.file(_imageFile!)),
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
          widget.callBack(null);
        });
      },
      icon: Icon(
        Icons.clear,
        color: Colors.black54,
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    ),
  );

  void _modalPickerImage() {
    final buildListTile = (IconData icon, String title, ImageSource imageSource) => ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: () {
          Navigator.pop(context);
          _pickImage(imageSource);
        },
      );

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildListTile(
              Icons.photo_camera,
              "Take a picture from camera",
              ImageSource.camera,
            ),
            buildListTile(
              Icons.photo_library,
              "Choose from photo library",
              ImageSource.gallery,
            )
          ],
        ),
      ),
    );
  }

  void _pickImage(ImageSource imageSource) {
    _picker.pickImage(
      source: imageSource,
      imageQuality: 70,
      maxHeight: 500,
      maxWidth: 500,
    )
        .then((file) {
      if (file != null) {
        _cropImage(file.path);
        // setState(() {
        //   _imageFile = File(file.path);
        //   widget.callBack(_imageFile);
        // });
      }
    });
  }
//final file = File(xFile.path);
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
          widget.callBack(_imageFile);
          _imageURL = null;
        });
      }
    });
  }
}
