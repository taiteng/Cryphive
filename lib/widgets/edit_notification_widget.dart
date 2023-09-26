import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryphive/widgets/delete_alert_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class EditNotificationWidget extends StatefulWidget {
  final String alertID;

  const EditNotificationWidget({
    super.key,
    required this.alertID,
  });

  @override
  State<EditNotificationWidget> createState() => _EditNotificationWidgetState();
}

class _EditNotificationWidgetState extends State<EditNotificationWidget> {

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {

    CollectionReference _alertDetails = FirebaseFirestore.instance.collection('Notification').doc(user?.uid.toString()).collection('Alerts');

    return FutureBuilder<DocumentSnapshot>(
      future: _alertDetails.doc(widget.alertID).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0,),
            child: Slidable(
              startActionPane: ActionPane(
                motion: const StretchMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {

                    },
                    icon: Icons.edit_rounded,
                    backgroundColor: Colors.green,
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DeleteAlertWidget(alertID: widget.alertID,);
                        },
                      );
                    },
                    icon: Icons.delete_forever_rounded,
                    backgroundColor: Colors.red,
                  ),
                ],
              ),
              endActionPane: ActionPane(
                motion: const StretchMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {

                    },
                    icon: Icons.edit_rounded,
                    backgroundColor: Colors.green,
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DeleteAlertWidget(alertID: widget.alertID,);
                        },
                      );
                    },
                    icon: Icons.delete_forever_rounded,
                    backgroundColor: Colors.red,
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Symbol: ${data['Symbol']}"),
                    Text("SymbolID: ${data['SymbolID']}"),
                    Text("Title: ${data['Title']}"),
                    Text("Description: ${data['Description']}"),
                    Text("Condition: ${data['Condition']}"),
                    Text("Price: ${data['Price']}"),
                    Text("Initialized: ${data['Initialized']}"),
                    Text("InputDate: ${data['InputDate']}"),
                  ],
                ),
              ),
            ),
          );
        }
        else{
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xffFBC700),
            ),
          );
        }
      }),
    );
  }
}
