import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryphive/pages/change_password_page.dart';
import 'package:cryphive/pages/contact_us_page.dart';
import 'package:cryphive/pages/disclaimer_page.dart';
import 'package:cryphive/pages/edit_notification_page.dart';
import 'package:cryphive/pages/edit_profile_page.dart';
import 'package:cryphive/pages/login_page.dart';
import 'package:cryphive/pages/manage_posts_page.dart';
import 'package:cryphive/pages/register_page.dart';
import 'package:cryphive/widgets/edit_capital_balance_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_indicator/loading_indicator.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference _user = FirebaseFirestore.instance.collection('Users');

  void deleteProfile() async{
    try{
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete Profile'),
            content: const Text("Are You Sure Want To Proceed ?"),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.done_rounded),
                color: Colors.green,
                onPressed: () async {
                  try {
                    QuerySnapshot notificationsQuerySnapshot = await _user.doc(user!.uid.toString()).collection('Notifications').get();
                    QuerySnapshot tradingJournalsQuerySnapshot = await _user.doc(user!.uid.toString()).collection('TradingJournals').get();
                    QuerySnapshot watchlistQuerySnapshot = await _user.doc(user!.uid.toString()).collection('Watchlist').get();

                    for (QueryDocumentSnapshot nDoc in notificationsQuerySnapshot.docs) {
                      if(nDoc.exists){
                        await nDoc.reference.delete();
                      }
                    }

                    for (QueryDocumentSnapshot tDoc in tradingJournalsQuerySnapshot.docs) {
                      if(tDoc.exists){
                        await tDoc.reference.delete();
                      }
                    }

                    for (QueryDocumentSnapshot wDoc in watchlistQuerySnapshot.docs) {
                      if(wDoc.exists){
                        await wDoc.reference.delete();
                      }
                    }

                    await _user.doc(user!.uid.toString()).delete();
                    await user?.delete();
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                  } catch (error) {
                    print(error.toString());
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.cancel_rounded),
                color: Colors.red,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (error) {
      print(error.toString());
    }
  }

  void signOut() async{
    try{
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Sign Out'),
            content: const Text("Are You Sure Want To Sign Out ?"),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.done_rounded),
                color: Colors.green,
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.cancel_rounded),
                color: Colors.red,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (error) {
      print(error.toString());
    }
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
      backgroundColor: const Color(0xff090a13),
      appBar: AppBar(
        elevation: 0.00,
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 40,
        toolbarOpacity: 0.8,
        backgroundColor: const Color(0xff151f2c),
        title: const Text(
          'SETTINGS',
          style: TextStyle(
            color: Colors.yellowAccent,
          ),
        ),
        leading: null,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(12),
          alignment: Alignment.center,
          child: user != null ? FutureBuilder<DocumentSnapshot>(
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
                      radius: 45,
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ManagePostsPage()));
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.comment_rounded,
                          color: Colors.deepOrange,
                        ),
                        title: Text(
                          'Manage Posts',
                          style: TextStyle(color: Colors.white,),
                        ),
                      ),
                    ),
                    const Divider(color: Color(0xff3c3c3f),),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return EditCapitalBalanceWidget(
                              email: data['Email'],
                              username: data['Username'],
                              profilePic: data['ProfilePic'],
                              uID: data['UID'],
                              capitalBalance: data['Capital'],
                            );
                          },
                        );
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.credit_card_rounded,
                          color: Colors.deepOrange,
                        ),
                        title: Text(
                          'Edit Capital Balance',
                          style: TextStyle(color: Colors.white,),
                        ),
                      ),
                    ),
                    const Divider(color: Color(0xff3c3c3f),),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const EditNotificationPage()));
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.edit_notifications,
                          color: Colors.deepOrange,
                        ),
                        title: Text(
                          'Manage Notifications',
                          style: TextStyle(color: Colors.white,),
                        ),
                      ),
                    ),
                    const Divider(color: Color(0xff3c3c3f),),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordPage()));
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.password_rounded,
                          color: Colors.deepOrange,
                        ),
                        title: Text(
                          'Edit Password',
                          style: TextStyle(color: Colors.white,),
                        ),
                      ),
                    ),
                    const Divider(color: Color(0xff3c3c3f),),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage(
                          email: data['Email'],
                          username: data['Username'],
                          profilePic: data['ProfilePic'],
                          uID: data['UID'],
                          capitalBalance: data['Capital'],
                        ),
                        ),);
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.edit,
                          color: Colors.deepOrange,
                        ),
                        title: Text(
                          'Edit Profile',
                          style: TextStyle(color: Colors.white,),
                        ),
                      ),
                    ),
                    const Divider(color: Color(0xff3c3c3f),),
                    GestureDetector(
                      onTap: () {
                        deleteProfile();
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.delete_forever_rounded,
                          color: Colors.deepOrange,
                        ),
                        title: Text(
                          'Delete Profile',
                          style: TextStyle(color: Colors.white,),
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
                          style: TextStyle(color: Colors.white,),
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
                          "Disclaimer",
                          style: TextStyle(color: Colors.white,),
                        ),
                      ),
                    ),
                    const Divider(color: Color(0xff3c3c3f),),
                    GestureDetector(
                      onTap: () {

                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.file_open_outlined,
                          color: Colors.deepOrange,
                        ),
                        title: Text(
                          "Terms of Service",
                          style: TextStyle(color: Colors.white,),
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
                          style: TextStyle(color: Colors.white,),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Help", style: headingStyle),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactUsPage()));
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.file_open_outlined,
                          color: Colors.deepOrange,
                        ),
                        title: Text(
                          "Contact Us",
                          style: TextStyle(color: Colors.white,),
                        ),
                      ),
                    ),
                  ],
                );
              }
              else {
                return const Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: LoadingIndicator(
                      colors: [Colors.red, Colors.green, Colors.blue, Colors.yellow],
                      indicatorType: Indicator.ballScale,
                    ),
                  ),
                );
              }
            },
          ) : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Profile",
                    style: headingStyle,
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              const ListTile(
                leading: Icon(
                  Icons.account_circle,
                  color: Colors.deepOrange,
                ),
                title: Text(
                  'Guest',
                  style: TextStyle(color: Colors.white,),
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
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RegisterPage()));
                  });
                },
                child: const ListTile(
                  leading: Icon(
                    Icons.create_rounded,
                    color: Colors.deepOrange,
                  ),
                  title: Text(
                    'Create An Account?',
                    style: TextStyle(color: Colors.white,),
                  ),
                ),
              ),
              const Divider(color: Color(0xff3c3c3f),),
              GestureDetector(
                onTap: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                  });
                },
                child: const ListTile(
                  leading: Icon(
                    Icons.login_rounded,
                    color: Colors.deepOrange,
                  ),
                  title: Text(
                    'Log In To A Account',
                    style: TextStyle(color: Colors.white,),
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
                    "Disclaimer",
                    style: TextStyle(color: Colors.white,),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Help", style: headingStyle),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactUsPage()));
                },
                child: const ListTile(
                  leading: Icon(
                    Icons.file_open_outlined,
                    color: Colors.deepOrange,
                  ),
                  title: Text(
                    "Contact Us",
                    style: TextStyle(color: Colors.white,),
                  ),
                ),
              ),
            ],
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
