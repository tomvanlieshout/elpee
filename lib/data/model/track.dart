import 'package:flutter/material.dart';

class Track {
  final List<dynamic> artists;
  final List<dynamic> availableMarkets;
  final int discNumber;
  final int durationInMs;
  final bool explicit;
  final dynamic externalUrls;
  final String href;
  final String id;
  final bool isLocal;
  final String name;
  final String previewUrl;
  final int trackNumber;
  final String type;
  final String uri;

  Track({
    @required this.artists,
    @required this.availableMarkets,
    @required this.discNumber,
    @required this.durationInMs,
    @required this.explicit,
    @required this.externalUrls,
    @required this.href,
    @required this.id,
    @required this.isLocal,
    @required this.name,
    @required this.previewUrl,
    @required this.trackNumber,
    @required this.type,
    @required this.uri,
  });

  static Track fromMap(Map json) {
    return new Track(
      artists: json['artists'],
      availableMarkets: json['available_markets'],
      discNumber: json['disc_number'],
      durationInMs: json['duration_ms'],
      explicit: json['explicit'],
      externalUrls: json['external_urls'],
      href: json['href'],
      id: json['id'],
      isLocal: json['is_local'] != null ? json['is_local'] : false,
      name: json['name'],
      previewUrl: json['preview_url'],
      trackNumber: json['track_number'],
      type: json['type'],
      uri: json['uri'],
    );
  }

  static List<Track> listFromMap(List<dynamic> json) {
    List<Track> response = new List<Track>();

    json.forEach((track) {
      response.add(Track.fromMap(track));
    });
    return response;
  }
}
