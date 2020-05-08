import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elpee/data/model/album.dart';
import 'package:elpee/widgets/album_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool _isLoading;
  double _tileCount;
  List<dynamic> albums = new List();

  @override
  void initState() {
    _isLoading = true;
    _fetchUser();
    super.initState();
  }

  _fetchUser() async {
    final u = await FirebaseAuth.instance.currentUser();
    setState(() {
      _user = u;
    });
  }

  void getPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs != null && mounted) {
      if (_prefs.get('homeWall') == null) {
        setState(() {
            _stream = Firestore.instance.collection('albums').snapshots();
          });
      } else {
        if (_prefs.get('homeWall') == 'default-wall') {
          setState(() {
            _stream = Firestore.instance.collection('albums').snapshots();
          });
        } else {
          setState(() {
            _stream = Firestore.instance
                .collection('users')
                .document(_user.uid)
                .collection('user-walls')
                .document(_prefs.get('homeWall'))
                .collection('albums')
                .snapshots();
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_user != null && _prefs == null) {
      getPreferences();
    }

    if (_user != null && _prefs != null && _stream != null && mounted) {
      setState(() {
        _tileCount = _prefs.getDouble('tileCount') ?? 2.0;
        _isLoading = false;
      });
    }

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
