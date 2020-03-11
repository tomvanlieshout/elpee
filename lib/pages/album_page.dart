import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flushbar/flushbar.dart';

import '../firestore/firestore_service.dart';
import '../pages/artist_page.dart';
import '../widgets/standard_appbar.dart';
import '../widgets/album_track_card_list.dart';

import '../bloc/bloc.dart';

import '../data/artist_repository.dart';
import '../data/model/artist.dart';
import '../data/model/album.dart';
import '../data/model/track.dart';
import '../data/model/top_track.dart';

class AlbumPage extends StatelessWidget {
  static final routeName = '/album-page';
  Album album;
  bool showSaveButton;
  Artist artist;
  List<TopTrack> topTracks;
  List<Track> tracks;
  List<Album> albums;
  String wikiLink;

  _getArtistData(BuildContext context) {
    String id = album.artists[0]['id'];
    final artistBloc = ArtistBloc(ArtistRepositoryImpl());

    artistBloc.add(FetchedArtistById(id));

    artistBloc.listen((state) {
      if (state is ArtistLoadSuccess) {
        artist = state.artist;
      } else if (state is ArtistError) {
        _showFlushBar(
          context, 'Something went wrong. Please try again later.'
        );
      }
    });

    artistBloc.close();
  }

  _showFlushBar(BuildContext context, String message) {
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

  List<Track> _getTracks() {
    return Track.listFromMap(album.tracks['items']);
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (album == null || tracks == null) {
      album = arguments['model'];
      showSaveButton = arguments['showSaveButton'];
      tracks = _getTracks();
      _getArtistData(context);
    }

    _addAlbum(BuildContext context) {
      createAlbum(album).then((didSucceed) {
        if (didSucceed) {
          _showFlushBar(context, '${album.name} has been saved to The Wall');
        } else {
          _showFlushBar(context,
              'Either something went wrong, or the album already exists.');
        }
      });
    }

    _viewArtist() {
      Navigator.of(context).pushNamed(ArtistPage.routeName, arguments: artist);
    }

    void _showBottomModal() {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                _viewArtist();
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.15,
                color: Theme.of(context).primaryColor,
                child: Container(
                  margin:
                      EdgeInsets.only(top: 14, left: 14, right: 14, bottom: 14),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.person,
                          color: Colors.amber,
                        ),
                      ),
                      Text(
                        'Go to artist',
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: StandardAppbar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: album.images[0]['url'],
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _showBottomModal();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            album.name,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                            style: Theme.of(context).textTheme.title,
                          ),
                          Text(
                            album.artists[0]['name'],
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                            style: Theme.of(context).textTheme.body2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      showSaveButton
                          ? Column(
                              children: <Widget>[
                                IconButton(
                                  onPressed: () => _addAlbum(context),
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: Colors.white,
                                    size: 34,
                                  ),
                                ),
                                Text(
                                  'Add to Wall',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      Container(
                        margin: EdgeInsets.only(bottom: 9),
                        child: IconButton(
                          onPressed: () {
                            if (album.externalUrls != null) {
                              launch(album.externalUrls['spotify']);
                            }
                          },
                          icon: Image.asset(
                            'assets/images/spotify-logo.png',
                            width: 128,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.white60,
              endIndent: 12.0,
              indent: 12.0,
            ),
            AlbumTrackCardList(album, tracks),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
