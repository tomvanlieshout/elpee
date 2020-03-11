import 'package:equatable/equatable.dart';

abstract class AlbumEvent extends Equatable {
  const AlbumEvent();
}

class FetchedAlbumsByQuery extends AlbumEvent {
  final String query;

  const FetchedAlbumsByQuery(this.query);

  @override
  List<Object> get props => [query];
}

class FetchedAlbumsById extends AlbumEvent {
  final List<String> ids;

  const FetchedAlbumsById(this.ids);

  @override
  List<Object> get props => [ids];
}

class FetchedAlbumsByArtistId extends AlbumEvent {
  final String id;

  const FetchedAlbumsByArtistId(this.id);

  @override
  List<Object> get props => [id];
}