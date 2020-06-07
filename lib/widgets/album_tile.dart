import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
import '../pages/album_page.dart';
import '../data/model/album.dart';

class AlbumTile extends StatefulWidget {
  final Album albumModel;
  final SharedPreferences prefs;
  final Function selectCallback;
  final bool isSelected;
  final bool selectionState;

  AlbumTile({
    @required this.prefs,
    @required this.albumModel,
    this.selectCallback,
    @required this.isSelected,
    @required this.selectionState,
  });

  @override
  _AlbumTileState createState() => _AlbumTileState();
}

class _AlbumTileState extends State<AlbumTile> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      value: 1.0,
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _viewAlbum(BuildContext context) async {
    Navigator.of(context)
        .pushNamed(AlbumPage.routeName, arguments: {'model': widget.albumModel, 'showSaveButton': false});
  }

  int determineImageSize() {
    if (widget.prefs.get('tileCount') == null) {
      widget.prefs.setDouble('tileCount', 2.0);
    }
    switch (widget.prefs.get('tileCount').round()) {
      case 1:
        return 0;
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
        return 1;
      case 7:
        return 2;
      default:
        return 2;
    }
  }

  _select() {
    if (widget.selectCallback != null) {
      widget.selectCallback(widget.albumModel.id, !widget.isSelected);
      if (!widget.isSelected) {
        animationController.animateBack(0.8, duration: Duration(milliseconds: 150));
      } else {
        animationController.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isSelected) {
      animationController.forward();
    }
    return GestureDetector(
      onTap: widget.selectionState ? _select : () => _viewAlbum(context),
      onLongPress: _select,
      child: FutureBuilder(builder: (context, snapshot) {
        return Stack(
          alignment: Alignment.topRight,
          children: <Widget>[
            ScaleTransition(
              scale: animation,
              child: GridTile(
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: widget.albumModel.images[determineImageSize()]['url'],
                ),
              ),
            ),
            widget.isSelected
                ? Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 16,
                        spreadRadius: 1,
                      )
                    ]),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  )
                : Container(),
          ],
        );
      }),
    );
  }
}
