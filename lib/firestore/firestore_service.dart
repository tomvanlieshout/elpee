import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/model/album.dart';

final Firestore db = Firestore.instance;

CollectionReference albumCollection = db.collection('albums');

Future<bool> createAlbum(Album albumModel) async {
  try {
    await db.collection("albums").document(albumModel.id).setData({
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
