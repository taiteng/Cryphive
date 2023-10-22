import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryphive/pages/navigation_page.dart';
import 'package:cryphive/widgets/button_widget.dart';
import 'package:cryphive/widgets/edit_text_form_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class EditProfilePage extends StatefulWidget {

  final String email;
  final String username;
  final String profilePic;
  final String uID;
  final num capitalBalance;

  const EditProfilePage({
    super.key,
    required this.email,
    required this.username,
    required this.profilePic,
    required this.uID,
    required this.capitalBalance,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  final User? user = FirebaseAuth.instance.currentUser;

  final _usernameKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.username.toString());
  }

  PlatformFile? _pickedFile;
  UploadTask? _uploadTask;
  String? urlDownload;

  Future selectFile() async{
    try{
      final result = await FilePicker.platform.pickFiles();
      if(result == null) return;

      setState(() {
        _pickedFile = result.files.first;
      });
    } catch (error) {
      print(error.toString());
    }
  }

  Future uploadFile() async{
    try{
      final path = 'UserProfile/${_pickedFile!.name}';
      final file = File(_pickedFile!.path!);

      final ref = FirebaseStorage.instance.ref().child(path);
      setState(() {
        _uploadTask = ref.putFile(file);
      });

      final snapshot = await _uploadTask!.whenComplete(() {});
      urlDownload = await snapshot.ref.getDownloadURL();

      setState(() {
        _uploadTask = null;
      });
    } catch (error) {
      print(error.toString());
    }
  }

  Future uploadToFirebase() async{
    try{
      if(_pickedFile == null){
        await FirebaseFirestore.instance.collection('Users').doc(user?.uid.toString()).set({
          'Email' : widget.email.toString(),
          'Username' : usernameController.text,
          'ProfilePic' : widget.profilePic.toString(),
          'LoginMethod' : 'Email',
          'UID' : widget.uID.toString(),
          'Capital': widget.capitalBalance,
        });
      }
      else{
        await uploadFile();

        await FirebaseFirestore.instance.collection('Users').doc(user?.uid.toString()).set({
          'Email' : widget.email.toString(),
          'Username' : usernameController.text,
          'ProfilePic' : urlDownload.toString(),
          'LoginMethod' : 'Email',
          'UID' : widget.uID.toString(),
          'Capital': widget.capitalBalance,
        });
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => NavigationPage(index: 4,)));
      });
    } catch (e){
      print(e);
    }
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
          'EDIT PROFILE',
          style: TextStyle(
            color: Colors.yellowAccent,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EditTextFormFieldWidget(
                hintText: widget.username,
                icon: Icons.person_outlined,
                password: false,
                size: size,
                validator: (valuename) {
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
                formKey: _usernameKey,
                controller: usernameController,
              ),
              SizedBox(height: 10,),
              _pickedFile != null
                  ? Padding(
                padding: const EdgeInsets.all(20),
                child: Image.file(
                  File(_pickedFile!.path!),
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                ),
              )
                  : Padding(
                padding: const EdgeInsets.all(20),
                child: Image.network(
                  widget.profilePic.toString(),
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                ),
              ),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  selectFile();
                },
                child: Container(
                  width: size.width * 0.9,
                  height: size.height * 0.05,
                  decoration: const BoxDecoration(
                    color: Color(0xff151f2c),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: const Center(
                    child: Text(
                      "UPLOAD IMAGE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              AnimatedPadding(
                duration: const Duration(milliseconds: 500),
                padding: EdgeInsets.only(top: size.height * 0.085),
                child: ButtonWidget(
                  text: "SUBMIT",
                  backColor: [
                    Color(0xff151f2c),
                    Color(0xff151f2c),
                  ],
                  textColor: const [
                    Colors.white,
                    Colors.white,
                  ],
                  onPressed: () async {
                    if (_usernameKey.currentState!.validate()) {
                      uploadToFirebase();
                    }
                  },
                ),
              ),
              SizedBox(height: 10,),
              buildProgress(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
    stream: _uploadTask?.snapshotEvents,
    builder: (context, snapshot){
      if(snapshot.hasData){
        final data = snapshot.data!;
        double progress = data.bytesTransferred / data.totalBytes;

        return SizedBox(
          height: 50,
          child: Stack(
            fit: StackFit.expand,
            children: [
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade200,
                color: Colors.deepOrangeAccent,
              ),
              Center(
                child: Text(
                  '${(100 * progress).round()}%',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      else if(snapshot.connectionState ==  ConnectionState.waiting){
        return Text('Waiting for Upload');
      }
      else{
        return Text('');
      }
    },
  );

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
