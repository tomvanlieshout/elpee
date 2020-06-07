import 'package:elpee/pages/wall_picker.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pages/artist_page.dart';
import '../widgets/standard_appbar.dart';
import '../widgets/album_track_card_list.dart';

import '../bloc/bloc.dart';

import '../data/artist_repository.dart';
import '../data/model/artist.dart';
import '../data/model/album.dart';
import '../data/model/track.dart';
import 'package:elpee/helpers.dart';

class AlbumPage extends StatefulWidget {
  static final routeName = '/album-page';

  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  Album album;
  Artist artist;
  SharedPreferences _prefs;
  List<Track> tracks;
  String wikiLink;
  bool showSaveButton, _isGuest, _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _setPrefs();
  }

  _getArtistData(BuildContext context) {
    String id = album.artists[0]['id'];
    final artistBloc = ArtistBloc(ArtistRepositoryImpl());

    artistBloc.add(FetchedArtistById(id));

    artistBloc.listen((state) {
      if (state is ArtistLoadSuccess) {
        artist = state.artist;
      } else if (state is ArtistError) {
        Helpers.showFlushbar(context, 'Something went wrong. Please try again later.',
            Icon(FeatherIcons.alertTriangle, color: Colors.amber));
      }
    });

    artistBloc.close();
  }

  List<Track> _getTracks() {
    return Track.listFromMap(album.tracks['items']);
  }

  _setPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _isGuest = _prefs.getBool('isGuest');
      _isLoading = false;
    });
  }

  void _showBottomModal(BuildContext ctx) {
    showModalBottomSheet<void>(
      context: ctx,
      builder: (BuildContext context) {
        return Container(
          child: GestureDetector(
            onTap: () {
              Navigator.of(ctx).pop();
              Navigator.of(ctx).pushNamed(ArtistPage.routeName, arguments: artist);
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.15,
              color: Theme.of(context).primaryColor,
              child: Container(
                margin: EdgeInsets.only(top: 14, left: 14, right: 14, bottom: 14),
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
                      style: Theme.of(context).textTheme.bodyText1,
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

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (album == null || tracks == null) {
      album = arguments['model'];
      showSaveButton = arguments['showSaveButton'];
      tracks = _getTracks();
      _getArtistData(context);
    }

    return Scaffold(
      appBar: StandardAppbar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                            _showBottomModal(context);
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
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                Text(
                                  album.artists[0]['name'],
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: Theme.of(context).textTheme.bodyText2,
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
                                        onPressed: () {
                                          if (_isGuest) {
                                            Helpers.showFlushbar(context, 'Signing up is required to use this feature.',
                                                Icon(FeatherIcons.bell, color: Colors.amber));
                                          } else {
                                            Navigator.of(context)
                                                .pushNamed(WallPicker.routeName, arguments: {'album': album});
                                          }
                                        },
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
