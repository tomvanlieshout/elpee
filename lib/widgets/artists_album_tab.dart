import 'package:flutter/material.dart';
import './artists_album.dart';
import '../data/model/album.dart';

class ArtistsAlbumTab extends StatelessWidget {
  final List<Album> albums;

  ArtistsAlbumTab({@required this.albums});

  List<ArtistsAlbum> _buildWidgetList() {
    List<ArtistsAlbum> result = new List<ArtistsAlbum>();
    albums.forEach((album) {
      result.add(new ArtistsAlbum(album: album));
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      scrollDirection: Axis.vertical,
      children: _buildWidgetList(),
    );
  }
}
