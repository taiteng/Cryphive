import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();

  void signIn() async{
    // try{
    //   await FirebaseAuth.instance.signInWithEmailAndPassword(
    //     email: emailController.text,
    //     password: passwordController.text,
    //   );
    //
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HiddenDrawer(pageNum: 0,)));
    // } on FirebaseAuthException catch (e) {
    //   if(e.code == 'user-not-found'){
    //     showDialog(
    //       context: context,
    //       builder: (context) {
    //         return const AlertDialog(
    //           backgroundColor: Colors.pinkAccent,
    //           title: Text('Incorrect Email'),
    //         );
    //       },
    //     );
    //   }
    //   else if(e.code == 'wrong-password'){
    //     showDialog(
    //       context: context,
    //       builder: (context) {
    //         return const AlertDialog(
    //           backgroundColor: Colors.pinkAccent,
    //           title: Text('Incorrect Password'),
    //         );
    //       },
    //     );
    //   }
    // }
    await FirebaseFirestore.instance.collection('Users').doc('Test').set({
      'Email' : 'test',
      'Phone' : 'test',
      'Username' : 'test',
      'ProfilePic' : 'https://media.istockphoto.com/id/1316420668/vector/user-icon-human-person-symbol-social-profile-icon-avatar-login-sign-web-user-symbol.jpg?s=612x612&w=0&k=20&c=AhqW2ssX8EeI2IYFm6-ASQ7rfeBWfrFFV4E87SaFhJE=',
    });
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // if (_formKey.currentState!.validate()) {
            //   signIn();
            // }
            signIn();
          }, child: null,
        ),
      ),
    );
  }
}
