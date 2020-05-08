import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'package:elpee/data/model/album.dart';
import 'package:http/http.dart';

final Firestore db = Firestore.instance;

class FirestoreService {
  Future<bool> createAlbum(Album albumModel) async {
    try {
      await db.collection('albums').document(albumModel.id).setData({
        'album_type': albumModel.albumType,
        'artists': albumModel.artists,
        'available_markets': albumModel.availableMarkets,
        'copyrights': albumModel.copyrights,
        'external_urls': albumModel.externalUrls,
        'href': albumModel.href,
        'id': albumModel.id,
        'images': albumModel.images,
        'label': albumModel.label,
        'name': albumModel.name,
        'popularity': albumModel.popularity,
        'release_date': albumModel.releaseDate,
        'release_date_precision': albumModel.releaseDatePrecision,
        'total_tracks': albumModel.totalTracks,
        'tracks': albumModel.tracks,
        'type': albumModel.type,
        'uri': albumModel.uri,
      });
      return true;
    } on Error {
      return false;
    }
  }

  Future<List<dynamic>> getUserWallAlbums(String userWallId, String userId) async {
    List result = new List();
    QuerySnapshot snapshot = await db
        .collection('users')
        .document(userId)
        .collection('user-walls')
        .document(userWallId)
        .collection('albums')
        .getDocuments();

    snapshot.documents.forEach((doc) {
      result.add(doc);
    });

    return result;
  }

  deleteWall(String wallId, String userId) async {
    String path = 'users/$userId/user-walls/$wallId';
    var json = jsonEncode({
      'data': {'path': path}
    });
    final headers = {
      'Content-Type': 'application/json',
    };
    try {
      await post('https://europe-west3-elpee-61c3f.cloudfunctions.net/deleteCollection', headers: headers, body: json);
    } on PlatformException catch (e) {
      throw e;
    }
  }

  Future<bool> addAlbumToWalls(Album albumModel, String userId, List<String> wallIds) async {
    wallIds.forEach((id) async {
      try {
        await db
            .collection('users')
            .document(userId)
            .collection('user-walls')
            .document(id)
            .collection('albums')
            .document(albumModel.id)
            .setData(Album.toMap(albumModel));
      } on PlatformException catch (e) {
        throw e;
      }
    });
    return true;
  }

  Future deleteAlbumsFromWall(List<String> ids, String userId, String wallId) async {
    CollectionReference _ref =
        db.collection('users').document(userId).collection('user-walls').document(wallId).collection('albums');

    ids.forEach((id) async {
      await _ref.document(id).delete();
    });
  }

  Future createUserWall(String title, String description, String authorId, DateTime creationDate) async {
    try {
      DocumentReference docRef =
          Firestore.instance.collection('users').document(authorId).collection('user-walls').document();
      docRef.setData({
        'id': docRef.documentID,
        'title': title,
        'description': description,
        'authorId': authorId,
        'creationDate': creationDate,
      });
    } on PlatformException catch (e) {
      throw e;
    }
  }

  Future editUserWall(String title, String description, String userId, String wallId) async {
    try {
      Firestore.instance.collection('users').document(userId).collection('user-walls').document(wallId).updateData({
        'title': title,
        'description': description ?? null,
      });
    } on PlatformException catch (e) {
      throw e;
    }
  }
}
