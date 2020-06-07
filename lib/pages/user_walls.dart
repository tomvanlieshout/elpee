import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elpee/bloc/bloc.dart';
import 'package:elpee/firestore/auth.dart';
import 'package:elpee/firestore/firestore_service.dart';
import 'package:elpee/helpers.dart';
import 'package:elpee/widgets/user_wall_card.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserWalls extends StatefulWidget {
  static final String routeName = '/user-walls';

  @override
  _UserWallsState createState() => _UserWallsState();
}

class _UserWallsState extends State<UserWalls> {
  final _formKey = GlobalKey<FormState>();
  Stream<QuerySnapshot> _stream;
  AuthBloc _authBloc;
  FirestoreService _firestoreService = new FirestoreService();
  FirebaseUser _user;
  SharedPreferences _prefs;
  bool _validate = false;
  bool _isLoading;
  String title;
  String description;
  String _selectedId;
  bool _showAlternativeAppbar;

  @override
  void initState() {
    _isLoading = true;
    _showAlternativeAppbar = false;
    _authBloc = AuthBloc(Auth());
    _authBloc.add(FetchUser());
    super.initState();
  }

  void getPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs != null) {
      setState(() {});
    }
  }

  void selectWallCardCallback(String id, String t, String d, bool toggle) {
    setState(() {
      _selectedId = toggle ? id : null;
      title = t;
      description = d;
    });
  }

  _editWall(BuildContext context, String title, String description) {
    showDialog(context: context, builder: (context) => _buildNewWallDialog(true));
  }

  void _deleteWall(String wallId) async {
    try {
      _firestoreService.deleteWall(wallId, _user.uid);
    } on PlatformException catch (e) {
      Helpers.showFlushbar(
          context,
          e.message,
          Icon(
            Icons.error,
            color: Colors.amber,
          ));
    }
    _exitEditMode();
  }

  _exitEditMode() {
    setState(() {
      _selectedId = null;
      _showAlternativeAppbar = false;
    });
  }

  AlertDialog _buildDeleteConfirmationDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromRGBO(32, 32, 32, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      title: Text(
        'Delete this wall?',
        style: TextStyle(
          fontWeight: FontWeight.w300,
        ),
      ),
      content: const Text(
        'Selected wall will be deleted.',
        style: TextStyle(
          fontWeight: FontWeight.w300,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text(
            'CANCEL',
            style: TextStyle(
              color: Color.fromRGBO(36, 159, 210, 1),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: const Text(
            'DELETE',
            style: TextStyle(
              color: Color.fromRGBO(220, 36, 36, 1),
            ),
          ),
          onPressed: () {
            if (_selectedId != null) {
              _deleteWall(_selectedId);
            } else {
              Helpers.showFlushbar(context, 'Please select a wall first.', Icon(Icons.error, color: Colors.red));
            }
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  AppBar _buildTileEditAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Edit walls',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.15,
        ),
        IconButton(
          padding: EdgeInsets.only(right: 4),
          onPressed: _selectedId == null ? () {} : () => _editWall(context, title, description),
          icon: Icon(FeatherIcons.edit2),
        ),
        IconButton(
          padding: EdgeInsets.only(right: 4, left: 4),
          onPressed: _selectedId == null
              ? () {}
              : () => showDialog(context: context, builder: (context) => _buildDeleteConfirmationDialog(context)),
          icon: Icon(FeatherIcons.trash2),
        ),
        IconButton(
          padding: EdgeInsets.only(left: 4),
          onPressed: _exitEditMode,
          icon: Icon(FeatherIcons.xCircle),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _authBloc.listen((state) {
      if (state is AuthenticatedState && mounted) {
        setState(() {
          _user = state.user;
        });
      } else if (state is AuthError && mounted) {
        Scaffold.of(context).showSnackBar(new SnackBar(content: Text(state.message)));
      }
    });
    if (_isLoading) {
      getPreferences();
      if (_user != null && mounted) {
        _stream = Firestore.instance.collection('users').document(_user.uid).collection('user-walls').snapshots();
      }
    }
    if (_user != null && _prefs != null) {
      setState(() {
        _isLoading = false;
      });
    }
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: _showAlternativeAppbar
                ? _buildTileEditAppBar(context)
                : AppBar(
                    centerTitle: true,
                    title: Text(
                      'Your Walls',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(FeatherIcons.edit3),
                        onPressed: () {
                          setState(() {
                            _showAlternativeAppbar = true;
                          });
                        },
                      ),
                    ],
                  ),
            backgroundColor: Colors.black,
            body: Container(
              height: MediaQuery.of(context).size.height,
              child: StreamBuilder(
                stream: _stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    if (snapshot.data.documents.length == 0) {
                      return Center(
                        child: Text(
                          'You haven\'t created \nany walls yet.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(42, 42, 42, 1),
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          return UserWallCard(
                            wallMap: snapshot.data.documents[index].data,
                            selectCallback: selectWallCardCallback,
                            selectionState: _showAlternativeAppbar,
                            isSelected: _selectedId == snapshot.data.documents[index].data['id'],
                            user: _user,
                          );
                        },
                      );
                    }
                  }
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(context: context, builder: (context) => _buildNewWallDialog(false));
              },
              backgroundColor: Theme.of(context).accentColor,
              child: Icon(FeatherIcons.folderPlus),
            ),
          );
  }

  bool _validateForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      return true;
    } else {
      setState(() {
        _validate = true;
      });
      return false;
    }
  }

  String _validateTitle(String title) {
    if (title.trim() == null || title.trim().length == 0) {
      return 'A title is required.';
    } else {
      return null;
    }
  }

  _submitForm(bool isEditMode) async {
    if (_validateForm()) {
      if (isEditMode) {
        try {
          _firestoreService.editUserWall(title, description ?? '', _user.uid, _selectedId);
        } on PlatformException catch (e) {
          Helpers.showFlushbar(context, e.message, Icon(Icons.error, color: Colors.amber));
          print(e.message);
        }
      } else {
        try {
          await _firestoreService.createUserWall(
            title,
            description,
            _user.uid,
            DateTime.now(),
          );
          setState(() {
            title = '';
            description = '';
          });
        } on PlatformException catch (e) {
          print(e.message);
        }
      }
    }
  }

  _buildNewWallDialog(bool isEditMode) {
    return AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      actions: <Widget>[
        FlatButton(
          child: Icon(FeatherIcons.check, size: 28),
          onPressed: isEditMode
              ? () {
                  _submitForm(isEditMode);
                  _exitEditMode();
                  Navigator.of(context).pop();
                }
              : () {
                  _submitForm(isEditMode);
                  Navigator.of(context).pop();
                },
        ),
        FlatButton(
          child: Icon(FeatherIcons.x, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
      title: Text(
        isEditMode ? 'Edit wall' : 'Create a wall',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Form(
              key: _formKey,
              autovalidate: _validate,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Title',
                    ),
                    initialValue: title,
                    onChanged: (_) => title = _,
                    validator: (_) => _validateTitle(_),
                  ),
                  Container(height: 16),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                    initialValue: description,
                    onChanged: (_) => description = _,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
