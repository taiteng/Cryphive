import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditPostsPage extends StatefulWidget {
  const EditPostsPage({super.key});

  @override
  State<EditPostsPage> createState() => _EditPostsPageState();
}

class _EditPostsPageState extends State<EditPostsPage> {

  Future<void> deletePost() async{
    QuerySnapshot commentsQuerySnapshot = await FirebaseFirestore.instance.collection('Posts').doc('widget.posts.pID').collection('Comments').get();

    for (QueryDocumentSnapshot doc in commentsQuerySnapshot.docs) {
      await doc.reference.delete();
    }

    QuerySnapshot likesQuerySnapshot = await FirebaseFirestore.instance.collection('Posts').doc('widget.posts.pID').collection('Likes').get();

    for (QueryDocumentSnapshot doc in likesQuerySnapshot.docs) {
      await doc.reference.delete();
    }

    await FirebaseFirestore.instance.collection('Posts').doc('widget.posts.pID').delete();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
