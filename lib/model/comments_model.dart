import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsModel {
  String username;
  String comment;
  Timestamp date;

  CommentsModel({
    required this.username,
    required this.comment,
    required this.date,
  });
}