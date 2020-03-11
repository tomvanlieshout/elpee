import 'package:http/http.dart';
import 'dart:convert';

import './model/album.dart';
import '../spotify_API/spotify_api.dart';

abstract class AlbumRepository {
  Future<List<Album>> fetchAlbumsByQuery(String query);
  Future<List<Album>> fetchAlbumsByArtistId(String artistId);
  Future<List<Album>> fetchAlbumsById(List<String> id);
}

class AlbumRepositoryImpl extends AlbumRepository {
  SpotifyApi spoti = new SpotifyApi();

  // This function calls by query, extracts each albums ID, and then does
  // another query by ID. The Album object in the response has more data in it.
  @override
  Future<List<Album>> fetchAlbumsByQuery(String query) async {
    List<String> idList = new List<String>();

    Response queryResponse = await spoti.getAlbumsByQuery(query);

    if (queryResponse.statusCode == 200) {
      Map<String, dynamic> albumsJson = jsonDecode(queryResponse.body);
      albumsJson['albums']['items'].forEach((album) {
        idList.add(album['id']);
      });

      Response response = await spoti.getAlbumsById(idList);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        return Album.listFromMap(responseJson, 'albums');
      } else {
        throw NetworkError();
      }
    } else {
      throw NetworkError();
    }
  }

  @override
  Future<List<Album>> fetchAlbumsByArtistId(String artistId) async {
    Response response = await spoti.getArtistAlbums(artistId);

    if (response.statusCode == 200) {
      List<String> ids = new List<String>();
      List<Album> albums =
          Album.listFromMap(jsonDecode(response.body), 'artistsAlbums');

      albums.forEach((album) {
        ids.add(album.id);
      });
      return fetchAlbumsById(ids);
    } else {
      throw NetworkError();
    }
  }

  @override
  Future<List<Album>> fetchAlbumsById(List<String> ids) async {
    List<Album> result = new List<Album>();
    // Limit of getAlbumsById is set to 20 by Spotify, so to have
    // more than 20 results need to be split up over multiple calls.
    if (ids.length > 20 && ids.length <= 40) {
      List<String> ids1 = ids.sublist(0, 19);
      List<String> ids2 = ids.sublist(20, ids.length);
      List<Album> result2 = new List<Album>();

      Response response = await spoti.getAlbumsById(ids1);
      Response response2 = await spoti.getAlbumsById(ids2);

      if (response.statusCode == 200 && response2.statusCode == 200) {
        Map<String, dynamic> json1 = jsonDecode(response.body);
        Map<String, dynamic> json2 = jsonDecode(response2.body);
        result = Album.listFromMap(json1, 'albums');
        result2 = Album.listFromMap(json2, 'albums');
        result.addAll(result2);

        return result;
      } else {
        throw NetworkError();
      }
    } else if (ids.length > 40) {
      List<String> ids1 = ids.sublist(0, 19);
      List<String> ids2 = ids.sublist(20, 39);
      List<String> ids3 = ids.sublist(40, ids.length);
      List<Album> result2 = new List<Album>();
      List<Album> result3 = new List<Album>();

      Response response = await spoti.getAlbumsById(ids1);
      Response response2 = await spoti.getAlbumsById(ids2);
      Response response3 = await spoti.getAlbumsById(ids3);

      if (response.statusCode == 200 &&
          response2.statusCode == 200 &&
          response3.statusCode == 200) {
        Map<String, dynamic> json1 = jsonDecode(response.body);
        Map<String, dynamic> json2 = jsonDecode(response2.body);
        Map<String, dynamic> json3 = jsonDecode(response3.body);

        result = Album.listFromMap(json1, 'albums');
        result2 = Album.listFromMap(json2, 'albums');
        result3 = Album.listFromMap(json3, 'albums');

        result.addAll(result2);
        result.addAll(result3);

        return result;
      } else {
        throw NetworkError();
      }
    } else {
      Response response = await spoti.getAlbumsById(ids);

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        return Album.listFromMap(json, 'albums');
      } else if (response.statusCode == 400) {
        throw NetworkError();
      } else {
        throw NetworkError();
      }
    }
  }
}

class NetworkError extends Error {}
