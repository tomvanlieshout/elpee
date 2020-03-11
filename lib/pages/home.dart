import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc.dart';
import '../data/album_repository.dart';
import '../data/artist_repository.dart';

import './album_wall.dart';
import './search_form.dart';
import './settings.dart';

class Home extends StatefulWidget {
  static final String routeName = "/home";
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      AlbumWall(),
      MultiBlocProvider(
        providers: [
          BlocProvider<AlbumBloc>(
            create: (context) => AlbumBloc(AlbumRepositoryImpl()),
          ),
          BlocProvider<ArtistBloc>(
            create: (context) => ArtistBloc(ArtistRepositoryImpl()),
          ),
        ],
        child: SearchForm(),
      ),
      Settings(),
    ];
    super.initState();
  }

  void _selectPage(int index) {
    if (mounted) {
      setState(() {
        _selectedPageIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[new Container()],
        title: Text(
          'elpee',
          style: Theme.of(context).textTheme.headline,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/brick-logo.png',
              color: _selectedPageIndex == 0 ? Colors.amber : Colors.white,
              width: 24,
            ),
            title: Text(
              'The Wall',
              style: TextStyle(
                color: _selectedPageIndex == 0 ? Colors.amber : Colors.white,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: _selectedPageIndex == 1 ? Colors.amber : Colors.white,
            ),
            title: Text(
              'Search',
              style: TextStyle(
                color: _selectedPageIndex == 1 ? Colors.amber : Colors.white,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: _selectedPageIndex == 2 ? Colors.amber : Colors.white,
            ),
            title: Text(
              'Settings',
              style: TextStyle(
                color: _selectedPageIndex == 2 ? Colors.amber : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
