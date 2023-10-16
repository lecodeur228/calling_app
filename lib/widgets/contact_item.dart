import 'package:calling_app/screens/call_screen.dart';
import 'package:flutter/material.dart';

class ContactsItem extends StatelessWidget {
  const ContactsItem(
      {super.key,
      required this.porfileImgUrl,
      required this.name,
      required this.id,
      required this.uid, required this.userName, required this.userUid});

  final String porfileImgUrl;
  final String name;
  final String userName;
  final String id;
  final String uid;
  final String userUid;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(porfileImgUrl,),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              "ID: $id",
              style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ],
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) =>
                            CallScreen(name: userName, userId: userUid, callId: id))));
              },
              icon: const Icon(
                Icons.videocam,
                size: 25,
                color: Colors.lightBlue,
              )),
        ),
      ],
    );
  }
}
