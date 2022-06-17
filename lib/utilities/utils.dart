import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:video_player/video_player.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  
  if(_file != null){
    return await _file.readAsBytes();
  }
  print('No image selected');
}

showSnackBar(String content, BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}