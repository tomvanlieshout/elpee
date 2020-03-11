import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import 'package:elpee/bloc/bloc.dart';
import 'package:elpee/data/album_repository.dart';
import 'package:elpee/data/artist_repository.dart';
import 'package:elpee/data/model/album.dart';
import 'package:elpee/data/model/artist.dart';

class MockAlbumRepository extends Mock implements AlbumRepository {}

class MockArtistRepository extends Mock implements ArtistRepository {}

void main() {
  MockAlbumRepository mockAlbum;
  MockArtistRepository mockArtist;

  setUp(() {
    mockAlbum = MockAlbumRepository();
    mockArtist = MockArtistRepository();
  });

  group('blocTests', () {
    final albums = List<Album>();
    final artists = List<Artist>();
    final artist = Artist(
      externalUrls: {},
      href: '',
      id: '',
      images: [],
      name: '',
    );
    albums.add(Album.fromMap({
      'album_type': 'album',
      'artists': [],
      'available_markets': [],
      'copyrights': [],
      'external_urls': [],
      'href': 'href',
      'id': '01a',
      'images': [],
      'label': 'Tom Records',
      'name': 'The Album',
      'popularity': 100,
      'release_date': 'some string',
      'release_date_precision': 'another string',
      'total_tracks': 10,
      'tracks': [],
      'type': 'album',
      'uri': 'some uri',
    }));
    artists.add(Artist(
      externalUrls: {},
      href: '',
      id: '',
      images: [],
      name: '',
    ));

    blocTest(
      'FetchAlbumsByQuery',
      build: () {
        when(mockAlbum.fetchAlbumsByQuery(any)).thenAnswer((_) async => albums);
        return AlbumBloc(mockAlbum);
      },
      act: (bloc) => bloc.add(FetchedAlbumsByQuery('')),
      expect: [
        AlbumInitial(),
        AlbumLoadInProgress(),
        AlbumsLoadSuccess(albums)
      ],
    );
    blocTest(
      'FetchAlbumsById',
      build: () {
        when(mockAlbum.fetchAlbumsById(any)).thenAnswer((_) async => albums);
        return AlbumBloc(mockAlbum);
      },
      act: (bloc) => bloc.add(FetchedAlbumsById([])),
      expect: [
        AlbumInitial(),
        AlbumLoadInProgress(),
        AlbumsLoadSuccess(albums)
      ],
    );

    blocTest(
      'FetchAlbumsByArtistId',
      build: () {
        when(mockAlbum.fetchAlbumsByArtistId(any))
            .thenAnswer((_) async => albums);
        return AlbumBloc(mockAlbum);
      },
      act: (bloc) => bloc.add(FetchedAlbumsByArtistId('')),
      expect: [
        AlbumInitial(),
        AlbumLoadInProgress(),
        AlbumsLoadSuccess(albums)
      ],
    );

    blocTest(
      'FetchArtistsByQuery',
      build: () {
        when(mockArtist.fetchArtistsByQuery(any))
            .thenAnswer((_) async => artists);
        return ArtistBloc(mockArtist);
      },
      act: (bloc) => bloc.add(FetchedArtistsByQuery('')),
      expect: [
        ArtistInitial(),
        ArtistLoadInProgress(),
        ArtistsLoadSuccess(artists)
      ],
    );

    blocTest(
      'FetchArtistById',
      build: () {
        when(mockArtist.fetchArtistById(any)).thenAnswer((_) async => artist);
        return ArtistBloc(mockArtist);
      },
      act: (bloc) => bloc.add(FetchedArtistById('')),
      expect: [
        ArtistInitial(),
        ArtistLoadInProgress(),
        ArtistLoadSuccess(artist)
      ],
    );
  });
}
