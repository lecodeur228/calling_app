import 'package:calling_app/screens/call_screen.dart';
import 'package:calling_app/services/firebase_services.dart';
import 'package:calling_app/widgets/contact_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic> userData = {};
  TextEditingController callIDController = TextEditingController();
  String error = '';
  @override
  void initState() {
    super.initState();
    fetchUserData().then((data) {
      setState(() {
        userData = data!;
      });
    });
  }

  Future<Map<String, dynamic>?> fetchUserData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where('email', isEqualTo: user!.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        Map<String, dynamic> userData =
            documentSnapshot.data() as Map<String, dynamic>;

        return userData;
      } else {
        return null;
      }
    } catch (error) {
      print(
          "Erreur lors de la récupération des données de l'utilisateur : $error");
    }
    return null;
  }

  searchCall(context) async {
    if (callIDController.text.isNotEmpty) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where('ID', isEqualTo: callIDController.text)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot resultat = querySnapshot.docs.first;
        Map<String, dynamic> Data = resultat.data() as Map<String, dynamic>;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => CallScreen(
                    name: userData['displayName'],
                    userId: userData['uid'],
                    callId: Data['ID']))));
      } else {
        showDialog(
            context: context,
            builder: ((context) {
              return const AlertDialog(
                content: SizedBox(
                  height: 200,
                  child: Center(
                    child: Text(
                      "Ce ID n'existe",
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            }));
      }
    } else {
      setState(() {
        error = "Le champ est vide";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(userData['photoURL']),
                        )),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${userData['displayName']}",
                        style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Text(
                        "ID: ${userData['ID']}",
                        style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance.signOut();
                          // L'utilisateur est maintenant déconnecté
                        } catch (e) {
                          // Gérer les erreurs de déconnexion
                          print('Erreur de déconnexion : $e');
                        }
                      },
                      icon: const Icon(
                        Icons.logout_outlined,
                        color: Colors.red,
                      ))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: callIDController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: "Identifiant de l'appel"),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        searchCall(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(17),
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(8)),
                        child: const Icon(
                          Icons.videocam,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Contacts",
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .where('email', isNotEqualTo: user!.email)
                      .snapshots(),
                  builder: ((context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blueAccent,
                        ),
                      );
                    }
                    final documents = snapshot.data!.docs;

                    return Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          final document = documents[index];
                          final data = document.data();
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ContactsItem(
                              porfileImgUrl: document['photoURL'],
                              name: document['displayName'],
                              id: document['ID'],
                              uid: document['uid'],
                              userName: userData['displayName'],
                              userUid: userData['uid'],
                            ),
                          );
                        },
                      ),
                    );
                  })),
            ],
          ),
        ),
      ),
    );
  }
}
