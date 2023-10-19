import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryphive/model/posts_model.dart';
import 'package:cryphive/widgets/posts_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {

  final User? user = FirebaseAuth.instance.currentUser;

  bool isPageRefreshing = true;

  List<PostsModel> posts = [];

  Future getPosts() async {
    posts = [];

    await FirebaseFirestore.instance.collection('Posts').orderBy('Date', descending: true).get().then((snapshot) => snapshot.docs.forEach((postID) async {
        if (postID.exists) {
          posts.add(
            PostsModel(
              pID: postID['pID'],
              uID: postID['uID'],
              username: postID['Username'],
              title: postID['Title'],
              description: postID['Description'],
              imageURL: postID['ImageURL'],
              hasImage: postID['HasImage'],
              date: postID['Date'],
              numberOfLikes: postID['NumberOfLikes'],
              numberOfComments: postID['NumberOfComments'],
            ),
          );
        } else {
          print("Ntg to see here");
        }
      }),
    );

    setState(() {
      isPageRefreshing = false;
    });
  }

  @override
  void initState() {
    getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          if(user != null){

          }
          else{
            buildSnackError(
              'You are not logged in',
              context,
              size,
            );
          }
        },
        child: Container(
          height: size.height * 0.065,
          width: size.height * 0.065,
          decoration: const BoxDecoration(
            color: Colors.deepOrange,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              '+',
              style: TextStyle(
                color: Colors.white,
                fontSize: 35,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xff090a13),
      appBar: AppBar(
        elevation: 0.00,
        titleSpacing: 0.00,
        centerTitle: true,
        toolbarHeight: 40,
        toolbarOpacity: 0.8,
        backgroundColor: const Color(0xff151f2c),
        title: const Text(
          'COMMUNITY',
          style: TextStyle(
            color: Colors.yellowAccent,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: isPageRefreshing == true ?
        const Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: LoadingIndicator(
              colors: [Colors.red, Colors.green, Colors.blue, Colors.yellow],
              indicatorType: Indicator.pacman,
            ),
          ),
        ) 
            : posts == null || posts!.length == 0
            ? Padding(
          padding: EdgeInsets.all(size.height * 0.06),
          child: const Center(
            child: Text(
              'An error occurred. Please wait and try again later.',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        )
            : ListView.builder(
          itemCount: posts!.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            if(user != null){
              return PostsWidget(
                posts: posts[index],
                isLoggedIn: true,
                currentUserID: user!.uid.toString(),
                getPosts: getPosts,
              );
            }
            else{
              return PostsWidget(
                posts: posts[index],
                isLoggedIn: false,
                currentUserID: '',
                getPosts: getPosts,
              );
            }
          },
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
