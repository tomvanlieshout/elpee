import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../data/model/artist.dart';

import '../pages/artist_page.dart';

class ArtistCard extends StatelessWidget {
  final Artist artist;

  ArtistCard({@required this.artist});

  void _viewArtist(BuildContext context) {
    Navigator.of(context).pushNamed(ArtistPage.routeName, arguments: artist);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _viewArtist(context),
      child: Card(
        color: Theme.of(context).primaryColor,
        child: Row(
          children: <Widget>[
            artist.images.isNotEmpty
                ? Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: FadeInImage.memoryNetwork(
                        image: artist.images[2]['url'],
                        placeholder: kTransparentImage,
                        height: 64,
                        width: 64,
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: new Image.asset(
                      'assets/images/placeholder.png',
                      height: 64,
                      width: 64,
                    ),
                  ),
            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.75,
              child: Text(
                artist.name,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: Theme.of(context).textTheme.body1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
