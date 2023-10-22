import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryphive/pages/disclaimer_page.dart';
import 'package:cryphive/pages/login_page.dart';
import 'package:cryphive/pages/navigation_page.dart';
import 'package:cryphive/widgets/button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool checkedValue = false;
  List textFieldsStrings = [
    "", //username
    "", //email
    "", //password
    "", //confirmPassword
  ];

  final _usernameKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  final _confirmPasswordKey = GlobalKey<FormState>();

  void signUp() async{
    try{

      if(textFieldsStrings[2] == textFieldsStrings[3]){

        //Don't need hashing because Firebase has the auto hashing function
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: textFieldsStrings[1],
          password: textFieldsStrings[2],
        );

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: textFieldsStrings[1],
          password: textFieldsStrings[2],
        );

        await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).set({
          'Email' : textFieldsStrings[1],
          'Username' : textFieldsStrings[0],
          'ProfilePic' : 'https://media.istockphoto.com/id/1316420668/vector/user-icon-human-person-symbol-social-profile-icon-avatar-login-sign-web-user-symbol.jpg?s=612x612&w=0&k=20&c=AhqW2ssX8EeI2IYFm6-ASQ7rfeBWfrFFV4E87SaFhJE=',
          'LoginMethod' : 'Email',
          'UID' : FirebaseAuth.instance.currentUser!.uid,
          'Balance': 0.00,
        });

        await Future.delayed(Duration.zero, () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => NavigationPage(index: 0,)));
        });
      }
      else{
        buildSnackError(
          'Passwords does not match',
          context,
          MediaQuery.of(context).size,
        );
      }
    } on FirebaseAuthException catch (e) {
      buildSnackError(
        e.code,
        context,
        MediaQuery.of(context).size,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Container(
          height: size.height,
          width: size.height,
          decoration: const BoxDecoration(
            color: Color(0xff151f2c),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.02),
                        child: Align(
                          child: Text(
                            'Hey there,',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: size.height * 0.02,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.015),
                        child: Align(
                          child: Text(
                            'Welcome Back',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: size.height * 0.025,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.01),
                      ),
                      Form(
                        child: buildTextField(
                          "Username",
                          Icons.person_outlined,
                          false,
                          size,
                              (valuename) {
                            if (valuename.length <= 0) {
                              buildSnackError(
                                'Invalid username',
                                context,
                                size,
                              );
                              return '';
                            }
                            return null;
                          },
                          _usernameKey,
                          0,
                        ),
                      ),
                      Form(
                        child: buildTextField(
                          "Email",
                          Icons.email_outlined,
                          false,
                          size,
                              (valuemail) {
                            if (valuemail.length < 5) {
                              buildSnackError(
                                'Invalid email',
                                context,
                                size,
                              );
                              return '';
                            }
                            if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+")
                                .hasMatch(valuemail)) {
                              buildSnackError(
                                'Invalid email',
                                context,
                                size,
                              );
                              return '';
                            }
                            return null;
                          },
                          _emailKey,
                          1,
                        ),
                      ),
                      Form(
                        child: buildTextField(
                          "Passsword",
                          Icons.lock_outline,
                          true,
                          size,
                              (valuepassword) {
                            if (valuepassword.length < 6) {
                              buildSnackError(
                                'Invalid password',
                                context,
                                size,
                              );
                              return '';
                            }
                            return null;
                          },
                          _passwordKey,
                          2,
                        ),
                      ),
                      Form(
                        child: buildTextField(
                          "Confirm Passsword",
                          Icons.lock_outline,
                          true,
                          size,
                              (valuepassword) {
                            if (valuepassword != textFieldsStrings[3]) {
                              buildSnackError(
                                'Passwords must match',
                                context,
                                size,
                              );
                              return '';
                            }
                            return null;
                          },
                          _confirmPasswordKey,
                          3,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.015,
                          vertical: size.height * 0.025,
                        ),
                        child: CheckboxListTile(
                          title: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                  "By creating an account, you have look at our ",
                                  style: TextStyle(
                                    color: const Color(0xffADA4A5),
                                    fontSize: size.height * 0.015,
                                  ),
                                ),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const DisclaimerPage()));
                                    },
                                    child: Text(
                                      "Disclaimer Statement",
                                      style: TextStyle(
                                        color: const Color(0xffADA4A5),
                                        decoration:
                                        TextDecoration.underline,
                                        fontSize: size.height * 0.015,
                                      ),
                                    ),
                                  ),
                                ),
                                TextSpan(
                                  text: ", and you agree to our ",
                                  style: TextStyle(
                                    color: const Color(0xffADA4A5),
                                    fontSize: size.height * 0.015,
                                  ),
                                ),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () {

                                    },
                                    child: Text(
                                      "Conditions of Use",
                                      style: TextStyle(
                                        color: const Color(0xffADA4A5),
                                        decoration:
                                        TextDecoration.underline,
                                        fontSize: size.height * 0.015,
                                      ),
                                    ),
                                  ),
                                ),
                                TextSpan(
                                  text: " and ",
                                  style: TextStyle(
                                    color: const Color(0xffADA4A5),
                                    fontSize: size.height * 0.015,
                                  ),
                                ),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () {
                                      // ignore: avoid_print
                                      print('Privacy Notice');
                                    },
                                    child: Text(
                                      "Privacy Notice",
                                      style: TextStyle(
                                        color: const Color(0xffADA4A5),
                                        decoration:
                                        TextDecoration.underline,
                                        fontSize: size.height * 0.015,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          activeColor: const Color(0xff7B6F72),
                          value: checkedValue,
                          onChanged: (newValue) {
                            setState(() {
                              checkedValue = newValue!;
                            });
                          },
                          controlAffinity:
                          ListTileControlAffinity.leading,
                        ),
                      ),
                      AnimatedPadding(
                        duration: const Duration(milliseconds: 500),
                        padding: EdgeInsets.only(top: size.height * 0.085),
                        child: ButtonWidget(
                          text: "Register",
                          backColor: [
                            Colors.black,
                            Colors.black,
                          ],
                          textColor: const [
                            Colors.white,
                            Colors.white,
                          ],
                          onPressed: () async {
                            if (_usernameKey.currentState!.validate()) {
                              if (_emailKey.currentState!.validate()) {
                                if (_passwordKey.currentState!.validate()) {
                                  if (_confirmPasswordKey.currentState!
                                      .validate()) {
                                    if (checkedValue == false) {
                                      buildSnackError(
                                          'Accept our Privacy Policy and Term Of Use',
                                          context,
                                          size);
                                    } else {
                                      signUp();
                                    }
                                  }
                                }
                              }
                            }
                          },
                        ),
                      ),
                      AnimatedPadding(
                        duration: const Duration(milliseconds: 500),
                        padding: EdgeInsets.only(
                          top: size.height * 0.15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/cryphive_word_nobg.png', height: 40,),
                            Image.asset('assets/images/cryphive_logo_nobg.png', height: 40,),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      GestureDetector(
                        onTap: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                          });
                        },
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Already have an account? ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.height * 0.018,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool pwVisible = false;
  Widget buildTextField(
      String hintText,
      IconData icon,
      bool password,
      size,
      FormFieldValidator validator,
      Key key,
      int stringToEdit,
      ) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.025),
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.05,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Form(
          key: key,
          child: TextFormField(
            style: const TextStyle(
                color: Color(0xffADA4A5)
            ),
            onChanged: (value) {
              setState(() {
                textFieldsStrings[stringToEdit] = value;
              });
            },
            validator: validator,
            textInputAction: TextInputAction.next,
            obscureText: password ? !pwVisible : false,
            decoration: InputDecoration(
              errorStyle: const TextStyle(height: 0),
              hintStyle: const TextStyle(
                color: Color(0xffADA4A5),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(
                top: size.height * 0.012,
              ),
              hintText: hintText,
              prefixIcon: Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.005,
                ),
                child: Icon(
                  icon,
                  color: const Color(0xff7B6F72),
                ),
              ),
              suffixIcon: password
                  ? Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.005,
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      pwVisible = !pwVisible;
                    });
                  },
                  child: pwVisible
                      ? const Icon(
                    Icons.visibility_off_outlined,
                    color: Color(0xff7B6F72),
                  )
                      : const Icon(
                    Icons.visibility_outlined,
                    color: Color(0xff7B6F72),
                  ),
                ),
              )
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildSnackError(
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
