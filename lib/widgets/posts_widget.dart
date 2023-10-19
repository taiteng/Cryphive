import 'package:cryphive/model/posts_model.dart';
import 'package:flutter/material.dart';

class PostsWidget extends StatefulWidget {

  final PostsModel posts;
  final bool isLoggedIn;

  const PostsWidget({
    super.key,
    required this.posts,
    required this.isLoggedIn,
  });

  @override
  State<PostsWidget> createState() => _PostsWidgetState();
}

class _PostsWidgetState extends State<PostsWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
