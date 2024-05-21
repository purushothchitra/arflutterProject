import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();
  final FlutterTts _flutterTts =  FlutterTts();
  TextToSpeech({super.key});

  speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.50);
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _textEditingController,
              ),
            ),
            Container(
              width: 200,
              height: 40,
              color: Colors.transparent,
              child: ElevatedButton(onPressed: () {
                speak(_textEditingController.text);
              },
                child: Center(child: Text("Press to speak"),
                ),
              ),
            ),
            Spacer()
          ],
        ),
      ),
    );
  }
}