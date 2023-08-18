import 'package:cryphive/widgets/button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  String email = '';

  final _emailKey = GlobalKey<FormState>();

  Future<void> resetPassword() async {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: email.trim(),
      );

      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            backgroundColor: Colors.pinkAccent,
            title: Text('Reset Link Sent'),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            backgroundColor: Colors.deepPurpleAccent,
            title: Text('User Not Found'),
          );
        },
      );
    }
  }

  /*
  The first part before @ checks for the local part of the email address:
  ([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*) matches one or more characters that are not <, >, (, ), [, \, ., ,, ;, :, whitespace, @, or ". This ensures that there are no invalid characters in the local part.
  (\.[^<>()[\]\\.,;:\s@\"]+)* allows for periods followed by one or more characters that are not the same set of invalid characters. This allows for the presence of periods in the local part but ensures they are followed by valid characters.
  (\".+\") allows for the local part to be enclosed in double quotes. This is an alternative format for the local part that allows certain special characters. For example, an email like "john.doe"@example.com is valid.
  The second part after @ checks for the domain part of the email address:
  (\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\]) matches an IP address enclosed in square brackets. This allows for email addresses in the format [192.168.0.1].
  (([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}) matches the domain name, which consists of one or more groups of alphanumeric characters or hyphens followed by a period. The last group must be two or more alphabetical characters. This ensures that the domain name is valid, such as example.com.
  */

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
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.025,
                          vertical: 1,
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: size.height * 0.03,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.015,
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Back',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: size.height * 0.018,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.05,
                          left: size.width * 0.055,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Reset password',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: size.height * 0.035,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.055),
                        child: Align(
                          child: Text(
                            "Forgot your password? That's okay, it happens to everyone!\nPlease provide your email to reset your password.",
                            style: GoogleFonts.poppins(
                              color: Colors.white54,
                              fontSize: size.height * 0.02,
                            ),
                          ),
                        ),
                      ),
                      Form(
                        child: buildTextField(
                          "Email",
                          Icons.email_outlined,
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
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.025),
                        child: ButtonWidget(
                            text: 'Send Instruction',
                            backColor: [
                              Colors.black,
                              Colors.black,
                            ],
                            textColor: const [
                              Colors.white,
                              Colors.white,
                            ],
                            onPressed: () async {
                              if (_emailKey.currentState!.validate()) {
                                resetPassword();
                              }
                            }),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.08),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'CRYPHIVE',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: size.height * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Image.asset('assets/images/cryphive_logo_nobg.png', height: 40,),
                          ],
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

  Widget buildTextField(
      String hintText,
      IconData icon,
      size,
      FormFieldValidator validator,
      ) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.025),
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.06,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Form(
          key: _emailKey,
          child: TextFormField(
            style: TextStyle(
                color: const Color(0xffADA4A5),
            ),
            onChanged: (value) {
              setState(() {
                email = value;
              });
            },
            validator: validator,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              errorStyle: const TextStyle(height: 0),
              hintStyle: const TextStyle(
                color: Color(0xffADA4A5),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(
                top: size.height * 0.02,
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
