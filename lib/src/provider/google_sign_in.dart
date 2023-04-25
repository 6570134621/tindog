import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Google Sign in
  signInWithGoogle() async {
    // begin interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // obtain auth detail from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken:  gAuth.accessToken,
      idToken: gAuth.idToken
    );

    // sign in with credential
    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    // get user object
    final User? user = userCredential.user;

    // get uid of user
    final uid = user!.uid;
    // finally, let sign in
    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'Name' : gUser.displayName,
      'Email' : gUser.email,
      'Tel' : 'No data',
      'ProfileImage' : gUser.photoUrl,
      'Job' : 'No data',
      'Age' : '0',
      'uid' : uid,
      'about' : "Add something about you",
      'date_time': DateTime.now(),
      'photo' : {},
    });
    return await FirebaseAuth.instance.signInWithCredential(credential);

  }
}