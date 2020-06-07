import 'package:elpee/pages/home_guest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elpee/bloc/bloc.dart';
import 'package:elpee/data/album_repository.dart';
import 'package:elpee/data/artist_repository.dart';

// PAGES
import './pages/root_page.dart';
import './pages/sign_up_page.dart';
import './pages/forgot_password.dart';
import './pages/album_wall.dart';
import './pages/artist_page.dart';
import './pages/user_walls.dart';
import './pages/user_wall.dart';
import './pages/search_form.dart';
import './pages/album_page.dart';
import './pages/home.dart';
import './pages/settings.dart';
import './pages/wall_picker.dart';

import './firestore/auth.dart';
import './service_locator.dart';

void main() {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  // More info: https://flutter.dev/docs/cookbook/plugins/picture-using-camera
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();
  runApp(Elpee());
}

class Elpee extends StatelessWidget {
  final Auth _auth = new Auth();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(_auth),
      child: MaterialApp(
        title: 'elpee',
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => RootPage(),
          RootPage.routeName: (context) => RootPage(),
          SignUp.routeName: (context) => SignUp(),
          ForgotPassword.routeName: (context) => ForgotPassword(),
          Home.routeName: (context) => Home(),
          HomeGuest.routeName: (context) => HomeGuest(),
          AlbumWall.routeName: (context) => AlbumWall(),
          UserWalls.routeName: (context) => UserWalls(),
          UserWallPage.routeName: (context) => UserWallPage(),
          AlbumPage.routeName: (context) => AlbumPage(),
          ArtistPage.routeName: (context) => ArtistPage(),
          SearchForm.routeName: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => ArtistBloc(ArtistRepositoryImpl()),
                  ),
                  BlocProvider(
                    create: (context) => AlbumBloc(AlbumRepositoryImpl()),
                  ),
                ],
                child: SearchForm(),
              ),
          Settings.routeName: (context) => Settings(),
          WallPicker.routeName: (context) => WallPicker(),
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (context) => RootPage());
        },
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          accentColor: Colors.amber,
          cardColor: Color.fromRGBO(9, 15, 34, 1),
          fontFamily: 'Roboto',
          textTheme: TextTheme(
            headline5: TextStyle(
              fontSize: 34,
              fontFamily: 'Burgundy',
              color: Colors.white,
            ),
            headline6: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            bodyText1: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
            bodyText2: TextStyle(
              fontSize: 16,
              color: Color.fromRGBO(118, 118, 127, 1.0),
            ),
          ),
        ),
      ),
    );
  }
}
