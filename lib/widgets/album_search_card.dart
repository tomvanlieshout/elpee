import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../pages/album_page.dart';
import '../data/model/album.dart';

class AlbumSearchCard extends StatelessWidget {
  final Album albumModel;

  AlbumSearchCard(
      {@required this.albumModel});

  void _viewAlbum(BuildContext context) {
    Navigator.of(context).pushNamed(AlbumPage.routeName,
        arguments: {'model': albumModel, 'showSaveButton': true});
  }

  String _getArtists() {
    List<String> artistNames = new List<String>();
    albumModel.artists.forEach((s) {
      artistNames.add(s['name']);
    });
    if (artistNames.length > 1) {
      return artistNames.join(', ');
    } else {
      return albumModel.artists[0]['name'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _viewAlbum(context),
      child: Card(
        color: Theme.of(context).primaryColor,
        child: Row(
          children: <Widget>[
            FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: albumModel.images[2]['url'],
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              padding: EdgeInsets.all(10),
              color: Theme.of(context).primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      albumModel.name,
                      overflow: TextOverflow.fade,
                      style: Theme.of(context).textTheme.body1,
                      softWrap: false,
                    ),
                  ),
                  Text(
                    _getArtists(),
                    overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.body2,
                    softWrap: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
