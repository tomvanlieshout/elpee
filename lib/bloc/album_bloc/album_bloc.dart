import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:elpee/data/album_repository.dart';
import '../bloc.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository albumRepository;

  AlbumBloc(this.albumRepository);

  @override
  AlbumState get initialState => AlbumInitial();

  @override
  Stream<AlbumState> mapEventToState(AlbumEvent event) async* {
    yield AlbumLoadInProgress();
    if (event is FetchedAlbumsByQuery) {
      try {
        final albums = await albumRepository.fetchAlbumsByQuery(event.query);
        yield AlbumsLoadSuccess(albums);
      } on NetworkError {
        yield AlbumError("Couldn't fetch albums. Is the device online?");
      }
    } else if (event is FetchedAlbumsById) {
      try {
        final albums = await albumRepository.fetchAlbumsById(event.ids);
        yield AlbumsLoadSuccess(albums);
      } on NetworkError {
        yield AlbumError("Something went wrong. Please try again later.");
      }
    } else if (event is FetchedAlbumsByArtistId) {
      try {
        List<String> ids = new List<String>();
        final simpleAlbums = await albumRepository.fetchAlbumsByArtistId(event.id);

        simpleAlbums.forEach((album) {
          ids.add(album.id);
        });
        final albums = await albumRepository.fetchAlbumsById(ids);

        yield AlbumsLoadSuccess(albums);
      } on NetworkError {
        yield AlbumError("Something went wrong. Please try again later.");
      }
    }
  }
}
