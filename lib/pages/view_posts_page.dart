import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryphive/model/posts_model.dart';
import 'package:cryphive/pages/navigation_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ViewPostsPage extends StatefulWidget {

  final String postID;

  const ViewPostsPage({
    super.key,
    required this.postID,
  });

  @override
  State<ViewPostsPage> createState() => _ViewPostsPageState();
}

class _ViewPostsPageState extends State<ViewPostsPage> {

  final _commentKey = GlobalKey<FormState>();

  TextEditingController commentController = TextEditingController();

  final User? user = FirebaseAuth.instance.currentUser;

  final CollectionReference _posts = FirebaseFirestore.instance.collection('Posts');

  bool isLikeButtonRed = false;

  String pID = '';
  String uID = '';
  String username = '';
  String title = '';
  String description = '';
  String imageURL = '';
  bool hasImage = false;
  Timestamp date = Timestamp.fromDate(DateTime.now());
  num noLikes = 0;
  num noComments = 0;
  num noViews = 0;

  Future<void> isLiked() async{
    await FirebaseFirestore.instance.collection('Posts').doc(widget.postID).collection('Likes').get().then((snapshot) => snapshot.docs.forEach((likesID) {
      if(likesID.reference.id == user!.uid.toString()){
        setState(() {
          isLikeButtonRed = true;
        });
      }
    }));
  }

  Future<void> likePost() async{

    final likeRef = FirebaseFirestore.instance.collection('Posts').doc(widget.postID).collection('Likes').doc(user!.uid.toString());
    final postRef = FirebaseFirestore.instance.collection('Posts').doc(widget.postID);

    if(!isLikeButtonRed){
      await likeRef.set({
        'UID': user!.uid.toString(),
      });

      setState(() {
        isLikeButtonRed = true;
        noLikes++;
      });
    }
    else{
      await likeRef.delete();

      setState(() {
        isLikeButtonRed = false;
        noLikes--;
      });
    }

    await postRef.set({
      'uID': uID,
      'pID': pID,
      'Username': username,
      'Title': title,
      'Description': description,
      'ImageURL': imageURL,
      'HasImage': hasImage,
      'Date': date,
      'NumberOfLikes': noLikes,
      'NumberOfComments': noComments,
      'NumberOfViews': noViews,
    });
  }

  @override
  void initState() {
    isLiked();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xff090a13),
      appBar: AppBar(
        elevation: 0.00,
        titleSpacing: 0.00,
        centerTitle: true,
        toolbarHeight: 40,
        toolbarOpacity: 0.8,
        backgroundColor: const Color(0xff151f2c),
        title: const Text(
          '',
          style: TextStyle(
            color: Colors.yellowAccent,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => NavigationPage(index: 2),),);
          },
        ),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              FutureBuilder<DocumentSnapshot>(
                future: _posts.doc(widget.postID).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done){
                    if (snapshot.hasData) {
                      Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

                      PostsModel postData = PostsModel(
                        pID: data['pID'],
                        uID: data['uID'],
                        username: data['Username'],
                        title: data['Title'],
                        description: data['Description'],
                        imageURL: data['ImageURL'],
                        hasImage: data['HasImage'],
                        date: data['Date'],
                        numberOfLikes: data['NumberOfLikes'],
                        numberOfComments: data['NumberOfComments'],
                        numberOfViews: data['NumberOfViews'],
                      );

                      pID = postData.pID;
                      uID = postData.uID;
                      username = postData.username;
                      title = postData.title;
                      description = postData.description;
                      imageURL = postData.imageURL;
                      hasImage = postData.hasImage;
                      date = postData.date;
                      noLikes = postData.numberOfLikes;
                      noComments = postData.numberOfComments;
                      noViews = postData.numberOfViews;

                      if(hasImage){
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 8.0,),
                          child: Container(
                            height: size.height * 0.45,
                            width:  size.width,
                            decoration: const BoxDecoration(
                              color: Color(0xff853f3f),
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: size.height * 0.2,
                                  width: size.width,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(imageURL.toString()),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  height: size.height * 0.25,
                                  width: size.width,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25),),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: ListView(
                                            children: [
                                              Text(
                                                title.toString(),
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                description.toString(),
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                'Posted by: ${username.toString()}',
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                ),
                                              ),
                                              Text(
                                                'Posted on: ${DateFormat('dd-MM-yyyy').format(date.toDate()).toString()}',
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                    onPressed: () async {
                                                      if(user != null){
                                                        likePost();
                                                      }
                                                      else{

                                                      }
                                                    },
                                                    icon: const Icon(Icons.favorite_rounded),
                                                    color: isLikeButtonRed ? Colors.red : Colors.grey,
                                                  ),
                                                  Text(
                                                    noLikes.toString(),
                                                    style: const TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {

                                                    },
                                                    icon: const Icon(Icons.remove_red_eye_rounded),
                                                    color: Colors.indigo,
                                                  ),
                                                  Text(
                                                    noViews.toString(),
                                                    style: const TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {

                                                    },
                                                    icon: const Icon(Icons.comment_rounded),
                                                    color: Colors.green,
                                                  ),
                                                  Text(
                                                    noComments.toString(),
                                                    style: const TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      else{
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 8.0,),
                          child: Container(
                            height: size.height * 0.3,
                            width:  size.width,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: ListView(
                                      children: [
                                        Text(
                                          title.toString(),
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          description.toString(),
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          'Posted by: ${username.toString()}',
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                        Text(
                                          'Posted on: ${DateFormat('dd-MM-yyyy').format(date.toDate()).toString()}',
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                if(user != null){
                                                  likePost();
                                                }
                                                else{

                                                }
                                              },
                                              icon: const Icon(Icons.favorite_rounded),
                                              color: isLikeButtonRed ? Colors.red : Colors.grey,
                                            ),
                                            Text(
                                              noLikes.toString(),
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {

                                              },
                                              icon: const Icon(Icons.remove_red_eye_rounded),
                                              color: Colors.indigo,
                                            ),
                                            Text(
                                              noViews.toString(),
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {

                                              },
                                              icon: const Icon(Icons.comment_rounded),
                                              color: Colors.green,
                                            ),
                                            Text(
                                              noComments.toString(),
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    }
                    else{
                      return Padding(
                        padding: EdgeInsets.all(size.height * 0.06),
                        child: const Center(
                          child: Text(
                            'An error occurred. Please wait and try again later.',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      );
                    }
                  }
                  else{
                    return const Center(
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: LoadingIndicator(
                          colors: [Colors.red, Colors.green, Colors.blue, Colors.yellow],
                          indicatorType: Indicator.pacman,
                        ),
                      ),
                    );
                  }
                },
              ),
              const Text(
                'Comment Section',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.5,),
              SizedBox(height: size.height * 0.5,),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.grey,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Form(
                          key: _commentKey,
                          child: TextFormField(
                            controller: commentController,
                            enabled: user != null ? true : false,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            onChanged: (value) {
                              setState(() {

                              });
                            },
                            validator: (value) {
                              if (value!.length <= 0) {
                                buildSnackError(
                                  'Invalid Title',
                                  context,
                                  size,
                                );
                                return '';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              hintText: 'Type your comment...',
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        color: Colors.lightBlueAccent,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send),
                        color: Colors.white,
                        onPressed: () {

                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
