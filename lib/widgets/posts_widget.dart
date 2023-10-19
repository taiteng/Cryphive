import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryphive/model/posts_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostsWidget extends StatefulWidget {

  final PostsModel posts;
  final bool isLoggedIn;
  final String currentUserID;
  final Function() getPosts;

  const PostsWidget({
    super.key,
    required this.posts,
    required this.isLoggedIn,
    required this.currentUserID,
    required this.getPosts,
  });

  @override
  State<PostsWidget> createState() => _PostsWidgetState();
}

class _PostsWidgetState extends State<PostsWidget> {

  bool isLikeButtonRed = false;

  bool isOwner = false;

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

    final postRef = FirebaseFirestore.instance.collection('Posts').doc(widget.posts.pID).collection('Likes').doc(widget.currentUserID);

    if(!isLikeButtonRed){
      await postRef.set({
        'UID': widget.currentUserID,
      });

      setState(() {
        isLikeButtonRed = true;
      });
    }
    else{
      await postRef.delete();

      setState(() {
        isLikeButtonRed = false;
      });
    }
  }

  Future<void> deletePost() async{
    QuerySnapshot commentsQuerySnapshot = await FirebaseFirestore.instance.collection('Posts').doc(widget.posts.pID).collection('Comments').get();

    for (QueryDocumentSnapshot doc in commentsQuerySnapshot.docs) {
      await doc.reference.delete();
    }

    QuerySnapshot likesQuerySnapshot = await FirebaseFirestore.instance.collection('Posts').doc(widget.posts.pID).collection('Likes').get();

    for (QueryDocumentSnapshot doc in likesQuerySnapshot.docs) {
      await doc.reference.delete();
    }

    await FirebaseFirestore.instance.collection('Posts').doc(widget.posts.pID).delete();

    widget.getPosts;
  }

  @override
  void initState() {
    isLiked();
    if(widget.isLoggedIn){
      if(widget.posts.uID == widget.currentUserID){
        setState(() {
          isOwner = true;
        });
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    if(widget.posts.hasImage){
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 8.0,),
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
                            IconButton(
                              onPressed: () async {
                                if(widget.isLoggedIn){
                                  likePost();
                                }
                                else{
                                  await Flushbar(
                                    title: 'Unauthorized',
                                    titleSize: 14,
                                    titleColor: Colors.white,
                                    message: 'Please login.',
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
                                }
                              },
                              icon: const Icon(Icons.favorite_rounded),
                              color: isLikeButtonRed ? Colors.red : Colors.grey,
                            ),
                            IconButton(
                              onPressed: () async {

                              },
                              icon: const Icon(Icons.zoom_out_map_rounded),
                              color: Colors.black38,
                            ),
                            isOwner ? IconButton(
                              onPressed: () {
                                deletePost();
                              },
                              icon: const Icon(Icons.delete_rounded),
                              color: Colors.black38,
                            ) : const SizedBox(),
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
          height: size.height * 0.125,
          width:  size.width * 0.9,
          decoration: const BoxDecoration(
            color: Color(0xff853f3f),
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Container(
            padding: const EdgeInsets.only(left: 8.0),
            height: size.height * 0.125,
            width: size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(25)),
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
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () async {
                            if(widget.isLoggedIn){
                              likePost();
                            }
                            else{
                              await Flushbar(
                                title: 'Unauthorized',
                                titleSize: 14,
                                titleColor: Colors.white,
                                message: 'Please login.',
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
                            }
                          },
                          icon: const Icon(Icons.favorite_rounded),
                          color: isLikeButtonRed ? Colors.red : Colors.grey,
                        ),
                        IconButton(
                          onPressed: () async {

                          },
                          icon: const Icon(Icons.zoom_out_map_rounded),
                          color: Colors.black38,
                        ),
                        isOwner ? IconButton(
                          onPressed: () {
                            deletePost();
                          },
                          icon: const Icon(Icons.delete_rounded),
                          color: Colors.black38,
                        ) : const SizedBox(),
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
