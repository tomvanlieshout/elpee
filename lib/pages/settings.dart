import 'package:flutter/material.dart';
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
  int sliderCount = 2;
  bool isLoading = true;
  SharedPreferences prefs;

  void getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.get(tileCountKey) != null && mounted) {
      setState(() {
        prefs.get(tileCountKey) == null
            ? tileCount = 2.0
            : tileCount = prefs.get(tileCountKey);
      });
    } else {
      if (mounted) {
        setState(() {
          tileCount = 2.0;
        });
      }
    }
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

  @override
  Widget build(BuildContext context) {
    if (isLoading && mounted) {
      getPreferences();
      setState(() {
        if (prefs != null) {
          if (prefs.get(tileCountKey) != null &&
              prefs.get(tileCountKey) <= 8.0) {
            tileCount = prefs.get(tileCountKey);
          } else {
            tileCount = 2.0;
          }
        } else {
          getPreferences();
        }
        isLoading = false;
      });
    }
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(12.0),
                child: Text(
                  "Amount of horizontal album tiles:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              OutlineButton(
                child: Text(
                  'About elpee',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'roboto',
                    fontWeight: FontWeight.w300,
                  ),
                ),
                color: Colors.black,
                borderSide: BorderSide(color: Colors.white, width: 1),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildAboutDialog(context),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
