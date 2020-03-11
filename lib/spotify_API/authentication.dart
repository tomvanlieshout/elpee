import 'dart:core';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './secret.dart';

class Authentication {
  final String url = "https://accounts.spotify.com/api/token";
  final Map<String, String> body = {"grant_type": "client_credentials"};
  static Map<String, String> headers;
  String secret;
  SharedPreferences prefs;

  _fetchSecret() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }

    SecretLoader loader = SecretLoader('secret.json');
    Secret secret = await loader.load();
    prefs.setString('spotify_secret', secret.apiKey);
  }

  Future<String> _getSecret() async {
    String result;
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    result = prefs.getString('spotify_secret');
    if (result == null) {
      await _fetchSecret();
      result = prefs.getString('spotify_secret');
    }
    return result;
  }

  Future _setTokenExpirationDate() async {
    // TODO if (prefs == null)
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    DateTime _hourFromNow = new DateTime.now();
    _hourFromNow = _hourFromNow.add(new Duration(minutes: 55));

    String dateString = _hourFromNow.toString();
    prefs.setString('token_date', dateString);
  }

  Future getAuthToken() async {
    prefs = await SharedPreferences.getInstance();
    secret = await _getSecret();
    Map<String, String> headers = {
      "Authorization": "Basic $secret",
      "Content-Type": "application/x-www-form-urlencoded",
    };

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
        encoding: Encoding.getByName("utf-8"),
      );
      Map<dynamic, dynamic> map = jsonDecode(response.body);
      await _setTokenExpirationDate();

      prefs.setString('access_token', map['access_token']);
      debugPrint('spotify token: ');
      debugPrint(prefs.getString('access_token'));
    } on SocketException catch (e) {
      debugPrint(e.message + ', ' + e.osError.toString());
      throw AuthError(e.message);
    }
  }
}

class AuthError extends Error {
  final String message;
  AuthError(this.message);
}