import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../service_locator.dart';
import '../data/model/track.dart';

class TrackPreviewPlayer extends StatefulWidget {
  final Track trackModel;

  TrackPreviewPlayer({@required this.trackModel});

  @override
  _TrackPreviewPlayerState createState() => _TrackPreviewPlayerState();
}

class _TrackPreviewPlayerState extends State<TrackPreviewPlayer> {
  AudioPlayerState audioPlayerState = locator<AudioPlayerService>().getState();
  AudioPlayer audioPlayer = locator<AudioPlayerService>().getAudioPlayer();

  @override
  dispose() {
    audioPlayer.stop();
    super.dispose();
  }

  audioHandler() {
    if (audioPlayerState == null) {
      audioPlayerState = AudioPlayerState.COMPLETED;
    }

    switch(audioPlayerState) {
      case AudioPlayerState.STOPPED:
      case AudioPlayerState.COMPLETED:
      case AudioPlayerState.PAUSED:
        audioPlayer.play(widget.trackModel.previewUrl);
        setState(() {
          audioPlayerState = AudioPlayerState.PLAYING;
        });
        break;
      case AudioPlayerState.PLAYING:
        audioPlayer.stop();
        setState(() {
          audioPlayerState = AudioPlayerState.STOPPED;
        });
        break;
      default:
        audioPlayer.stop();
        setState(() {
          audioPlayerState = AudioPlayerState.STOPPED;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        onPressed: audioHandler,
        icon: audioPlayerState == AudioPlayerState.PLAYING
            ? Icon(
                Icons.stop,
                color: Colors.white,
              )
            : Icon(
                Icons.play_circle_outline,
                color: Colors.white,
              ),
      ),
    );
  }
}
