import 'package:elpee/helpers.dart';
import 'package:elpee/pages/user_walls.dart';
import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elpee/bloc/bloc.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  AuthBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  _buildHeader() {
    return Column(
      children: <Widget>[
        Container(
          height: 128,
          width: 128,
          margin: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 64),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(80),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(80),
            child: Image.asset('assets/images/placeholder.png'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<ListTile> _drawerItems = [
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(UserWalls.routeName);
        },
        leading: Container(
          width: 2,
          height: 48,
          color: Color.fromRGBO(249, 194, 46, 1.0),
        ),
        title: Text(
          'My Walls',
          overflow: TextOverflow.fade,
          softWrap: false,
          maxLines: 1,
          style: TextStyle(
            color: Color.fromRGBO(241, 247, 237, 1.0),
            fontWeight: FontWeight.w300,
            fontSize: 24,
          ),
        ),
      ),
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        onTap: () {
          Navigator.of(context).pop();
          Helpers.showFlushbar(
            context,
            'Coming soon!',
            Icon(Icons.assistant_photo, color: Colors.amber),
          );
        },
        leading: Container(
          width: 2,
          height: 48,
          color: Color.fromRGBO(167, 153, 183, 1.0),
        ),
        title: Text(
          'Group Walls',
          overflow: TextOverflow.fade,
          softWrap: false,
          maxLines: 1,
          style: TextStyle(
            color: Color.fromRGBO(241, 247, 237, 1.0),
            fontWeight: FontWeight.w300,
            fontSize: 24,
          ),
        ),
      ),
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        onTap: () {
          Navigator.of(context).pop();
          Helpers.showFlushbar(
            context,
            'Coming soon!',
            Icon(Icons.assistant_photo, color: Colors.amber),
          );
        },
        leading: Container(
          width: 2,
          height: 48,
          color: Color.fromRGBO(180, 210, 231, 1.0),
        ),
        title: Text(
          'Profile Settings',
          overflow: TextOverflow.fade,
          softWrap: false,
          maxLines: 1,
          style: TextStyle(
            color: Color.fromRGBO(241, 247, 237, 1.0),
            fontWeight: FontWeight.w300,
            fontSize: 24,
          ),
        ),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(0, 5, 8, 1),
            Color.fromRGBO(0, 12, 50, 1),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildHeader(),
          ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: _drawerItems,
          ),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        _bloc.add(SignOut());
      },
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomLeft,
            child: Container(
              alignment: Alignment.center,
              height: 48,
              width: 78,
              margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                'Logout',
                overflow: TextOverflow.fade,
                softWrap: false,
                maxLines: 1,
                style: TextStyle(
                  color: Color.fromRGBO(241, 247, 237, 1.0),
                  fontWeight: FontWeight.w300,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          Icon(FeatherIcons.logOut, size: 20),
        ],
      ),
    );
  }
}
