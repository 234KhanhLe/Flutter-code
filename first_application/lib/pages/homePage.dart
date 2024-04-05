import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
        // ignore: prefer_const_constructors
        body: Center(
            child: Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 80)),
        const Text('wireless mouse'),
        const Padding(padding: EdgeInsets.only(top: 40)),
        SizedBox(
          width: 200,
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 40)),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Check'),
        )
      ],
    )));
  }
}
