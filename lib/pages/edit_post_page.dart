import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryphive/model/posts_model.dart';
import 'package:cryphive/pages/manage_posts_page.dart';
import 'package:cryphive/widgets/button_widget.dart';
import 'package:cryphive/widgets/edit_text_form_field_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class EditPostPage extends StatefulWidget {

  final PostsModel postData;

  const EditPostPage({
    super.key,
    required this.postData,
  });

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {

  final User? user = FirebaseAuth.instance.currentUser;

  final _titleKey = GlobalKey<FormState>();
  final _descriptionKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

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
      final path = 'Post/${_pickedFile!.name}';
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

  Future<void> uploadToFirebase() async {
    try{
      final postRef = FirebaseFirestore.instance.collection("Posts").doc(widget.postData.pID);

      if(_pickedFile != null){
        await uploadFile();

        await postRef.set({
          'pID': widget.postData.pID,
          'uID': widget.postData.uID,
          'Username': widget.postData.username,
          'Title': titleController.text.toString(),
          'Description': descriptionController.text.toString(),
          'HasImage': widget.postData.hasImage,
          'ImageURL': urlDownload.toString(),
          'Date': widget.postData.date,
          'NumberOfLikes': widget.postData.numberOfLikes,
          'NumberOfComments': widget.postData.numberOfComments,
          'NumberOfViews': widget.postData.numberOfViews,
        });
      }
      else{
        await postRef.set({
          'pID': widget.postData.pID,
          'uID': widget.postData.uID,
          'Username': widget.postData.username,
          'Title': titleController.text.toString(),
          'Description': descriptionController.text.toString(),
          'HasImage': widget.postData.hasImage,
          'ImageURL': widget.postData.imageURL,
          'Date': widget.postData.date,
          'NumberOfLikes': widget.postData.numberOfLikes,
          'NumberOfComments': widget.postData.numberOfComments,
          'NumberOfViews': widget.postData.numberOfViews,
        });
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ManagePostsPage()));
      });
    }catch(e) {
      print(e.toString());
    }
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
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      else if(snapshot.connectionState ==  ConnectionState.waiting){
        return const Text('Waiting for Upload');
      }
      else{
        return const Text('');
      }
    },
  );

  @override
  void initState() {
    titleController.text = widget.postData.title;
    descriptionController.text = widget.postData.description;
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
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
          'EDIT POST',
          style: TextStyle(
            color: Colors.yellowAccent,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              EditTextFormFieldWidget(
                hintText: 'Title',
                icon: Icons.title_rounded,
                password: false,
                size: size,
                validator: (value) {
                  if (value.length <= 0) {
                    buildSnackError(
                      'Invalid Title',
                      context,
                      size,
                    );
                    return '';
                  }
                  return null;
                },
                formKey: _titleKey,
                controller: titleController,
              ),
              EditTextFormFieldWidget(
                hintText: 'Description',
                icon: Icons.description_rounded,
                password: false,
                size: size,
                validator: (value) {
                  if (value.length <= 0) {
                    buildSnackError(
                      'Invalid Description',
                      context,
                      size,
                    );
                    return '';
                  }
                  return null;
                },
                formKey: _descriptionKey,
                controller: descriptionController,
              ),
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
                child: widget.postData.hasImage ? Image.network(
                  widget.postData.imageURL,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                ) : const Text(
                  'No Image Uploaded',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              ),
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
                        color: Color(0xffADA4A5),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedPadding(
                duration: const Duration(milliseconds: 500),
                padding: EdgeInsets.only(top: size.height * 0.025),
                child: ButtonWidget(
                  text: "Submit",
                  backColor: const [
                    Colors.blueAccent,
                    Colors.lightBlueAccent,
                  ],
                  textColor: const [
                    Colors.black,
                    Colors.black,
                  ],
                  onPressed: () async {
                    if(_titleKey.currentState!.validate()){
                      if(_descriptionKey.currentState!.validate()){
                        uploadToFirebase();
                      }
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              widget.postData.hasImage ? buildProgress(): const SizedBox(),
            ],
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
