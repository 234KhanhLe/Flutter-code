// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: Text('My personal info app'),
          backgroundColor: Colors.blue.shade300,
        ),
        body: Center(
          child: Image(image: NetworkImage('images/187898775 (2).JPG')),
        ),
      ),
    ),
  );
}
