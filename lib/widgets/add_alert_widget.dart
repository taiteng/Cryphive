import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddAlertWidget extends StatelessWidget {

  final String symbol;
  final String id;

  AddAlertWidget({
    super.key,
    required this.symbol,
    required this.id,
  });

  final User? user = FirebaseAuth.instance.currentUser;

  TextEditingController priceController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String selectedSymbol = 'Crossing';

  Future uploadToFirebase() async{
    try{
      await FirebaseFirestore.instance.collection('Users').doc(user?.uid.toString()).collection('Notifications').add({
        'Condition' : 'Crossing',
        'Description' : descriptionController.text.toString(),
        'Initialized' : false,
        'InputDate' : Timestamp.fromDate(DateTime.now()),
        'Price' : num.parse(priceController.text),
        'Symbol': symbol.toString(),
        'SymbolID': id.toString(),
        'Title': titleController.text.toString(),
      });
    } catch (e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Add Alert',
        style: TextStyle(
          fontSize: 18,
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
            const SizedBox(height: 12.5,),
            const Text(
              'Choose Symbol: ',
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
            DropdownButton<String>(
              value: selectedSymbol,
              onChanged: (String? newValue) {
                selectedSymbol = newValue ?? 'Crossing';
              },
              items: <String>['Crossing', 'Coming Soon',].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
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
            }
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
