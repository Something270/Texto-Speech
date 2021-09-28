import 'package:flutter/material.dart';
import './screens/home_screen.dart';
import './screens/main_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Menu',
      initialRoute: HomeScreen.routeName,
      routes: {
        MainScreen.routeName: (ctx) => MainScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen(),

      },
    );
  }
}

