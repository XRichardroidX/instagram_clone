import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/models/user.dart' as model;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'storage_methods.dart';

class AuthMethods {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection('user').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  // sign up user
Future<String> signupUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
}) async{
  String res = "Some error occurred";
  try {
    if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty ||
        bio.isNotEmpty) {
      // register the user
      UserCredential credentials = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print(credentials.user!.uid);

      String photoUrl = await StorageMethods().uploadImageToStorage(
          'profilePics', file, false);

      // Add User to database.

      model.User user = model.User(
        username: username,
        uid: credentials.user!.uid,
        email: email,
        bio: bio,
        followers: [],
        following: [],
        photoUrl: photoUrl,
      );

      await _firestore.collection('users').doc(credentials.user!.uid).set(user.toJson(),);


      res = "success";
    }
  }
   catch(err){
    res = err.toString();
  }
  return res;
}

// logging in Users
Future<String> loginUser({
  required String email,
  required String password
}) async {
  String res = "Some error occured";

  try{
    if(email.isNotEmpty || password.isNotEmpty){
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = "success";
    }
    else{
      res = "Please enter all the fields";
    }
  }
  catch(err){
    res = err.toString();
  }
  return res;
}
}