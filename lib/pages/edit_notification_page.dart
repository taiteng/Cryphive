import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryphive/widgets/edit_notification_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class EditNotificationPage extends StatefulWidget {
  const EditNotificationPage({super.key});

  @override
  State<EditNotificationPage> createState() => _EditNotificationPageState();
}

class _EditNotificationPageState extends State<EditNotificationPage> {

  final User? user = FirebaseAuth.instance.currentUser;

  List<String> _alertIDs = [];

  Future getAlertIDs() async{
    await FirebaseFirestore.instance.collection('Notification').doc(user?.uid.toString()).collection('Alerts').get().then(
          (snapshot) => snapshot.docs.forEach((alertID) {
        if (alertID.exists) {
          _alertIDs.add(alertID.reference.id);
        } else {
          print("Ntg to see here");
        }
      }),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xff090a13),
      appBar: AppBar(
        elevation: 0.00,
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 40,
        toolbarOpacity: 0.8,
        backgroundColor: const Color(0xff151f2c),
        title: const Text(
          'NOTIFICATION',
          style: TextStyle(
            color: Colors.yellowAccent,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: SizedBox(
                height: size.height * 0.05,
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: size.width,
                      height: size.height * 0.1,
                      decoration: const BoxDecoration(
                        color: Color(0xff151f2c),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(45),
                          bottomRight: Radius.circular(45),
                        ),
                      ),
                      child: const Text(
                        'Slide to Action',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: getAlertIDs(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          snapshot.error.toString(),
                        ),
                      );
                    } else if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _alertIDs.length,
                        itemBuilder: (context, index){
                          return EditNotificationWidget(alertID: _alertIDs[index],);
                        },
                      );
                    }
                    else {
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
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
