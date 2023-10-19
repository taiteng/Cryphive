import 'package:cloud_firestore/cloud_firestore.dart';

class PostsModel {
  String pID;
  String uID;
  String username;
  String title;
  String description;
  String imageURL;
  bool hasImage;
  Timestamp date;
  num numberOfLikes;
  num numberOfComments;
  num numberOfViews;

  PostsModel({
    required this.pID,
    required this.uID,
    required this.username,
    required this.title,
    required this.description,
    required this.imageURL,
    required this.hasImage,
    required this.date,
    required this.numberOfLikes,
    required this.numberOfComments,
    required this.numberOfViews,
  });
}