import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  About();
  final String gitLab = 'View the source code on Gitlab:';
  final String about =
      'Elpee is a Flutter/Dart application developed by Tom van Lieshout between August 2019 and March 2020. \n\nThe app uses the Spotify and MediaWiki APIs, as well as a Cloud Firestore database. For state management, the BLoC pattern was used.';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Text(
            about,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                right: 12.0,
                top: 12.0,
              ),
              width: MediaQuery.of(context).size.width * 0.3,
              child: Text(
                gitLab,
                style: TextStyle(
                  // fontWeight: FontWeight.w300,
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: IconButton(
                icon: Image.asset('assets/images/gitlab-logo.png'),
                tooltip: 'Open Gitlab',
                onPressed: () =>
                    launch('https://gitlab.com/tomvanlieshout2/elpee'),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Text(
            'For business inquiries, please contact elpee.inquiries@gmail.com',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
