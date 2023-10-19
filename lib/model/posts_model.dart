import 'package:cloud_firestore/cloud_firestore.dart';

class PostsModel {
  String title;
  String description;
  String imageURL;
  bool hasImage;
  Timestamp date;
  num numberOfLikes;
  num numberOfComments;

  PostsModel({
    required this.title,
    required this.description,
    required this.imageURL,
    required this.hasImage,
    required this.date,
    required this.numberOfLikes,
    required this.numberOfComments,
  });
}