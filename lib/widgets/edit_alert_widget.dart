import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryphive/pages/edit_notification_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditAlertWidget extends StatefulWidget {

  final String alertID, title, description, condition, symbol, symbolID;
  final bool initialized;
  final num price;
  final inputDate;

  const EditAlertWidget({
    super.key,
    required this.alertID,
    required this.title,
    required this.description,
    required this.condition,
    required this.symbol,
    required this.symbolID,
    required this.initialized,
    required this.price,
    required this.inputDate,
  });

  @override
  State<EditAlertWidget> createState() => _EditAlertWidgetState();
}

class _EditAlertWidgetState extends State<EditAlertWidget> {

  final User? user = FirebaseAuth.instance.currentUser;

  TextEditingController priceController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future uploadToFirebase() async{
    try{
      await FirebaseFirestore.instance.collection('Users').doc(user?.uid.toString()).collection('Notifications').doc(widget.alertID).set({
        'Condition' : widget.condition.toString(),
        'Description' : descriptionController.text.toString(),
        'Initialized' : widget.initialized,
        'InputDate' : widget.inputDate,
        'Price' : num.parse(priceController.text),
        'Symbol': widget.symbol.toString(),
        'SymbolID': widget.symbolID.toString(),
        'Title': titleController.text.toString(),
      });
    } catch (e){
      print(e);
    }
  }

  @override
  void initState() {
    titleController.text = widget.title.toString();
    descriptionController.text = widget.description.toString();
    priceController.text = widget.price.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Edit Alert',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Input Title'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Input Description'),
            ),
            TextFormField(
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Input Price'),
            ),
            const SizedBox(height: 2.0,),
            const Divider(color: Colors.black87,),
          ],
        ),
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
          onPressed: () {
            String userInput = priceController.text;
            if (userInput.isNotEmpty) {
              uploadToFirebase();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const EditNotificationPage(),),);
            }
          },
        ),
      ],
    );
  }
}
