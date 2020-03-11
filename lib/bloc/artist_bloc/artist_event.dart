import 'package:equatable/equatable.dart';

abstract class ArtistEvent extends Equatable {
  const ArtistEvent();
}

class FetchedArtistsByQuery extends ArtistEvent {
  final String query;

  const FetchedArtistsByQuery(this.query);

  @override
  List<Object> get props => [query];
}

class FetchedArtistById extends ArtistEvent {
  final String id;

  const FetchedArtistById(this.id);

  @override
  List<Object> get props => [id];
}

class FetchedArtistTopTracks extends ArtistEvent {
  final String id;

  const FetchedArtistTopTracks(this.id);

  @override
  List<Object> get props => [id];
}

class FetchedWikipediaLink extends ArtistEvent {
  final String query;

  const FetchedWikipediaLink(this.query);

  @override
  List<Object> get props => [query];
}

class FetchedWikipediaArticle extends ArtistEvent {
  final String artistName;

  const FetchedWikipediaArticle(this.artistName);

  @override
  List<Object> get props => [artistName];
}
