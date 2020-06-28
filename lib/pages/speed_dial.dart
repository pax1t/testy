
import 'package:flutter/material.dart';

class SpeedDialList extends StatefulWidget {
  @override
  _SpeedDialListState createState() => _SpeedDialListState();
}

class _SpeedDialListState extends State<SpeedDialList> {
  TextEditingController _textEditingController;
  final speedDials = <String>[];

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SpeedDial List')),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _textEditingController,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                final speedDial = speedDials[index];
                return Dismissible(
                  key: Key('$speedDial$index'),
                  child: Center(child: Text(speedDial)),
                  background: Container(color: Colors.grey),
                  onDismissed: (direction) {
                    speedDials.removeAt(index);
                  },
                );
              },
              itemCount: speedDials.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          setState(() {
            speedDials.add(_textEditingController.text);
            _textEditingController.clear();
          });
        },
      ),
    );
  }
}

