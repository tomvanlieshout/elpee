import 'package:elpee/bloc/bloc.dart';
import 'package:elpee/data/model/artist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flushbar/flushbar.dart';

import '../widgets/album_search_card.dart';
import '../widgets/artist_card.dart';

import '../bloc/bloc.dart';
import '../data/model/album.dart';

class SearchForm extends StatefulWidget {
  static const routeName = '/search-form';

  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  List<AlbumSearchCard> albumList = new List<AlbumSearchCard>();
  List<ArtistCard> artistList = new List<ArtistCard>();
  String query;
  bool toggle = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Future.value(false);
        },
        child: Container(
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  bottom: 8.0,
                  top: 4.0,
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      margin: EdgeInsets.only(bottom: 15, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        cursorColor: Colors.amber,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: toggle
                              ? 'Search for albums'
                              : 'Search for artists',
                          labelStyle: TextStyle(
                            color: Colors.white60,
                          ),
                          fillColor: Colors.white,
                        ),
                        onSubmitted: (value) => submitAlbumName(context, value),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 12),
                      child: IconButton(
                        icon: Icon(Icons.album),
                        color: toggle ? Colors.white : Colors.white24,
                        onPressed: () {
                          setState(() {
                            toggle = true;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 12),
                      child: IconButton(
                        icon: Icon(Icons.person),
                        color: toggle ? Colors.white24 : Colors.white,
                        onPressed: () {
                          setState(() {
                            toggle = false;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              toggle
                  ? Expanded(
                      child: BlocListener<AlbumBloc, AlbumState>(
                        listener: (context, state) {
                          if (state is AlbumError) {
                            showError(context, state.message);
                          }
                        },
                        child: BlocBuilder<AlbumBloc, AlbumState>(
                          builder: (context, state) {
                            if (state is AlbumInitial) {
                              return Container();
                            } else if (state is AlbumLoadInProgress) {
                              return _buildLoading();
                            } else if (state is AlbumsLoadSuccess) {
                              return buildAlbumsWithData(context, state.albums);
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    )
                  : Expanded(
                      child: BlocListener<ArtistBloc, ArtistState>(
                        listener: (context, state) {
                          if (state is ArtistError) {
                            showError(context, state.message);
                          }
                        },
                        child: BlocBuilder<ArtistBloc, ArtistState>(
                          builder: (context, state) {
                            if (state is ArtistInitial) {
                              return Container();
                            } else if (state is ArtistLoadInProgress) {
                              return _buildLoading();
                            } else if (state is ArtistsLoadSuccess) {
                              return buildArtistsWithData(
                                  context, state.artists);
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildLoading() {
  return Center(
    child: CircularProgressIndicator(),
  );
}

showError(BuildContext context, String message) {
  return Flushbar(
    message: message,
    duration: Duration(seconds: 4),
    isDismissible: true,
    flushbarPosition: FlushbarPosition.BOTTOM,
    backgroundColor: Colors.black,
    borderRadius: 8,
    margin: EdgeInsets.all(5),
    borderColor: Colors.white,
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    icon: Icon(Icons.error, color: Colors.amber),
    overlayBlur: 1,
    shouldIconPulse: false,
  ).show(context);
}

Container buildAlbumsWithData(BuildContext context, List<Album> albums) {
  List<AlbumSearchCard> albumList = new List<AlbumSearchCard>();
  albums.forEach((album) {
    albumList.add(new AlbumSearchCard(albumModel: album));
  });
  return Container(
    margin: EdgeInsets.only(
      left: 8,
      right: 8,
    ),
    child: ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: albumList,
    ),
  );
}

Container buildArtistsWithData(BuildContext context, List<Artist> artists) {
  List<ArtistCard> artistList = new List<ArtistCard>();
  artists.forEach((artist) {
    artistList.add(new ArtistCard(artist: artist));
  });
  return Container(
    margin: EdgeInsets.only(
      left: 8,
      right: 8,
    ),
    child: ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: artistList,
    ),
  );
}

void submitAlbumName(BuildContext context, String query) {
  final albumBloc = BlocProvider.of<AlbumBloc>(context);
  final artistBloc = BlocProvider.of<ArtistBloc>(context);

  albumBloc.add(FetchedAlbumsByQuery(query));
  artistBloc.add(FetchedArtistsByQuery(query));
}
