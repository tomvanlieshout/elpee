import 'dart:math';
import 'dart:ui';

import 'package:elpee/data/model/user_wall.dart';
import 'package:elpee/firestore/firestore_service.dart';
import 'package:elpee/pages/user_wall.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserWallCard extends StatefulWidget {
  final Map<String, dynamic> wallMap;
  final FirebaseUser user;
  final Function selectCallback;
  final bool selectionState;
  final bool isSelected;

  UserWallCard({
    @required this.wallMap,
    @required this.user,
    @required this.selectCallback,
    @required this.selectionState,
    @required this.isSelected,
  });

  @override
  _UserWallCardState createState() => _UserWallCardState();
}

class _UserWallCardState extends State<UserWallCard> {
  FirestoreService _firestoreService = FirestoreService();
  Map<String, dynamic> wallMap;
  List<String> urlList;
  String title;
  String description;
  UserWall wall;
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    wallMap = widget.wallMap;
    _initData();
  }

  // To make StreamBuilder update StatefulWidgets
  // https://github.com/flutter/flutter/issues/20416
  @override
  void didUpdateWidget(UserWallCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (wallMap != widget.wallMap) {
      setState(() {
        wallMap = widget.wallMap;
      });
    }
  }

  _initData() async {
    if (mounted) {
      final albums = await _firestoreService.getUserWallAlbums(widget.wallMap['id'], widget.user.uid);
      setState(() {
        wall = UserWall.fromMap(wallMap, albums);
        urlList = wall.albums.length > 3 ? _generateThumbnail() : new List();
        _isLoading = false;
      });
    }
  }

  List<String> _generateThumbnail() {
    List<String> result = new List();
    for (int i = 0; i < 4; i++) {
      result.add(wall.albums[i]['images'][2]['url']);
    }
    return result;
  }

  Widget _buildPlaceholder() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Color.fromRGBO(32, 32, 32, 1),
                width: 2,
              )),
          width: 88,
          height: 88,
          margin: EdgeInsets.all(8),
          child: Icon(
            FeatherIcons.music,
            size: 48,
            color: Color.fromRGBO(32, 32, 32, 1),
          ),
        ),
      ],
    );
  }

  Widget _buildAlbumCollage() {
    return Container(
      margin: EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.network(urlList[0], scale: 1.5),
              Image.network(urlList[1], scale: 1.5),
            ],
          ),
          Row(
            children: <Widget>[
              Image.network(urlList[2], scale: 1.5),
              Image.network(urlList[3], scale: 1.5),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container()
        : Container(
            child: GestureDetector(
              onTap: () => Navigator.of(context)
                  .pushNamed(UserWallPage.routeName, arguments: {'wall': wall, 'user': widget.user}),
              child: Container(
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
                child: Row(
                  children: <Widget>[
                    urlList.length > 3 ? _buildAlbumCollage() : _buildPlaceholder(),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            wallMap['title'] ?? '',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            wallMap['description'] ?? '',
                            style: TextStyle(
                              color: Color.fromRGBO(60, 60, 60, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    widget.selectionState
                        ? Checkbox(
                            value: widget.isSelected,
                            onChanged: (val) {
                              widget.selectCallback(wallMap['id'], wallMap['title'], wallMap['description'], val);
                            },
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          );
  }
}
