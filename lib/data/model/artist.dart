import 'package:flutter/material.dart';

class Artist {
  String href;
  Map<dynamic, dynamic> externalUrls;
  String id;
  List<dynamic> images;
  String name;

  Artist({
    @required this.href,
    @required this.externalUrls,
    @required this.id,
    @required this.images,
    @required this.name,
  });

  static List<Artist> listFromMap(Map<String, dynamic> json) {
    List<Artist> response = new List<Artist>();

    json['artists'].forEach((artist) {
      response.add(
        new Artist(
          href: artist['href'],
          externalUrls: artist['external_urls'],
          id: artist['id'],
          images: artist['images'],
          name: artist['name'],
        )
      );
    });
    return response;
  }

  static Artist fromMap(Map<String, dynamic> json) {
    return new Artist(
      href: json['href'],
      externalUrls: json['external_urls'],
      id: json['id'],
      images: json['images'],
      name: json['name'],
    );
  }
}