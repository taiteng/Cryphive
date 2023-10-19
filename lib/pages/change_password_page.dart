import 'package:another_flushbar/flushbar.dart';
import 'package:cryphive/widgets/button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {

  var auth = FirebaseAuth.instance;
  var currentUser = FirebaseAuth.instance.currentUser;

  List textFieldsStrings = [
    "", //old password
    "", //new password
  ];

  final _oldPasswordKey = GlobalKey<FormState>();
  final _newPasswordKey = GlobalKey<FormState>();

  Future<void> changePassword() async {
    var cred = EmailAuthProvider.credential(
      email: currentUser!.email.toString().trim(),
      password: textFieldsStrings[0].toString().trim(),
    );

    await currentUser!.reauthenticateWithCredential(cred).then((value) async {
      currentUser!.updatePassword(textFieldsStrings[1].toString().trim());

      await Flushbar(
        title: 'Change Password',
        titleSize: 14,
        titleColor: Colors.white,
        message: 'Password Changed.',
        messageSize: 12,
        messageColor: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(
          Icons.check,
          color: Colors.white,
        ),
        flushbarStyle: FlushbarStyle.FLOATING,
        reverseAnimationCurve: Curves.decelerate,
        forwardAnimationCurve: Curves.elasticOut,
        backgroundColor: Colors.black,
      ).show(context);

      Navigator.pop(context);
    }).catchError((error){
      print(error.toString());
    });
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
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.025,
                          vertical: 1,
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
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
                              child: GestureDetector(
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
                            'Change Password',
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
                            "Please provide your email and old password to change your password.",
                            style: GoogleFonts.poppins(
                              color: Colors.white54,
                              fontSize: size.height * 0.02,
                            ),
                          ),
                        ),
                      ),
                      Form(
                        child: buildTextField(
                          "Old Password",
                          Icons.lock_outline,
                          true,
                          size,
                              (valueoldpassword) {
                            if (valueoldpassword.length < 6) {
                              buildSnackError(
                                'Invalid old password',
                                context,
                                size,
                              );
                              return '';
                            }
                            return null;
                          },
                          _oldPasswordKey,
                          0,
                        ),
                      ),
                      Form(
                        child: buildTextField(
                          "New Password",
                          Icons.lock_outline,
                          true,
                          size,
                              (valuenewpassword) {
                            if (valuenewpassword.length < 6) {
                              buildSnackError(
                                'Invalid new password',
                                context,
                                size,
                              );
                              return '';
                            }
                            return null;
                          },
                          _newPasswordKey,
                          1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.025),
                        child: ButtonWidget(
                            text: 'Send',
                            backColor: const [
                              Colors.black,
                              Colors.black,
                            ],
                            textColor: const [
                              Colors.white,
                              Colors.white,
                            ],
                            onPressed: () async {
                              if (_oldPasswordKey.currentState!.validate()) {
                                if (_newPasswordKey.currentState!.validate()) {
                                  await changePassword();
                                }
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
