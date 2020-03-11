import 'package:elpee/data/album_repository.dart';
import 'package:http/http.dart';
import 'dart:io';
import 'dart:core';

class WikipediaApi {
  Future<Response> getData(String artistName) async {
    Response response;
    String query =
        'https://en.wikipedia.org/api/rest_v1/page/summary/$artistName';
    try {
      response = await get(query);
    } on SocketException {
      throw NetworkError();
    }
    return response;
  }

// Wrapper method to print long strings (because Flutter truncates console logs > 1024 characters...)
//   void printWrapped(String text) {
//     final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
//     pattern.allMatches(text).forEach((match) => print(match.group(0)));
//   }

}
