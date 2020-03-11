import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../data/artist_repository.dart';
import '../../data/model/top_track.dart';
import '../bloc.dart';

class ArtistBloc extends Bloc<ArtistEvent, ArtistState> {
  final ArtistRepository artistRepository;

  ArtistBloc(this.artistRepository);

  @override
  ArtistState get initialState => ArtistInitial();

  @override
  Stream<ArtistState> mapEventToState(ArtistEvent event) async* {
    yield ArtistLoadInProgress();
    if (event is FetchedArtistsByQuery) {
      try {
        final artists = await artistRepository.fetchArtistsByQuery(event.query);
        yield ArtistsLoadSuccess(artists);
      } on NetworkError {
        yield ArtistError("Couldn't fetch artists. Is the device online?");
      }
    } else if (event is FetchedArtistById) {
      try {
        final artist = await artistRepository.fetchArtistById(event.id);
        yield ArtistLoadSuccess(artist);
      } on NetworkError {
        yield ArtistError('Something went wrong. Please try again later.');
      }
    } else if (event is FetchedArtistTopTracks) {
      try {
        final List<TopTrack> topTracks =
            await artistRepository.fetchArtistTopTracks(event.id);
        yield TopTracksLoadSuccess(topTracks);
      } on NetworkError {
        yield ArtistError('Something went wrong. Please try again later.');
      }
    } else if (event is FetchedWikipediaLink) {
      try {
        final String link = await artistRepository.fetchWikipediaLink(event.query);
        yield WikipediaLinkLoadSuccess(link);
      } on NetworkError {
        yield ArtistError('Something went wrong, please try again later.');
      }
    } else if (event is FetchedWikipediaArticle) {
      try {
        final String htmlData = await artistRepository.fetchWikipediaPage(event.artistName);
        yield WikipediaPageLoadSuccess(htmlData);
      } on NetworkError {
        yield ArtistError('No Wikipedia page was found.');
      }
    }
  }
}
