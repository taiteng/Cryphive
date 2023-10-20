import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryphive/model/posts_model.dart';
import 'package:cryphive/pages/view_posts_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostsWidget extends StatefulWidget {

  final PostsModel posts;
  final bool isLoggedIn;
  final String currentUserID;

  const PostsWidget({
    super.key,
    required this.posts,
    required this.isLoggedIn,
    required this.currentUserID,
  });

  @override
  State<PostsWidget> createState() => _PostsWidgetState();
}

class _PostsWidgetState extends State<PostsWidget> {

  bool isLikeButtonRed = false;

  num noLikes = 0;
  num noComments = 0;
  num noViews = 0;

  Future<void> isLiked() async{
    await FirebaseFirestore.instance.collection('Posts').doc(widget.posts.pID).collection('Likes').get().then((snapshot) => snapshot.docs.forEach((likesID) {
      if(likesID.reference.id == widget.currentUserID){
        setState(() {
          isLikeButtonRed = true;
        });
      }
    }));
  }

  Future<void> likePost() async{

    final likeRef = FirebaseFirestore.instance.collection('Posts').doc(widget.posts.pID).collection('Likes').doc(widget.currentUserID);
    final postRef = FirebaseFirestore.instance.collection('Posts').doc(widget.posts.pID);

    if(!isLikeButtonRed){
      await likeRef.set({
        'UID': widget.currentUserID,
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
      'uID': widget.posts.uID,
      'pID': widget.posts.pID,
      'Username': widget.posts.username,
      'Title': widget.posts.title,
      'Description': widget.posts.description,
      'ImageURL': widget.posts.imageURL,
      'HasImage': widget.posts.hasImage,
      'Date': widget.posts.date,
      'NumberOfLikes': noLikes,
      'NumberOfComments': widget.posts.numberOfComments,
      'NumberOfViews': widget.posts.numberOfViews,
    });
  }

  Future<void> addViewsAndRedirect() async {
    if(widget.isLoggedIn){
      setState(() {
        noViews++;
      });

      await FirebaseFirestore.instance.collection('Posts').doc(widget.posts.pID).set({
        'uID': widget.posts.uID,
        'pID': widget.posts.pID,
        'Username': widget.posts.username,
        'Title': widget.posts.title,
        'Description': widget.posts.description,
        'ImageURL': widget.posts.imageURL,
        'HasImage': widget.posts.hasImage,
        'Date': widget.posts.date,
        'NumberOfLikes': noLikes,
        'NumberOfComments': widget.posts.numberOfComments,
        'NumberOfViews': noViews,
      });
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPostsPage(postID: widget.posts.pID,)));
  }

  @override
  void initState() {
    isLiked();

    noLikes = widget.posts.numberOfLikes;
    noComments = widget.posts.numberOfComments;
    noViews = widget.posts.numberOfViews;

    super.initState();
  }

  @override
  void dispose() {

    noLikes = widget.posts.numberOfLikes;
    noComments = widget.posts.numberOfComments;
    noViews = widget.posts.numberOfViews;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    if(widget.posts.hasImage){
      return Padding(
        padding: const EdgeInsets.only(top: 13.0, left: 8.0, right: 8.0,),
        child: GestureDetector(
          onTap: () async {
            await addViewsAndRedirect();
          },
          onDoubleTap: () async {
            if(widget.isLoggedIn){
              likePost();
            }
            else{

            }
          },
          child: Container(
            height: size.height * 0.3,
            width:  size.width * 0.9,
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
                      image: NetworkImage(widget.posts.imageURL.toString()),
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
                                widget.posts.title.toString(),
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                widget.posts.description.toString(),
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Posted by: ${widget.posts.username.toString()}',
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 10,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Posted on: ${DateFormat('dd-MM-yyyy').format(widget.posts.date.toDate()).toString()}',
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
                                    onPressed: () async {
                                      if(widget.isLoggedIn){
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
                                    onPressed: () async {

                                      await addViewsAndRedirect();
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
                                    onPressed: () async {

                                      await addViewsAndRedirect();
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
        ),
      );
    }
    else{
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 8.0,),
        child: GestureDetector(
          onTap: () async {

            await addViewsAndRedirect();
          },
          onDoubleTap: () async {
            if(widget.isLoggedIn){
              likePost();
            }
            else{

            }
          },
          child: Container(
            height: size.height * 0.125,
            width:  size.width * 0.9,
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
                          widget.posts.title.toString(),
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.posts.description.toString(),
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Posted by: ${widget.posts.username.toString()}',
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Posted on: ${DateFormat('dd-MM-yyyy').format(widget.posts.date.toDate()).toString()}',
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
                              onPressed: () async {
                                if(widget.isLoggedIn){
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
                              onPressed: () async {

                                await addViewsAndRedirect();
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
                              onPressed: () async {

                                await addViewsAndRedirect();
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
        ),
      );
    }
  }
}
