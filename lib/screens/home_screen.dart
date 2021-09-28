import 'package:flutter/material.dart';

import 'main_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'home-screen';


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TexTo Speech'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            'TexTo Speech',
            style: TextStyle(fontSize: 50),
          ),
          SizedBox(height: 20,
          ),
          Text('Designed to help you communicate with the world',
          style: TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
          Image.asset('images/Logo_TTS.PNG'),
          Center(
            child: ElevatedButton(
              child: Text('Begin'),
              onPressed: () {
                Navigator.pushNamed(context, MainScreen.routeName);// Navigate to second route when tapped.
              },
            ),
          ),
        ],
      ),
    );
  }
}

