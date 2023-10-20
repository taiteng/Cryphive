import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryphive/widgets/delete_alert_widget.dart';
import 'package:cryphive/widgets/edit_alert_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loading_indicator/loading_indicator.dart';

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
    CollectionReference _alertDetails = FirebaseFirestore.instance
        .collection('Users')
        .doc(user?.uid.toString())
        .collection('Notifications');

    Size size = MediaQuery.of(context).size;

    return FutureBuilder<DocumentSnapshot>(
      future: _alertDetails.doc(widget.alertID).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          Timestamp firebaseTimestamp = data['InputDate'];
          DateTime dateTime = firebaseTimestamp.toDate();

          return Padding(
            padding: const EdgeInsets.only(
              top: 5.0,
              bottom: 5.0,
            ),
            child: Slidable(
              startActionPane: ActionPane(
                motion: const StretchMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return EditAlertWidget(
                            alertID: widget.alertID,
                            title: data['Title'],
                            description: data['Description'],
                            condition: data['Condition'],
                            symbol: data['Symbol'],
                            symbolID: data['SymbolID'],
                            initialized: data['Initialized'],
                            price: data['Price'],
                            inputDate: data['InputDate'],
                          );
                        },
                      );
                    },
                    icon: Icons.edit_rounded,
                    backgroundColor: Colors.green,
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DeleteAlertWidget(
                            alertID: widget.alertID,
                          );
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
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return EditAlertWidget(
                            alertID: widget.alertID,
                            title: data['Title'],
                            description: data['Description'],
                            condition: data['Condition'],
                            symbol: data['Symbol'],
                            symbolID: data['SymbolID'],
                            initialized: data['Initialized'],
                            price: data['Price'],
                            inputDate: data['InputDate'],
                          );
                        },
                      );
                    },
                    icon: Icons.edit_rounded,
                    backgroundColor: Colors.green,
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DeleteAlertWidget(
                            alertID: widget.alertID,
                          );
                        },
                      );
                    },
                    icon: Icons.delete_forever_rounded,
                    backgroundColor: Colors.red,
                  ),
                ],
              ),
              child: Container(
                width: size.width,
                height: size.height * 0.25,
                decoration: const BoxDecoration(
                  color: Color(0xff151f2c),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: size.width * 0.45,
                      height: size.height * 0.225,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(25)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Symbol:",
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              data['Symbol'],
                            ),
                            const Text(
                              "SymbolID:",
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              data['SymbolID'],
                            ),
                            const Text(
                              "Condition:",
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              data['Condition'],
                            ),
                            const Text(
                              "Price:",
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              data['Price'].toString(),
                            ),
                            Text(
                              dateTime.toString(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.45,
                      height: size.height * 0.225,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(25)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Title:",
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              data['Title'],
                            ),
                            const Text(
                              "Description:",
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                            Text(
                              data['Description'],
                            ),
                            const Text(
                              "Initialized:",
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              data['Initialized'].toString(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: LoadingIndicator(
                colors: [Colors.red, Colors.green, Colors.blue, Colors.yellow],
                indicatorType: Indicator.ballClipRotateMultiple,
              ),
            ),
          );
        }
      }),
    );
  }
}
