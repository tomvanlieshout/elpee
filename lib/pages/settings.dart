import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elpee/bloc/bloc.dart';
import 'package:elpee/helpers.dart';
import 'package:elpee/widgets/change_password_form.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/about.dart';

class Settings extends StatefulWidget {
  static const routeName = "/settings";
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static final String tileCountKey = "tileCount";
  double tileCount;
  AuthBloc _bloc;
  int sliderCount;
  FirebaseUser _user;
  List<DropdownMenuItem> items = new List();
  bool isLoading = true;
  bool isGuest;
  SharedPreferences prefs;
  DropdownMenuItem _selectedDropdownItem;

  @override
  void initState() {
    _bloc = BlocProvider.of<AuthBloc>(context);
    isGuest = true;
    _getUserWallsFromFirestore();
    _getPreferences();
    super.initState();
  }

  void _getPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  double getSliderValue() {
    if (prefs != null && prefs.get(tileCountKey) != null) {
      if (prefs.get(tileCountKey) > 8.0) {
        return 8.0;
      }
      return prefs.get(tileCountKey);
    }
    return 2.0;
  }

  _getUserWallsFromFirestore() async {
    _user = await FirebaseAuth.instance.currentUser();
    if (_user == null) {
      setState(() {
        isGuest = true;
      });
    } else {
      isGuest = false;

      QuerySnapshot snapshot =
          await Firestore.instance.collection('users').document(_user.uid).collection('user-walls').getDocuments();
      items.add(DropdownMenuItem(
        value: 'fj3gDGj)12', // the id for default wall
        child: Text('The Default Wall'),
      ));
      if (snapshot.documents.length > 0) {
        snapshot.documents.forEach((doc) {
          items.add(DropdownMenuItem(
            value: doc.documentID,
            child: Text(doc['title'] ?? ''),
          ));
        });
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  _setTileCount() {
    setState(() {
      if (prefs.get(tileCountKey) != null && prefs.get(tileCountKey) <= 8.0) {
        tileCount = prefs.get(tileCountKey);
      } else {
        tileCount = 2.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (mounted && _user != null && prefs != null && items.isNotEmpty) {
      setState(() {
        _selectedDropdownItem = items.singleWhere(
          (val) => val.value == prefs.get('homeWall'),
          orElse: () => null,
        );
        _setTileCount();
        isLoading = false;
      });
    }

    if (mounted && isGuest && prefs != null) {
      _setTileCount();
      setState(() {
        isLoading = false;
      });
    }

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: WillPopScope(
              onWillPop: () async {
                return Future.value(false);
              },
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(bottom: 25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildGridSlider(),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                      isGuest ? Container() : _buildDropdownButton(),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                      ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          _buildAbout(),
                          isGuest ? Container() : _buildChangePasswordButton(),
                          isGuest ? Container() : _buildLogoutButton(),
                          SizedBox(height: 16),
                          isGuest ? Container() : _buildDeleteAccountButton(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  _buildGridSlider() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Amount of horizontal \nalbum tiles:",
            style: TextStyle(
              color: Color.fromRGBO(120, 120, 120, 1),
              fontSize: 24,
              fontFamily: 'roboto',
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Text(
          tileCount != null ? tileCount.round().toString() : '2',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 24,
            fontFamily: 'roboto',
            fontWeight: FontWeight.w600,
          ),
        ),
        Slider(
          value: getSliderValue(),
          onChanged: (value) {
            prefs.setDouble(tileCountKey, value);
            setState(() {
              tileCount = prefs.get(tileCountKey);
            });
          },
          min: 1.0,
          max: 8.0,
        ),
      ],
    );
  }

  _buildDropdownButton() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Set the wall shown on the \nhome screen:",
            style: TextStyle(
              color: Color.fromRGBO(120, 120, 120, 1),
              fontSize: 24,
              fontFamily: 'roboto',
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        DropdownButton(
          value: _selectedDropdownItem != null ? _selectedDropdownItem.value : null,
          items: items,
          onChanged: (_) {
            prefs.setString('homeWall', _);
            setState(() {
              _selectedDropdownItem = items.singleWhere(
                (val) => val.value == _,
                orElse: () => null,
              );
            });
          },
        ),
      ],
    );
  }

  _buildLogoutButton() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: OutlineButton(
        onPressed: () => _bloc.add(SignOut()),
        child: Text(
          'Logout',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'roboto',
            fontWeight: FontWeight.w300,
            color: Colors.amber,
          ),
        ),
        borderSide: BorderSide(color: Colors.amber, width: 1),
      ),
    );
  }

  _buildChangePasswordButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: OutlineButton(
        child: Text(
          'Change password',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'roboto',
            fontWeight: FontWeight.w300,
            color: Colors.blue,
          ),
        ),
        borderSide: BorderSide(color: Colors.blue, width: 1),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => ChangePasswordForm(),
          );
        },
      ),
    );
  }

  _buildDeleteAccountButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: OutlineButton(
        child: Text(
          'Delete account',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'roboto',
            fontWeight: FontWeight.w300,
            color: Colors.red,
          ),
        ),
        borderSide: BorderSide(color: Colors.red, width: 1),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildDeleteDialog(context),
          );
        },
      ),
    );
  }

  _buildAbout() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: OutlineButton(
        child: Text(
          'About elpee',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'roboto',
            fontWeight: FontWeight.w300,
          ),
        ),
        borderSide: BorderSide(color: Colors.white, width: 1),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildAboutDialog(context),
          );
        },
      ),
    );
  }

  Widget _buildAboutDialog(BuildContext context) {
    return Container(
      child: new AlertDialog(
        title: const Text('About elpee'),
        backgroundColor: Colors.black,
        content: SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              About(),
            ],
          ),
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 5),
            child: OutlineButton(
              child: Text('Close'),
              color: Colors.black,
              borderSide: BorderSide(color: Colors.white, width: 1),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteDialog(BuildContext context) {
    String password;

    return Container(
      child: new AlertDialog(
        title: const Text('Delete account'),
        backgroundColor: Colors.black,
        content: SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              Text('Enter your password to confirm'),
              TextFormField(
                obscureText: true,
                maxLines: 1,
                decoration: InputDecoration(hintText: 'Password'),
                onChanged: (_) => password = _,
                autofocus: true,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 5),
            child: OutlineButton(
              child: Text('Close'),
              borderSide: BorderSide(color: Colors.white, width: 1),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 5),
            child: OutlineButton(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              borderSide: BorderSide(color: Colors.red, width: 1),
              onPressed: () {
                if (password != null) {
                  _bloc.add(DeleteAccount(password));
                  Navigator.of(context).pop();
                } else {
                  Helpers.showFlushbar(
                      context, 'Password cannot be empty', Icon(FeatherIcons.alertTriangle, color: Colors.amber));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
