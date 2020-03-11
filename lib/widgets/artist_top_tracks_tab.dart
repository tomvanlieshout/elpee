import 'package:flutter/material.dart';

import './top_track_card.dart';
import '../data/model/artist.dart';
import '../data/model/top_track.dart';

class ArtistTopTracksTab extends StatefulWidget {
  final Artist artistModel;
  final List<TopTrack> topTracks;
  ArtistTopTracksTab({@required this.artistModel, @required this.topTracks});

  @override
  _ArtistTopTracksTabState createState() => _ArtistTopTracksTabState();
}

class _ArtistTopTracksTabState extends State<ArtistTopTracksTab> {
  bool isLoading = true;

  Column _buildTopTracksListView() {
    List<TopTrackCard> tracksList = new List<TopTrackCard>();
    widget.topTracks.forEach((model) {
      tracksList.add(new TopTrackCard(model));
    });
    return Column(
        children: tracksList,
      
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: _buildTopTracksListView(),
    );
  }
}
