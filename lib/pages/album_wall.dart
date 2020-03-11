import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/album_tile.dart';

import '../data/model/album.dart';

class AlbumWall extends StatefulWidget {
  static const routeName = '/album-wall';

  @override
  _AlbumWallState createState() => _AlbumWallState();
}

class _AlbumWallState extends State<AlbumWall> {
  static const String tileCountKey = 'tileCount';
  SharedPreferences prefs;
  Stream<QuerySnapshot> stream =
      Firestore.instance.collection('albums').snapshots();

  List<DocumentSnapshot> _snapshotList = [];
  bool isLoading = true;
  double tileCount = 2.0;

  void getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.get(tileCountKey) != null) {
      if (mounted) {
        setState(() {
          tileCount = prefs.get(tileCountKey);
        });
      }
    } else {
      if (mounted) {
        setState(() {
          tileCount = 2.0;
        });
      }
    }
  }

  _shuffleAlbums() {
    setState(() {
      _snapshotList.shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      getPreferences();
      setState(() {
        if (prefs != null) {
          if (prefs.get(tileCountKey) != null) {
            tileCount = prefs.get(tileCountKey);
          } else {
            tileCount = 2.0;
          }
        } else {
          getPreferences();
        }
        isLoading = false;
      });
    }

    if (prefs != null) {
      if (tileCount != prefs.get(tileCountKey) && mounted) {
        setState(() {
          tileCount = prefs.get(tileCountKey);
        });
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: WillPopScope(
        onWillPop: () async {
          Future.value(false);
        },
        child: Center(
          child: StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: new CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                );
              } else {
                _snapshotList = snapshot.data.documents;
                return GridView.builder(
                  itemCount: snapshot.data.documents.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: tileCount != null ? tileCount.round() : 2,
                  ),
                  itemBuilder: (context, index) {
                    return new AlbumTile(
                      albumModel:
                          Album.fromMap(snapshot.data.documents[index].data),
                      prefs: prefs,
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _shuffleAlbums(),
        backgroundColor: Color.fromRGBO(25, 25, 25, 1.0),
        splashColor: Colors.amber,
        child: Icon(
          Icons.shuffle,
          color: Colors.white,
        ),
      ),
    );
  }
}
