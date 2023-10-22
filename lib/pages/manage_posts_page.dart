import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryphive/model/posts_model.dart';
import 'package:cryphive/pages/edit_post_page.dart';
import 'package:cryphive/pages/navigation_page.dart';
import 'package:cryphive/pages/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ManagePostsPage extends StatefulWidget {
  const ManagePostsPage({super.key});

  @override
  State<ManagePostsPage> createState() => _ManagePostsPageState();
}

class _ManagePostsPageState extends State<ManagePostsPage> {

  final User? user = FirebaseAuth.instance.currentUser;

  bool isPageRefreshing = true;

  List<PostsModel> posts = [];

  Future<void> getPosts() async {
    try{
      posts.clear();

      await FirebaseFirestore.instance.collection('Posts').where('uID', isEqualTo: user!.uid.toString()).get().then((snapshot) => snapshot.docs.forEach((postID) async {
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
              numberOfViews: postID['NumberOfViews'],
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
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> deletePost(String postID) async{
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Post'),
          content: const Text("Are You Sure Want To Proceed?"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.done_rounded),
              color: Colors.green,
              onPressed: () async {
                try{
                  QuerySnapshot commentsQuerySnapshot = await FirebaseFirestore.instance.collection('Posts').doc(postID).collection('Comments').get();

                  for (QueryDocumentSnapshot cDoc in commentsQuerySnapshot.docs) {
                    if(cDoc.exists){
                      await cDoc.reference.delete();
                    }
                  }

                  QuerySnapshot likesQuerySnapshot = await FirebaseFirestore.instance.collection('Posts').doc(postID).collection('Likes').get();

                  for (QueryDocumentSnapshot lDoc in likesQuerySnapshot.docs) {
                    if(lDoc.exists){
                      await lDoc.reference.delete();
                    }
                  }

                  await FirebaseFirestore.instance.collection('Posts').doc(postID).delete();

                  setState(() {
                    getPosts();
                  });
                } catch (error) {
                  print(error.toString());
                }
                Navigator.of(context).pop();
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
      backgroundColor: const Color(0xff090a13),
      appBar: AppBar(
        elevation: 0.00,
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 40,
        toolbarOpacity: 0.8,
        backgroundColor: const Color(0xff151f2c),
        title: const Text(
          'MANAGE POSTS',
          style: TextStyle(
            color: Colors.yellowAccent,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => NavigationPage(index: 4,)));
            });
          },
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
              indicatorType: Indicator.orbit,
            ),
          ),
        )
            : posts == null || posts!.length == 0
            ? Padding(
          padding: EdgeInsets.all(size.height * 0.06),
          child: const Center(
            child: Text(
              'No posts found. Or an error occurred.',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        )
            : Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: ListView.builder(
            itemCount: posts!.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0,),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    posts[index].hasImage ? Container(
                      height: size.height * 0.3,
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
                                image: NetworkImage(posts[index].imageURL.toString()),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 8.0),
                            height: size.height * 0.1,
                            width: size.width,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25),),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          posts[index].title.toString(),
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          posts[index].description.toString(),
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'Posted by: ${posts[index].username.toString()}',
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            fontSize: 10,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'Posted on: ${DateFormat('dd-MM-yyyy').format(posts[index].date.toDate()).toString()}',
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            fontSize: 10,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {

                                              },
                                              icon: const Icon(Icons.favorite_rounded),
                                              color: Colors.red,
                                            ),
                                            Text(
                                              posts[index].numberOfLikes.toString(),
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
                                              posts[index].numberOfViews.toString(),
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
                                              posts[index].numberOfComments.toString(),
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
                    ) : Container(
                      height: size.height * 0.15,
                      width:  size.width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0, left: 10.0, top: 5.0, bottom: 5.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    posts[index].title.toString(),
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    posts[index].description.toString(),
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Posted by: ${posts[index].username.toString()}',
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 10,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Posted on: ${DateFormat('dd-MM-yyyy').format(posts[index].date.toDate()).toString()}',
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 10,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {

                                        },
                                        icon: const Icon(Icons.favorite_rounded),
                                        color: Colors.red,
                                      ),
                                      Text(
                                        posts[index].numberOfLikes.toString(),
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
                                        posts[index].numberOfViews.toString(),
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
                                        posts[index].numberOfComments.toString(),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EditPostPage(postData: posts[index],)));
                          },
                          icon: const Icon(Icons.edit_rounded),
                          color: Colors.deepOrange,
                        ),
                        IconButton(
                          onPressed: () async {
                            deletePost(posts[index].pID.toString());
                          },
                          icon: const Icon(Icons.delete_forever_rounded),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
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
