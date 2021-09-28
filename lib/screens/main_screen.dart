import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() => runApp(MainScreen());

class MainScreen extends StatefulWidget {
  static const routeName = 'main-screen';
  @override
  _MainScreenState createState() => _MainScreenState();


}

enum TtsState { playing, stopped}

class _MainScreenState extends State<MainScreen> {
   FlutterTts? flutterTts;
  dynamic languages;
   String? language;
   double volume = 0.5;
   double pitch = 1.0;
   double rate = 0.5;

  late String _newVoiceText;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  @override
  initState() {
    super.initState();
    initTts();
  }

  initTts() {
    flutterTts = FlutterTts();

    _getLanguages();

    flutterTts!.setStartHandler(() {
      setState(() {
        print("playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts!.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts!.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getLanguages() async {
    languages = await flutterTts!.getLanguages;
    print("Available languages $languages");
    if (languages != null) setState(() => languages);
  }

  Future _speak() async {
    await flutterTts!.setVolume(volume);
    await flutterTts!.setSpeechRate(rate);
    await flutterTts!.setPitch(pitch);

    if (_newVoiceText.isNotEmpty) {
      var result = await flutterTts!.speak(_newVoiceText);
      if (result == 1) setState(() => ttsState = TtsState.playing);
    }
  }

  Future _stop() async {
    var result = await flutterTts!.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts!.stop();
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems() {
    var items = <DropdownMenuItem<String>>[];
    for (String type in languages) {
      items.add(DropdownMenuItem(value: type, child: Text(type)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = selectedType!;
      flutterTts!.setLanguage(language);
    });
  }

  void _onChange(String text) {
    setState(() {
      _newVoiceText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            bottomNavigationBar: bottomBar(),
            appBar: AppBar(
              title: Text('TextTo Speech',),
              centerTitle: true,
              backgroundColor: Colors.green,
            ),
            body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: [
                  _inputSection(),
                   languages != null ? _languageDropDownSection() : Text(""),
                  _buildSliders(),

                ]))));
  }

  Widget _inputSection() => Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
      child: TextField(

        decoration: const InputDecoration(
          fillColor: Colors.black12, filled: true,
          floatingLabelBehavior:FloatingLabelBehavior.always,
          labelText: "Insert text here",
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            //  when the TextFormField in focused
          ),
        ),
        onChanged: (String value) {
          _onChange(value);
        },
      ),

  );





  Widget _languageDropDownSection() => Container(
      padding: EdgeInsets.only(top: 50.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(
            child: Text('Select Language',
              style: TextStyle(fontSize: 20.0),
            ),
        ),
        DropdownButton(
          menuMaxHeight: 200,
          value: language,
          items: getLanguageDropDownMenuItems(),
          onChanged: changedLanguageDropDownItem,
        )
      ]));


  Widget _buildSliders() {
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text('Volume',
                textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ],
          ),
        ),
        _volume(),
        Container(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text('Pitch',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ],
          ),
        ),
        _pitch(),
        Container(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text('Rate',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ],
          ),
        ),
        _rate()],
    );
  }


   Widget _volume() {
     return Slider(
         value: volume,
         onChanged: (newVolume) {
           setState(() => volume = newVolume);
         },
         min: 0.0,
         max: 1.0,
         divisions: 10,
         label: (volume*100).round().toString()+"%",
         activeColor: Colors.blue
     );
   }

   Widget _pitch() {
     return Slider(
       value: pitch,
       onChanged: (newPitch) {
         setState(() => pitch = newPitch);
       },
       min: 0.5,
       max: 2.0,
       divisions: 15,
       label: (pitch*100).round().toString()+"%",
       activeColor: Colors.blue,
     );
   }

   Widget _rate() {
     return Slider(
       value: rate,
       onChanged: (newRate) {
         setState(() => rate = newRate);
       },
       min: 0.0,
       max: 1.0,
       divisions: 10,
       label: (rate*100).round().toString()+"%",
       activeColor: Colors.blue,
     );
   }

  bottomBar() =>Container(
  margin: EdgeInsets.all(10.0),
  height: 50,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      OutlinedButton(
        onPressed: _speak,
        child:Text('Play'),
      ),

      OutlinedButton(
        onPressed: _stop,
        child:Text('Stop'),
      ),
    ],
  ),
  );
}
