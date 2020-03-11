import 'package:flutter/material.dart';

import '../data/model/track.dart';
import '../data/model/album.dart';
import './album_track.dart';

class AlbumTrackCardList extends StatelessWidget {
  final Album album;
  final List<Track> tracks;
  
  AlbumTrackCardList(this.album, this.tracks);

  Column _populateListView(List<Track> trackModelList) {
    List<AlbumTrack> widgetList = new List<AlbumTrack>();

    trackModelList.forEach((model) {
      widgetList.add(new AlbumTrack(model));
    });

    return Column(
      children: widgetList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _populateListView(tracks);
  }
}
