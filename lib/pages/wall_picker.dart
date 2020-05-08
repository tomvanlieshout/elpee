import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elpee/data/model/album.dart';
import 'package:elpee/firestore/firestore_service.dart';
import 'package:elpee/helpers.dart';
import 'package:elpee/widgets/standard_appbar.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:elpee/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WallPicker extends StatefulWidget {
  static final String routeName = '/wall-picker';

  @override
  _WallPickerState createState() => _WallPickerState();
}

class _WallPickerState extends State<WallPicker> {
  Album album;
  FirestoreService _firestoreService = new FirestoreService();
  AuthBloc _authBloc;
  bool _isLoading;
  FirebaseUser _user;
  List<String> _checkedWallIds = [];
  Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    _isLoading = true;
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _authBloc.add(FetchUser());
    super.initState();
  }

  _addAlbumToWalls(BuildContext ctx) {
    _firestoreService
        .addAlbumToWalls(
      album,
      _user.uid,
      _checkedWallIds,
    )
        .then((didSucceed) {
      if (didSucceed) {
        Navigator.of(context).pop();
        Helpers.showFlushbar(ctx, '${album.name} by ${album.artists[0]['name']} has been saved to your wall(s)',
            Icon(Icons.info_outline, color: Colors.green),
            borderColor: Colors.green);
      } else {
        Helpers.showFlushbar(ctx, 'Something went wrong. Please try again later.',
            Icon(FeatherIcons.alertTriangle, color: Colors.amber));
      }
    });
  }

  Widget _buildAlbumCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            margin: EdgeInsets.only(right: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  album.name,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 26,
                  ),
                ),
                Text(
                  album.artists[0]['name'],
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w300,
                    fontSize: 18,
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            child: Image.network(
              album.images[2]['url'],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (album == null) {
      Map args = ModalRoute.of(context).settings.arguments as Map;
      setState(() {
        album = args['album'];
      });
    }
    _authBloc.listen((state) {
      if (state is AuthenticatedState && mounted) {
        setState(() {
          _user = state.user;
        });
      } else if (state is AuthError && mounted) {
        Scaffold.of(context).showSnackBar(new SnackBar(content: Text(state.message)));
      }
    });
    if (_user != null && album != null) {
      _stream = Firestore.instance.collection('users').document(_user.uid).collection('user-walls').snapshots();
      setState(() {
        _isLoading = false;
      });
    }

    Widget _buildCard(List<DocumentSnapshot> items, int index) {
      return Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.topRight,
            colors: [
              Color.fromRGBO(12, 12, 12, 1),
              Color.fromRGBO(12, 12, 12, 0.0),
            ],
          ),
        ),
        child: ListTile(
          title: Text(
            items[index].data['title'],
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
            ),
          ),
          subtitle: Text(
            items[index].data['description'] ?? '',
            style: TextStyle(
              color: Color.fromRGBO(80, 80, 80, 1),
              fontSize: 18,
              fontWeight: FontWeight.w300,
            ),
          ),
          trailing: Checkbox(
            value: _checkedWallIds.contains(items[index].data['id']),
            onChanged: (val) {
              if (val) {
                setState(() {
                  _checkedWallIds.add(items[index].data['id']);
                });
              } else {
                setState(() {
                  _checkedWallIds.remove(items[index].data['id']);
                });
              }
            },
          ),
        ),
      );
    }

    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: StandardAppbar(),
            backgroundColor: Colors.black,
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Add this album to a wall',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
                      ),
                    ),
                    _buildAlbumCard(context),
                    Divider(
                      color: Colors.white12,
                      thickness: 1,
                      indent: 32,
                      endIndent: 32,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.61,
                      child: StreamBuilder(
                        stream: _stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                return _buildCard(snapshot.data.documents, index);
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: new FloatingActionButton(
              onPressed: () => _addAlbumToWalls(context),
              child: Icon(FeatherIcons.save),
            ),
          );
  }
}
