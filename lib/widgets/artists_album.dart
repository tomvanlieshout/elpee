import 'package:flutter/material.dart';

import '../pages/album_page.dart';
import '../data/model/album.dart';

class ArtistsAlbum extends StatelessWidget {
  final Album album;

  ArtistsAlbum({@required this.album});

  String _getArtists() {
    List<String> artistNames = new List<String>();
    album.artists.forEach((s) {
      artistNames.add(s['name']);
    });
    if (artistNames.length > 1) {
      return artistNames.join(', ');
    } else {
      return album.artists[0]['name'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(AlbumPage.routeName,
            arguments: {'model': album, 'showSaveButton': true});
      },
      child: Container(
        margin: EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Image.network(album.images[1]['url']),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Text(
                album.name,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: Theme.of(context).textTheme.body1,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Text(
                _getArtists(),
                overflow: TextOverflow.fade,
                softWrap: false,
                style: Theme.of(context).textTheme.body2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
