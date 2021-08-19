import 'package:flutter/material.dart';
import 'about.dart';
import 'home.dart';
import 'splash.dart';

void main() {
  runApp(NameCard());
}

class NameCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Name Card',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.yellow,
        primarySwatch: Colors.yellow,
      ),
      initialRoute: Splash.routeName,
      routes: {

        About.routeName: (context) => About(),
        EditCard.routeName: (context) => EditCard(),
        Splash.routeName: (context) => Splash(),
        // SaveAndShare.routeName: (context) => SaveAndShare(),
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) => Scaffold(
              appBar: AppBar(), body: Center(child: Text('Not Found'))),
        );
      },
    );
  }
}
