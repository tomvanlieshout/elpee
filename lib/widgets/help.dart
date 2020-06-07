import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  static final String theWall =
      'The Wall is a pool of albums that anyone can add albums to. Share and explore!';
  static final String links =
      'You can open Albums or Artist Pages directly in your Spotify app, or open an Artist\'s Wikipedia page.';
  static final String addAlbum =
      'When on an Album Page, tap this icon to add it to one or more of your walls.';
  static final String track =
      'You can play 30-second preview links with the play button. Some tracks aren\'t available due to copyrighted material.';
  static final String artist =
      'When you\'re viewing an album, you can navigate to the album\'s artist by tapping the artist\'s name';
  static final String home =
      'Wherever you are, you can always navigate to The Wall by tapping the elpee logo!';
  Help();

  final List<Widget> cardList = [
    // HelpCard(theWall, 'assets/help-cards/the_wall_focus.png'), // The Wall
    HelpCard(links, 'assets/help-cards/links_focus.png'), // Links
    HelpCard(addAlbum, 'assets/help-cards/add_album_focus.png'), // Add Album
    HelpCard(artist, 'assets/help-cards/artist_focus.png'), // Artist
    HelpCard(track, 'assets/help-cards/track_focus.png'), // Track
    HelpCard(home, 'assets/help-cards/home_focus.png'), // Home
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListWheelScrollView(
        itemExtent: 300,
        children: cardList,
        offAxisFraction: -0.8,
      ),
    );
  }
}

class HelpCard extends StatelessWidget {
  final String content;
  final String image;

  HelpCard(this.content, this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.black),
      child: Column(
        children: <Widget>[
          Container(
            child: Image.asset(
              image,
              scale: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              content,
              style: TextStyle(
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}