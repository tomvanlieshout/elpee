import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';
import './authentication.dart';

class SpotifyApi {
  SharedPreferences prefs;
  String token;
  Map<String, String> headers;
  String searchEndpoint = "https://api.spotify.com/v1/search?";
  bool isValid;
  final Authentication auth = new Authentication();

  Future<bool> _validateToken() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }

    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime now = DateTime.now();
    DateTime tokenDateTime;
    String tokenDateString = prefs.getString('token_date');

    if (tokenDateString == null) {
      // Set datetime in the past in case the device never
      // set tokenDateString before (e.g. on first install)
      tokenDateTime = DateTime(2020, 01, 01, 12, 0, 0);
    } else {
      tokenDateTime = dateFormat.parse(tokenDateString);
    }

    if (now.isAfter(tokenDateTime)) {
      return false;
    } else {
      return true;
    }
  }

  _setHeaders(String token) {
    headers = {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
  }

  // Get a list of albums from a list of albumIds.
  Future<Response> getAlbumsById(List<String> ids) async {
    if (headers == null) {
      if (prefs == null) {
        prefs = await SharedPreferences.getInstance();
      }
      _setHeaders(prefs.getString('access_token'));
    }
    String idListString = ids.join(',');
    String query = "https://api.spotify.com/v1/albums?ids=$idListString";

    bool tokenIsValid = await _validateToken();

    if (tokenIsValid) {
      // TODO HandshakeException
      return await get(query, headers: headers);
    } else {
      try {
        await auth.getAuthToken();
      } on AuthError catch (e) {
        throw AuthError(e.message);
      }
      return await get(query, headers: headers);
    }
  }

  // Get a list of 20 albums from a query.
  Future<Response> getAlbumsByQuery(String q) async {
    String query = 'q=$q&type=album&limit=20';

    bool tokenIsValid = await _validateToken();

    if (tokenIsValid) {
      _setHeaders(prefs.getString('access_token'));
      return await get(searchEndpoint + query, headers: headers);
      //TODO
    } else {
      try {
        await auth.getAuthToken();
      } on AuthError catch (e) {
        throw AuthError(e.message);
      }
      _setHeaders(prefs.getString('access_token'));
      return await get(searchEndpoint + query, headers: headers);
    }
  }

  // Get a list of simple artist object from a query
  Future<Response> getArtistsByQuery(String q) async {
    String query =
        'https://api.spotify.com/v1/search?q=$q&type=artist&limit=20';
    bool tokenIsValid = await _validateToken();

    if (tokenIsValid) {
      _setHeaders(prefs.getString('access_token'));
      return await get(query, headers: headers);
      //TODO
    } else {
      try {
        await auth.getAuthToken();
      } on AuthError catch (e) {
        throw AuthError(e.message);
      }
      _setHeaders(prefs.getString('access_token'));
      return await get(query, headers: headers);
    }
  }

  // Get a list of artists from a list of artistIds.
  Future<Response> getArtistsById(List<String> idList) async {
    String idString = idList.join(',');
    String query = 'https://api.spotify.com/v1/artists?ids=$idString';
    bool tokenIsValid = await _validateToken();

    if (tokenIsValid) {
      _setHeaders(prefs.getString('access_token'));
      return await get(query, headers: headers);
    } else {
      try {
        await auth.getAuthToken();
      } on AuthError catch (e) {
        throw AuthError(e.message);
      }
      _setHeaders(prefs.getString('access_token'));
      return await get(query, headers: headers);
    }
  }

  // Get an artist from an artistId.
  Future<Response> getArtistById(String id) async {
    String query = 'https://api.spotify.com/v1/artists/$id';
    bool tokenIsValid = await _validateToken();

    if (tokenIsValid) {
      _setHeaders(prefs.getString('access_token'));
      // TODO socketException
      return await get(query, headers: headers);
    } else {
      try {
        await auth.getAuthToken();
      } on AuthError catch (e) {
        throw AuthError(e.message);
      }
      _setHeaders(prefs.getString('access_token'));
      return await get(query, headers: headers);
    }
  }

  // Get a list of albums from an artist's id.
  Future<Response> getArtistAlbums(String artistId, {String country}) async {
    String country;
    if (country == null) {
      country = "US";
    }

    String query =
        "https://api.spotify.com/v1/artists/$artistId/albums?limit=50&country=$country";

    bool tokenIsValid = await _validateToken();

    if (tokenIsValid) {
      _setHeaders(prefs.getString('access_token'));
      return await get(query, headers: headers);
    } else {
      try {
        await auth.getAuthToken();
      } on AuthError catch (e) {
        throw AuthError(e.message);
      }
      _setHeaders(prefs.getString('access_token'));
      return await get(query, headers: headers);
    }
  }

  // Get a list of top tracks from an artist's id.
  Future<Response> getTopTracks(String artistId, {String country}) async {
    String country;
    if (country == null) {
      country = 'US';
    }

    String query =
        "https://api.spotify.com/v1/artists/$artistId/top-tracks?country=$country";
    bool tokenIsValid = await _validateToken();

    if (tokenIsValid) {
      _setHeaders(prefs.getString('access_token'));
      return await get(query, headers: headers);
    } else {
      try {
        await auth.getAuthToken();
      } on AuthError catch (e) {
        throw AuthError(e.message);
      }
      _setHeaders(prefs.getString('access_token'));
      return await get(query, headers: headers);
    }
  }
}
