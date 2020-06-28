import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Icon(Icons.wb_sunny),
            onPressed: () {
              Navigator.pushNamed(context, '/sun');
            },
          )
        ],
      ),
    );
  }
}
