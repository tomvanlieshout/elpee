import 'package:flutter/material.dart';

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
