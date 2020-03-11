import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import './track_preview_player.dart';
import '../data/model/track.dart';

class AlbumTrack extends StatelessWidget {
  static final AudioPlayer audioPlayer = new AudioPlayer();
  final Track track;

  AlbumTrack(this.track);

  String getArtists() {
    List<String> artistNames = new List<String>();
    track.artists.forEach((artist) {
      artistNames.add(artist['name']);
    });
    if (artistNames.length > 1) {
      return artistNames.join(', ');
    } else {
      return track.artists[0]['name'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 18),
            child: Text(
              track.trackNumber.toString(),
              style: Theme.of(context).textTheme.body2,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.65,
                margin: EdgeInsets.only(bottom: 5),
                child: Text(
                  track.name,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  getArtists(),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: Theme.of(context).textTheme.body2,
                ),
              ),
              Divider(
                color: Colors.white54,
              )
            ],
          ),
          track.previewUrl != null
              ? Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: TrackPreviewPlayer(
                    trackModel: track,
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(right: 30),
                ),
        ],
      ),
    );
  }
}
