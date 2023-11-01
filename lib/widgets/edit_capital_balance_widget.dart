import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryphive/pages/navigation_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditCapitalBalanceWidget extends StatefulWidget {

  final String email;
  final String username;
  final String profilePic;
  final String uID;
  final num capitalBalance;

  const EditCapitalBalanceWidget({
    super.key,
    required this.email,
    required this.username,
    required this.profilePic,
    required this.uID,
    required this.capitalBalance,
  });

  @override
  State<EditCapitalBalanceWidget> createState() => _EditCapitalBalanceWidgetState();
}

class _EditCapitalBalanceWidgetState extends State<EditCapitalBalanceWidget> {

  final User? user = FirebaseAuth.instance.currentUser;

  TextEditingController capitalController = TextEditingController();

  Future uploadToFirebase() async{
    try{
      if(widget.capitalBalance == capitalController.text){
        await FirebaseFirestore.instance.collection('Users').doc(user?.uid.toString()).set({
          'Email' : widget.email.toString(),
          'Username' : widget.username.toString(),
          'ProfilePic' : widget.profilePic.toString(),
          'LoginMethod' : 'Email',
          'UID' : widget.uID.toString(),
          'Capital': widget.capitalBalance,
        });
      }
      else{
        await FirebaseFirestore.instance.collection('Users').doc(user?.uid.toString()).set({
          'Email' : widget.email.toString(),
          'Username' : widget.username.toString(),
          'ProfilePic' : widget.profilePic.toString(),
          'LoginMethod' : 'Email',
          'UID' : widget.uID.toString(),
          'Capital': double.parse(capitalController.text.toString()),
        });
      }
    } catch (e){
      print(e);
    }
  }

  @override
  void initState() {
    capitalController.text = widget.capitalBalance.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Capital Balance',
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      content: TextField(
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ],
        controller: capitalController,
        decoration: const InputDecoration(labelText: 'Input Capital'),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text(
            'Submit',
            style: TextStyle(
              color: Colors.green,
            ),
          ),
          onPressed: () async {
            String userInput = capitalController.text;
            if (userInput.isNotEmpty) {
              uploadToFirebase();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => NavigationPage(index: 4,)));
            }
            else{
              await Flushbar(
                title: 'Input Error',
                titleSize: 14,
                titleColor: Colors.white,
                message: 'User\'s Input Error',
                messageSize: 12,
                messageColor: Colors.white,
                duration: const Duration(seconds: 3),
                icon: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                ),
                flushbarStyle: FlushbarStyle.FLOATING,
                reverseAnimationCurve: Curves.decelerate,
                forwardAnimationCurve: Curves.elasticOut,
                backgroundColor: Colors.black,
              ).show(context);
            }
          },
        ),
      ],
    );
  }
}
