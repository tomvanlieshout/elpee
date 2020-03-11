import 'package:flutter/material.dart';
import './track.dart';

class TopTrack extends Track{
  final Map<String, dynamic> album;
  final List<dynamic> artists;
  final List<dynamic> availableMarkets;
  final int discNumber;
  final int durationInMs;
  final bool explicit;
  final Map<dynamic, dynamic> externalUrls;
  final String href;
  final String id;
  final bool isLocal;
  final String name;
  final int popularity;
  final String previewUrl;
  final int trackNumber;
  final String type;
  final String uri;

  TopTrack({
    @required this.album,
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
    @required this.popularity,
    @required this.previewUrl,
    @required this.trackNumber,
    @required this.type,
    @required this.uri,
  });

  static TopTrack fromMap(Map<String, dynamic> json) {
    return new TopTrack(
      album: json['album'],
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
      popularity: json['popularity'],
      previewUrl: json['preview_url'],
      trackNumber: json['track_number'],
      type: json['type'],
      uri: json['uri'],
    );
  }

  static List<TopTrack> listFromMap(Map<String, dynamic> json) {
    List<TopTrack> response = new List<TopTrack>();
    json['tracks'].forEach((track) {
      response.add(new TopTrack(
        album: track['album'],
        artists: track['artists'],
        availableMarkets: track['available_markets'],
        discNumber: track['disc_number'],
        durationInMs: track['duration_ms'],
        explicit: track['explicit'],
        externalUrls: track['external_urls'],
        href: track['href'],
        id: track['id'],
        isLocal: track['is_local'],
        name: track['name'],
        popularity: json['popularity'],
        previewUrl: track['preview_url'],
        trackNumber: track['track_number'],
        type: track['type'],
        uri: track['uri'],
      ));
    });
    return response;
  }
}
