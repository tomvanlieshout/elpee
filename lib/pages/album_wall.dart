import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elpee/data/model/album.dart';
import 'package:elpee/helpers.dart';
import 'package:elpee/widgets/album_tile.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlbumWall extends StatefulWidget {
  static const routeName = '/album-wall';

  @override
  _AlbumWallState createState() => _AlbumWallState();
}

class _AlbumWallState extends State<AlbumWall> {
  FirebaseUser _user;
  Stream<QuerySnapshot> _stream;
  SharedPreferences _prefs;
  bool _isLoading, _isGuest;
  double _tileCount;
  List<dynamic> albums = new List();

  @override
  void initState() {
    _isLoading = true;
    _setData().then((_) {
      // show flushbar if guest, after short delay
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Future.delayed(timeStamp, () {
          if (_isGuest) {
            Helpers.showFlushbar(context, 'Guests have limited access to elpee\'s features.',
                Icon(FeatherIcons.bell, color: Colors.amber),
                duration: 4,
                position: FlushbarPosition.TOP,
                shouldIconPulse: true,
                margin: EdgeInsets.fromLTRB(16, 32, 16, 16));
          }
        });
      });
    });
    super.initState();
  }

  _setData() async {
    _prefs = await SharedPreferences.getInstance();
    _user = await FirebaseAuth.instance.currentUser();

    _isGuest = _prefs.getBool('isGuest');
    if (_isGuest) {
      _stream = Firestore.instance.collection('albums').snapshots();
    } else if (_user != null) {
      if (_prefs.get('homeWall') != null) {
        if (_prefs.get('homeWall') == 'fj3gDGj)12') {
          _stream = Firestore.instance.collection('albums').snapshots();
        } else {
          _stream = Firestore.instance
              .collection('users')
              .document(_user.uid)
              .collection('user-walls')
              .document(_prefs.get('homeWall'))
              .collection('albums')
              .snapshots();
        }
      } else {
        _stream = Firestore.instance.collection('albums').snapshots();
      }
    }
    _tileCount = _prefs.getDouble('tileCount') ?? 2.0;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: WillPopScope(
              onWillPop: () async {
                Future.value(false);
              },
              child: Center(
                child: StreamBuilder(
                  stream: _stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: new CircularProgressIndicator(
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      );
                    } else {
                      if (snapshot.data.documents.length > 0) {
                        albums = snapshot.data.documents;
                        return GridView.builder(
                          itemCount: snapshot.data.documents.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: _tileCount != null ? _tileCount.round() : 2,
                          ),
                          itemBuilder: (context, index) {
                            return new AlbumTile(
                              albumModel: Album.fromMap(snapshot.data.documents[index].data),
                              prefs: _prefs,
                              // Set it to null here, because no one
                              // should be able to delete from The Wall
                              selectCallback: null,
                              isSelected: false,
                              selectionState: false,
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Text(
                            'Search for albums and add \nthem to your wall.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(42, 42, 42, 1),
                              fontSize: 24,
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ),
          );
  }
}
