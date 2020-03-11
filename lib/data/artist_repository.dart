import 'package:http/http.dart';
import 'dart:convert';

import './model/artist.dart';
import './model/top_track.dart';
import './wikipedia_api.dart';
import '../spotify_API/spotify_api.dart';

abstract class ArtistRepository {
  Future<List<Artist>> fetchArtistsByQuery(String query);
  Future<Artist> fetchArtistById(String id);
  Future<List<TopTrack>> fetchArtistTopTracks(String id);
  Future<String> fetchWikipediaLink(String query);
  Future<String> fetchWikipediaPage(String artistName);
}

class ArtistRepositoryImpl extends ArtistRepository {
  SpotifyApi spoti = new SpotifyApi();
  WikipediaApi wiki = new WikipediaApi();

  @override
  Future<List<Artist>> fetchArtistsByQuery(String query) async {
    List<String> idList = new List<String>();
    Response queryResponse;

    try {
      queryResponse = await spoti.getArtistsByQuery(query);
    } on NetworkError {
      throw NetworkError();
    }

    if (queryResponse.statusCode == 200) {
      Map<String, dynamic> artistsJson = jsonDecode(queryResponse.body);
      artistsJson['artists']['items'].forEach((artist) {
        idList.add(artist['id']);
      });

      Response response;

      try {
        response = await spoti.getArtistsById(idList);
      } on NetworkError {
        throw NetworkError();
      }

      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        return Artist.listFromMap(responseJson);
      } else {
        throw NetworkError();
      }
    } else {
      throw NetworkError();
    }
  }

  @override
  Future<Artist> fetchArtistById(String id) async {
    Response response;
    try {
      response = await spoti.getArtistById(id);
    } on NetworkError {
      throw NetworkError();
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return Artist.fromMap(json);
    } else {
      throw NetworkError();
    }
  }

  @override
  Future<List<TopTrack>> fetchArtistTopTracks(String id) async {
    Response response;
    try {
      response = await spoti.getTopTracks(id);
    } on NetworkError {
      throw NetworkError();
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return TopTrack.listFromMap(json);
    } else {
      throw NetworkError();
    }
  }

  @override
  Future<String> fetchWikipediaLink(String query) async {
    Response response;
    try {
      response = await wiki.getData(query);
    } on NetworkError {
      throw NetworkError();
    }
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return json['content_urls']['mobile']['page'];
    } else if (response.statusCode == 404) {
      throw NetworkError();
    } else {
      throw NetworkError();
    }
  }

  @override
  Future<String> fetchWikipediaPage(String artistName) async {
    Response response;
    try {
      response = await wiki.getData(artistName);
    } on NetworkError {
      throw NetworkError();
    }
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return json['extract_html'];
    } else if (response.statusCode == 404) {
      throw NetworkError();
    } else {
      throw NetworkError();
    }
  }
}

class NetworkError extends Error {}
