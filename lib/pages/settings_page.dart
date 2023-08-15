import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryphive/pages/disclaimer_page.dart';
import 'package:cryphive/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference _user = FirebaseFirestore.instance.collection('Users');

  void signOut() async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage(),),);
  }

  TextStyle headingStyle = const TextStyle(
      fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red,
  );

  TextStyle headingStyleIOS = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: CupertinoColors.inactiveGray,
  );

  TextStyle descStyleIOS = const TextStyle(color: CupertinoColors.inactiveGray,);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xff151f2c),
      appBar: AppBar(
        elevation: 0.00,
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 40,
        toolbarOpacity: 0.8,
        backgroundColor: const Color(0xff151f2c),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(12),
          alignment: Alignment.center,
          child: FutureBuilder<DocumentSnapshot>(
            future: _user.doc(user?.uid.toString()).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              }
              else if (snapshot.hasData && !snapshot.data!.exists) {
                return const Text("Username does not exist");
              }
              else if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data = snapshot.data!.data() as Map<
                    String,
                    dynamic>;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Profile",
                          style: headingStyle,
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(data['ProfilePic']),
                    ),
                    const SizedBox(height: 10,),
                    ListTile(
                      leading: const Icon(
                        Icons.email,
                        color: Colors.deepOrange,
                      ),
                      title: Text(
                        data['UID'],
                        style: const TextStyle(color: Colors.white,),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.copy,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          buildSnack(
                            'User ID has been copied to clipboard',
                            context,
                            size,
                          );
                        },
                      ),
                    ),
                    const Divider(color: Color(0xff3c3c3f),),
                    ListTile(
                      leading: const Icon(
                        Icons.email,
                        color: Colors.deepOrange,
                      ),
                      title: Text(
                        data['Email'],
                        style: const TextStyle(color: Colors.white,),
                      ),
                    ),
                    const Divider(color: Color(0xff3c3c3f),),
                    ListTile(
                      leading: const Icon(
                        Icons.account_circle,
                        color: Colors.deepOrange,
                      ),
                      title: Text(
                        data['Username'],
                        style: const TextStyle(color: Colors.white,),
                      ),
                    ),
                    const Divider(color: Color(0xff3c3c3f),),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Account", style: headingStyle),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        //Edit Notification
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.edit_notifications,
                          color: Colors.deepOrange,
                        ),
                        title: Text(
                          'Edit Notifications',
                          style: const TextStyle(color: Colors.white,),
                        ),
                      ),
                    ),
                    const Divider(color: Color(0xff3c3c3f),),
                    GestureDetector(
                      onTap: () {
                        //Edit Profile
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.edit,
                          color: Colors.deepOrange,
                        ),
                        title: Text(
                          'Edit Profile',
                          style: const TextStyle(color: Colors.white,),
                        ),
                      ),
                    ),
                    const Divider(color: Color(0xff3c3c3f),),
                    GestureDetector(
                      onTap: () async {
                        signOut();
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: Colors.deepOrange,
                        ),
                        title: Text(
                          'Sign Out',
                          style: const TextStyle(color: Colors.white,),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Misc", style: headingStyle),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const DisclaimerPage()));
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.file_open_outlined,
                          color: Colors.deepOrange,
                        ),
                        title: Text(
                          "Terms of Service",
                          style: const TextStyle(color: Colors.white,),
                        ),
                      ),
                    ),
                    const Divider(color: Color(0xff3c3c3f),),
                    GestureDetector(
                      onTap: () {

                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.file_copy_outlined,
                          color: Colors.deepOrange,
                        ),
                        title: Text(
                          "Open Source and Licences",
                          style: const TextStyle(color: Colors.white,),
                        ),
                      ),
                    ),
                  ],
                );
              }
              else {
                return const Text("loading");
              }
            },
          ),
        ),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildSnack(
      String error, context, size) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black,
        content: SizedBox(
          height: size.height * 0.02,
          child: Center(
            child: Text(error),
          ),
        ),
      ),
    );
  }
}
