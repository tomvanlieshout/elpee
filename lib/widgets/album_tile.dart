import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

import '../pages/album_page.dart';

import '../data/model/album.dart';

class AlbumTile extends StatelessWidget {
  final Album albumModel;
  final SharedPreferences prefs;

  AlbumTile({@required this.prefs, @required this.albumModel});

  void _viewAlbum(BuildContext context) async {
    Navigator.of(context).pushNamed(AlbumPage.routeName,
        arguments: {'model': albumModel, 'showSaveButton': false});
  }

  // The images map of albumModel consists of 3 sizes, and to limit
  // data usage, depending on grid delegate,
  // the smaller images are loaded.
  int determineImageSize() {
    if (prefs.get('tileCount') == null) {
      prefs.setDouble('tileCount', 2.0);
    }
    switch (prefs.get('tileCount').round()) {
      case 1:
        return 0;
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
        return 1;
      case 7:
        return 2;
      default:
        return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _viewAlbum(context),
      child: FutureBuilder(builder: (context, snapshot) {
        return GridTile(
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: albumModel.images[determineImageSize()]['url'],
          ),
        );
      }),
    );
  }
}
