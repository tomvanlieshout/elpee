import 'package:elpee/pages/home.dart';
import 'package:elpee/pages/settings.dart';
import 'package:flutter/material.dart';

// PAGES
import './pages/album_wall.dart';
import './pages/artist_page.dart';
import './pages/search_form.dart';
import './pages/album_page.dart';

// SERVICE LOCATOR
import './service_locator.dart';

void main() {
  setupLocator();
  runApp(Elpee());
}

class Elpee extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'elpee',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (ctx) => Home(),
        Home.routeName: (ctx) => Home(),
        AlbumWall.routeName: (ctx) => AlbumWall(),
        AlbumPage.routeName: (ctx) => AlbumPage(),
        ArtistPage.routeName: (ctx) => ArtistPage(),
        SearchForm.routeName: (ctx) => SearchForm(),
        Settings.routeName: (ctx) => Settings(),
      },
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        accentColor: Colors.amber,
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          headline: TextStyle(
            fontSize: 34,
            fontFamily: 'Burgundy',
            color: Colors.white,
          ),
          title: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          body1: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
          body2: TextStyle(
            fontSize: 16,
            color: Color.fromRGBO(118, 118, 127, 1.0),
          ),
        ),
      ),
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (ctx) => AlbumWall());
      },
    );
  }
}
