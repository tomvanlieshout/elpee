import 'package:equatable/equatable.dart';

import '../../data/model/artist.dart';
import '../../data/model/top_track.dart';

abstract class ArtistState extends Equatable {
  const ArtistState();
}

class ArtistInitial extends ArtistState {
  const ArtistInitial();
  
  @override
  List<Object> get props => [];
}

class ArtistLoadInProgress extends ArtistState {
  const ArtistLoadInProgress();
  
  @override
  List<Object> get props => [];
}

class ArtistLoadSuccess extends ArtistState {
  final Artist artist;
  const ArtistLoadSuccess(this.artist);

  @override
  List<Object> get props => [artist];
}

class ArtistsLoadSuccess extends ArtistState {
  final List<Artist> artists;
  const ArtistsLoadSuccess(this.artists);

  @override
  List<Object> get props => [artists];
}

class TopTracksLoadSuccess extends ArtistState {
  final List<TopTrack> topTracks;
  const TopTracksLoadSuccess(this.topTracks);

  @override
  List<Object> get props => [topTracks];
}

class WikipediaLinkLoadSuccess extends ArtistState {
  final String link;
  const WikipediaLinkLoadSuccess(this.link);

  @override
  List<Object> get props => [link];
}

class WikipediaPageLoadSuccess extends ArtistState {
  final String htmlData;
  const WikipediaPageLoadSuccess(this.htmlData);

  @override
  List<Object> get props => [htmlData];
}

class ArtistError extends ArtistState {
  final String message;
  const ArtistError(this.message);

  @override
  List<Object> get props => [message];
}