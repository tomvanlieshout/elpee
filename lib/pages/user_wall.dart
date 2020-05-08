import 'package:elpee/firestore/firestore_service.dart';
import 'package:elpee/helpers.dart';
import 'package:elpee/pages/search_form.dart';
import 'package:elpee/widgets/standard_appbar.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elpee/data/model/album.dart';
import 'package:elpee/widgets/album_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:elpee/data/model/user_wall.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserWallPage extends StatefulWidget {
  static final String routeName = '/user-wall';

  @override
  _UserWallPageState createState() => _UserWallPageState();
}

class _UserWallPageState extends State<UserWallPage> {
  FirebaseUser _user;
  UserWall wall;
  FirestoreService _firestoreService = FirestoreService();
  Map args;
  Stream<QuerySnapshot> _stream;
  List<String> _selectedIds = [];
  SharedPreferences _prefs;
  double _tileCount;
  bool _showAlternativeAppbar;
  bool _isLoading;

  @override
  void initState() {
    _isLoading = true;
    _showAlternativeAppbar = false;
    super.initState();
  }

  void _getPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs != null) {
      setState(() {});
    }
  }

  void _clearList() {
    setState(() {
      _selectedIds.clear();
      _showAlternativeAppbar = false;
    });
  }

  void selectAlbumTileCallback(String id, bool selected) {
    setState(() {
      if (selected) {
        _selectedIds.add(id);
      } else {
        _selectedIds.remove(id);
      }
      _showAlternativeAppbar = _selectedIds.length > 0;
    });
  }

  void _deleteAlbums() async {
    try {
      await _firestoreService.deleteAlbumsFromWall(_selectedIds, _user.uid, wall.id);
    } on PlatformException catch (e) {
      Helpers.showFlushbar(context, e.message, Icon(FeatherIcons.alertTriangle, color: Colors.amber));
    }
    _clearList();
  }

  AlertDialog _buildConfirmationDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromRGBO(32, 32, 32, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      title: Text(
        'Delete ${_selectedIds.length.toString()} album(s)?',
        style: TextStyle(
          fontWeight: FontWeight.w300,
        ),
      ),
      content: const Text(
        'Selected albums will be deleted.',
        style: TextStyle(
          fontWeight: FontWeight.w300,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text(
            'CANCEL',
            style: TextStyle(
              color: Color.fromRGBO(36, 159, 210, 1),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: const Text(
            'DELETE',
            style: TextStyle(
              color: Color.fromRGBO(220, 36, 36, 1),
            ),
          ),
          onPressed: () {
            _deleteAlbums();
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  AppBar _buildTileEditAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        'elpee',
        style: Theme.of(context).textTheme.headline,
      ),
      actions: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.15,
        ),
        IconButton(
          padding: EdgeInsets.only(right: 4, left: 4),
          onPressed: () => showDialog(context: context, builder: (context) => _buildConfirmationDialog(context)),
          icon: Icon(FeatherIcons.trash2),
        ),
        IconButton(
          padding: EdgeInsets.only(left: 4),
          onPressed: _clearList,
          icon: Icon(FeatherIcons.xCircle),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (wall == null || args == null || _user == null || _stream == null) {
      setState(() {
        args = ModalRoute.of(context).settings.arguments as Map;
        _user = args['user'];
        wall = args['wall'];
        _stream = Firestore.instance
            .collection('users')
            .document(_user.uid)
            .collection('user-walls')
            .document(wall.id)
            .collection('albums')
            .snapshots();
      });
    }
    if (_prefs == null) {
      _getPreferences();
    }
    if (wall != null && _user != null && _prefs != null && _stream != null) {
      setState(() {
        _tileCount = _prefs.getDouble('tileCount') ?? 2.0;
        _isLoading = false;
      });
    }

    return Scaffold(
      appBar: _showAlternativeAppbar ? _buildTileEditAppBar(context) : StandardAppbar(),
      backgroundColor: Theme.of(context).primaryColor,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
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
                    if (snapshot.data.documents.length == 0) {
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
                    } else {
                      return GridView.builder(
                        itemCount: snapshot.data.documents.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _tileCount != null ? _tileCount.round() : 2,
                        ),
                        itemBuilder: (context, index) {
                          Album albumModel = Album.fromMap(snapshot.data.documents[index].data);
                          return new AlbumTile(
                            albumModel: albumModel,
                            prefs: _prefs,
                            selectCallback: selectAlbumTileCallback,
                            isSelected: _selectedIds.contains(albumModel.id),
                            selectionState: _selectedIds.length > 0,
                          );
                        },
                      );
                    }
                  }
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(SearchForm.routeName, arguments: {'fromUserWall': true}),
        child: Icon(FeatherIcons.search),
      ),
    );
  }
}
