import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:audioplayers/audioplayers.dart';

import '../data/model/top_track.dart';
import './track_preview_player.dart';

class TopTrackCard extends StatelessWidget {
  static final AudioPlayer audioPlayer = new AudioPlayer();
  final TopTrack track;

  TopTrackCard(this.track);

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
      margin: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Container(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: track.album['images'][2]['url'],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.55,
                margin: EdgeInsets.only(top: 8, left: 18),
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
                width: MediaQuery.of(context).size.width * 0.5,
                margin: EdgeInsets.only(left: 18),
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
                  child: TrackPreviewPlayer(
                    trackModel: track,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
