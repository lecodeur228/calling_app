import 'dart:math';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {
  static Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<void> saveUserDataToFirestore(User user) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    String generateRandomID() {
      Random random = Random();
      String id = '';
      for (int i = 0; i < 5; i++) {
        id += random
            .nextInt(10)
            .toString(); // Génère un chiffre aléatoire de 0 à 9
      }
      return id;
    }

    String randomID = generateRandomID();
    users.add({
      'uid': user.uid,
      'displayName': user.displayName,
      'email': user.email,
      'photoURL': user.photoURL,
      'ID': randomID,
    }).catchError((error) => print("Failed to add user: $error"));
  }
}
