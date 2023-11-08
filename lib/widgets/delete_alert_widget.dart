import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryphive/pages/edit_notification_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

class DeleteAlertWidget extends StatefulWidget {

  final String alertID;

  const DeleteAlertWidget({
    super.key,
    required this.alertID,
  });

  @override
  State<DeleteAlertWidget> createState() => _DeleteAlertWidgetState();
}

class _DeleteAlertWidgetState extends State<DeleteAlertWidget> {

  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> deleteFromNotification() async{
    final alertRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(user?.uid.toString())
        .collection("Notifications")
        .doc(widget.alertID);

    try{
      await alertRef.delete();
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Delete Alert',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const Text(
        'Are you sure you want to delete?',
        style: TextStyle(
          fontSize: 15,
        ),
      ),
      actions: <Widget>[
        SlideAction(
          borderRadius: 12,
          elevation: 0,
          innerColor: Colors.red,
          outerColor: Colors.yellow,
          sliderButtonIcon: const Icon(
            Icons.delete_outline_rounded,
            color: Color(0xff151f2c),
          ),
          sliderRotate: false,
          text: 'Slide to Delete',
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
          onSubmit: () {
            deleteFromNotification();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const EditNotificationPage()));
          },
        ),
      ],
    );
  }
}
