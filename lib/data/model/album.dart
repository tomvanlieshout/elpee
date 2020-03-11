import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Album extends Equatable {
  final String albumType;
  final List<dynamic> artists;
  final List<dynamic> availableMarkets;
  final List<dynamic> copyrights;
  final dynamic externalUrls;
  final String href;
  final String id;
  final List<dynamic> images;
  final String label;
  final String name;
  final dynamic popularity;
  final String releaseDate;
  final String releaseDatePrecision;
  final int totalTracks;
  final dynamic tracks;
  final String type;
  final String uri;

  Album({
    @required this.albumType,
    @required this.artists,
    @required this.availableMarkets,
    this.copyrights,
    @required this.externalUrls,
    @required this.href,
    @required this.id,
    @required this.images,
    this.label,
    @required this.name,
    this.popularity,
    this.releaseDate,
    this.releaseDatePrecision,
    this.totalTracks,
    @required this.tracks,
    this.type,
    @required this.uri,
  });

  static Album fromMap(Map<String, dynamic> json) {
    return new Album(
      albumType: json['album_type'],
      artists: json['artists'],
      availableMarkets: json['available_markets'] ?? [],
      copyrights: json['copyrights'] != null ? json['copyrights'] : [],
      externalUrls: json['external_urls'],
      href: json['href'],
      id: json['id'],
      images: json['images'],
      label: json['label'] != null ? json['label'] : '',
      name: json['name'],
      popularity: json['popularity'] != null ? json['popularity'] : null,
      releaseDate: json['release_date'] != null ? json['release_date'] : '',
      releaseDatePrecision: json['release_date_precision'] != null ? json['release_date_precision'] : '',
      totalTracks: json['total_tracks'] != null ? json['total_tracks'] : null,
      tracks: json['tracks'] != null ? json['tracks'] : [],
      type: json['type'],
      uri: json['uri'],
    );
  }

  static List<Album> listFromMap(Map<String, dynamic> json, String key) {
    List<Album> response = new List<Album>();
    String jsonKey;

    // This method extracts albums from an array, but the json
    // structure between albumsByQuery and albumsByArtistId differs, so
    // this logic is to set the right json key for the array of albums.
    if (key == 'artistsAlbums') {
      jsonKey = 'items';
    } else if (key == 'albums') {
      jsonKey = 'albums';
    }
    
    json[jsonKey].forEach((album) {
      response.add(new Album(
      albumType: album['album_type'],
      artists: album['artists'],
      availableMarkets: album['available_markets'],
      copyrights: album['copyrights'] != null ? album['copyrights'] : [],
      externalUrls: album['external_urls'],
      href: album['href'],
      id: album['id'],
      images: album['images'],
      label: album['label'] != null ? album['label'] : '',
      name: album['name'],
      popularity: album['popularity'] != null ? album['popularity'] : null,
      releaseDate: album['release_date'] != null ? album['release_date'] : '',
      releaseDatePrecision: album['release_date_precision'] != null ? album['release_date_precision'] : '',
      totalTracks: album['total_tracks'] != null ? album['total_tracks'] : null,
      tracks: album['tracks'] != null ? album['tracks'] : [],
      type: album['type'],
      uri: album['uri'],
      ));
    });
    return response;
  }

  @override
  List<Object> get props => [
        albumType,
        artists,
        availableMarkets,
        copyrights,
        externalUrls,
        href,
        id,
        images,
        name,
        popularity,
        releaseDate,
        releaseDatePrecision,
        totalTracks,
        tracks,
        type,
        uri,
      ];
}
