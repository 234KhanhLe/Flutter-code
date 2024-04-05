// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void main() {
  runApp(MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // appBar: AppBar(
        //   title: Center(child: Text('Demo')),
        //   backgroundColor: Colors.red,
        // ),
        backgroundColor: Colors.blueGrey,
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                // height: 100.0,
                color: Colors.green,
                child: Text('Container 1'),
              ),
              SizedBox(
                width: 30.0,
              ),
              Container(
                // width: 30.0,
                // height: 100.0,
                color: Colors.blue,
                child: Text('Container2'),
              ),
              Container(
                // width: 30.0,
                // height: 100.0,
                color: Colors.red,
                child: Text('Container3'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
