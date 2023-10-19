import 'package:cryphive/pages/login_page.dart';
import 'package:cryphive/pages/navigation_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication Terminal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return NavigationPage(index: 0,);
          }
          else if(snapshot.hasError){
            return const Center(child: Text('Something Went Wrong :('),);
          }
          else if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: LoadingIndicator(
                  colors: [Colors.red, Colors.green, Colors.blue, Colors.yellow],
                  indicatorType: Indicator.ballPulseSync,
                ),
              ),
            );
          }
          else{
            return const LoginPage();
          }
        },
      ),
    );
  }
}
