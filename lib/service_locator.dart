import 'package:get_it/get_it.dart';
import 'package:audioplayers/audioplayers.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton(AudioPlayerService());
}

class AudioPlayerService {
  AudioPlayer audioPlayer = new AudioPlayer();
  AudioPlayerState audioState;

  AudioPlayer getAudioPlayer() {
    return audioPlayer;
  }

  AudioPlayerState getState() {
    return audioState;
  }
}