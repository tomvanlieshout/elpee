import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserWall {
  final String id;
  final String title;
  final String description;
  final List<dynamic> albums;
  final String authorId;
  final Timestamp creationDate;

  UserWall({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.albums,
    @required this.authorId,
    @required this.creationDate,
  });

  static UserWall fromMap(Map<String, dynamic> json, List<dynamic> albums) {
    return new UserWall(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      albums: albums,
      authorId: json['authorId'],
      creationDate: json['creationDate'],
    );
  }

  static List<UserWall> listFromMap(Map<String, dynamic> json, List<dynamic> albums) {
    List<UserWall> result = new List<UserWall>();
    json['albums'].forEach((album) {
      result.add(UserWall.fromMap(album, albums));
    });
    return result;
  }
}
