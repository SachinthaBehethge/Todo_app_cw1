import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget {
  final String title;

  SimpleAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.only(top: 30.0),
      height: 100.0,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0XFFFFB200),
              Color(0XFFFFB600),
            ],
          ),
          border: Border(bottom: BorderSide(width: 1.0, color: Colors.black12))),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
              color: Colors.black54,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w500,
              fontSize: 26.0),
        ),
      ),
    );
  }
}
