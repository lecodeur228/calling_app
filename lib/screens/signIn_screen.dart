import 'package:calling_app/screens/home_screen.dart';
import 'package:calling_app/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: InkWell(
          onTap: () async {
            showDialog(
                context: context,
                builder: ((context) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.amberAccent,
                    ),
                  );
                }));
            try {
              UserCredential? userCredential =
                  await FirebaseServices.signInWithGoogle();
              final QuerySnapshot result = await FirebaseFirestore.instance
                  .collection("users")
                  .where('id', isEqualTo: userCredential.user!.uid)
                  .get();
              final List<DocumentSnapshot> documents = result.docs;
              if (documents.isEmpty) {
                await FirebaseServices.saveUserDataToFirestore(
                    userCredential.user!);
              }
              // Utilisateur connecté avec succès et les données sont sauvegardées dans Firestore
            } catch (e) {
              print(e);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              "assets/images/google.png",
              width: 80,
            ),
          ),
        ),
      )),
    );
  }
}
