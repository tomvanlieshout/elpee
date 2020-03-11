import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;

class Secret {
  final String apiKey;

  Secret({this.apiKey = ""});

  factory Secret.fromJson(Map<String, dynamic> json) {
    return new Secret(apiKey: json['spotify_api_secret']);
  }
}

class SecretLoader {
  final String secretPath;

  SecretLoader(this.secretPath);

  Future<Secret> load() {
    return rootBundle.loadStructuredData<Secret>(this.secretPath, (jsonStr) async {
      final secret = Secret.fromJson(json.decode(jsonStr));
      return secret;
    });
  }
}