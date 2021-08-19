import 'package:flutter/material.dart';

class About extends StatelessWidget {
  static const routeName = "/about";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Text(
        "Wubba lubba dub dub",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
      )),
    );
  }
}
