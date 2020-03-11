import '../data/model/artist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flushbar/flushbar.dart';

import '../bloc/bloc.dart';
import '../data/artist_repository.dart';

class ArtistBioTab extends StatefulWidget {
  final Artist artist;

  ArtistBioTab({@required this.artist});

  @override
  _ArtistBioTabState createState() => _ArtistBioTabState();
}

class _ArtistBioTabState extends State<ArtistBioTab> {
  String htmlData;
  bool isLoading = true;

  Future _getWikiText() async {
    final artistBloc = ArtistBloc(ArtistRepositoryImpl());

    artistBloc.add(FetchedWikipediaArticle(widget.artist.name));

    artistBloc.listen((state) {
      if (state is WikipediaPageLoadSuccess && mounted) {
        setState(() {
          htmlData = state.htmlData;
        });
      } else if (state is ArtistError) {
        _showError(context, state.message);
      }
    });
    artistBloc.close();
  }

  _showError(BuildContext context, String message) {
    return Flushbar(
      message: message,
      duration: Duration(seconds: 4),
      isDismissible: true,
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: Colors.black,
      borderRadius: 8,
      margin: EdgeInsets.all(8),
      borderColor: Colors.white,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      icon: Icon(Icons.error, color: Colors.amber),
      overlayBlur: 2,
      shouldIconPulse: false,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      _getWikiText().then((_) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      });
    }

    return isLoading
        ? Container(child: CircularProgressIndicator())
        : Container(
            margin: EdgeInsets.only(left: 12, bottom: 15),
            child: Html(
              data: htmlData ?? '',
              linkStyle: TextStyle(
                color: Colors.white,
              ),
              defaultTextStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
            ),
          );
  }
}
