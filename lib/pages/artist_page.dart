import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flushbar/flushbar.dart';

import '../widgets/artist_top_tracks_tab.dart';
import '../widgets/artists_album_tab.dart';
import '../widgets/artist_bio_tab.dart';
import '../widgets/standard_appbar.dart';

import '../bloc/bloc.dart';
import '../data/model/top_track.dart';
import '../data/model/album.dart';
import '../data/model/artist.dart';
import '../data/album_repository.dart';
import '../data/artist_repository.dart';

class ArtistPage extends StatefulWidget {
  static const routeName = 'artist-page';

  @override
  _ArtistPageState createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  static final routeName = 'artist-page';
  Artist artist;
  List<Album> albums = new List<Album>();
  List<TopTrack> topTracks = new List<TopTrack>();
  int _selectedIndex = 0;
  String _wikiLink;
  final albumBloc = AlbumBloc(AlbumRepositoryImpl());
  final artistBloc = ArtistBloc(ArtistRepositoryImpl());

  void _onNavigationBarTap(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _selectTabPage(int index) {
    switch (index) {
      case 0:
        return albums.isNotEmpty
            ? ArtistsAlbumTab(albums: albums)
            : _buildLoading();
      case 1:
        return topTracks.isNotEmpty
            ? ArtistTopTracksTab(
                artistModel: artist,
                topTracks: topTracks,
              )
            : _buildLoading();
      case 2:
        return ArtistBioTab(
          artist: artist,
        );
      default:
        return albums.isNotEmpty
            ? ArtistsAlbumTab(albums: albums)
            : _buildLoading();
    }
  }

  bool hasData() {
    if (artist != null && albums.isNotEmpty && topTracks.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  _getFullAlbums(BuildContext context) {
    albumBloc.add(FetchedAlbumsByArtistId(artist.id));

    albumBloc.listen((state) {
      if (state is AlbumsLoadSuccess) {
        setState(() {
          albums = state.albums;
        });
      } else if (state is AlbumError) {
        _showError(context, state.message);
      }
    });

    albumBloc.close();
  }

  _getTopTracks(BuildContext context) {
    artistBloc.add(FetchedArtistTopTracks(artist.id));
    artistBloc.add(FetchedWikipediaLink(artist.name));

    artistBloc.listen((state) {
      if (state is TopTracksLoadSuccess) {
        setState(() {
          topTracks = state.topTracks;
        });
      } else if (state is WikipediaLinkLoadSuccess) {
        setState(() {
          if (state.link != null) {
            _wikiLink = state.link;
          } else {
            _wikiLink = null;
          }
        });
      } else if (state is ArtistError) {
        // Not showing error, because this is shown twice
        // and triggered on opening artist page as opposed to
        // opening bio tab.
      }
    });

    artistBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    if (!hasData()) {
      artist = ModalRoute.of(context).settings.arguments;
      _getFullAlbums(context);
      _getTopTracks(context);
    }
    return GestureDetector(
      child: Scaffold(
        appBar: StandardAppbar(),
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).primaryColor,
        bottomNavigationBar: _buildBottomNavigationBar(),
        body: !hasData()
            ? Column(children: <Widget>[
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ])
            : AnimatedOpacity(
                opacity: hasData() ? 1.0 : 0.0,
                duration: Duration(milliseconds: 300),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: artist.images != null
                            ? Image.network(
                                artist.images[0]['url'],
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                artist.name,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: Theme.of(context).textTheme.title,
                              ),
                            ),
                            _wikiLink != null || _wikiLink == ''
                                ? IconButton(
                                    iconSize: 36,
                                    icon: Icon(Icons.language),
                                    onPressed: () => launch(_wikiLink),
                                  )
                                : Container(),
                            Container(
                              margin: EdgeInsets.only(left: 12, right: 5),
                              child: GestureDetector(
                                child: Image.asset(
                                  'assets/images/spotify-logo.png',
                                  scale: 15,
                                ),
                                onTap: () {
                                  launch(artist.externalUrls['spotify']);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      _selectTabPage(_selectedIndex)
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  _showError(BuildContext context, String message) {
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

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColor,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.album,
            color: _selectedIndex == 0 ? Colors.amber : Colors.white,
          ),
          title: Text(
            'Albums',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.music_note,
            color: _selectedIndex == 1 ? Colors.amber : Colors.white,
          ),
          title: Text(
            'Top Tracks',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.import_contacts,
            color: _selectedIndex == 2 ? Colors.amber : Colors.white,
          ),
          title: Text(
            'Bio',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
      onTap: _onNavigationBarTap,
    );
  }
}
