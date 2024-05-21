// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:speech_to_text/speech_to_text.dart';
//
// class SpeechToTextPage extends StatefulWidget {
//   const SpeechToTextPage({Key? key}) : super(key: key);
//
//   @override
//   _SpeechToTextPage createState() => _SpeechToTextPage();
// }
//
// class _SpeechToTextPage extends State<SpeechToTextPage> {
//   final TextEditingController _textController = TextEditingController();
//
//   final SpeechToText _speechToText = SpeechToText();
//   bool _speechEnabled = false;
//   String _lastWords = "";
//
//   void listenForPermissions() async {
//     final status = await Permission.microphone.status;
//     if (status == PermissionStatus.denied) {
//       requestForPermission();
//     } else if (status == PermissionStatus.permanentlyDenied) {
//       // Handle the case where the user has permanently denied the permission
//     }
//     // Add more else-if conditions as needed for other PermissionStatus values
//   }
//
//
//   Future<void> requestForPermission() async {
//     await Permission.microphone.request();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     listenForPermissions();
//     if (!_speechEnabled) {
//       _initSpeech();
//     }
//   }
//
//   /// This has to happen only once per app
//   void _initSpeech() async {
//     _speechEnabled = await _speechToText.initialize();
//   }
//
//   /// Each time to start a speech recognition session
//   void _startListening() async {
//     await _speechToText.listen(
//       onResult: _onSpeechResult,
//       listenFor: const Duration(seconds: 30),
//       localeId: "en_En",
//       cancelOnError: false,
//       partialResults: false,
//       listenMode: ListenMode.confirmation,
//     );
//     setState(() {});
//   }
//
//   /// Manually stop the active speech recognition session
//   /// Note that there are also timeouts that each platform enforces
//   /// and the SpeechToText plugin supports setting timeouts on the
//   /// listen method.
//   void _stopListening() async {
//     await _speechToText.stop();
//     setState(() {});
//   }
//
//   /// This is the callback that the SpeechToText plugin calls when
//   /// the platform returns recognized words.
//   void _onSpeechResult(SpeechRecognitionResult result) {
//     setState(() {
//       _lastWords = "${result.recognizedWords} ";
//       _textController.text = _lastWords;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//           child: ListView(
//             shrinkWrap: true,
//             padding: const EdgeInsets.all(12),
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _textController,
//                       minLines: 6,
//                       maxLines: 10,
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.grey.shade300,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 8,
//                   ),
//                   FloatingActionButton.small(
//                     onPressed:
//                     // If not yet listening for speech start, otherwise stop
//                     _speechToText.isNotListening
//                         ? _startListening
//                         : _stopListening,
//                     tooltip: 'Listen',
//                     backgroundColor: Colors.blueGrey,
//                     child: Icon(_speechToText
//                         .isNotListening
//                         ? Icons.mic_off
//                         : Icons.mic),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ));
//   }
// }


import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_to_text_provider.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {

  var textSpeech = "CLICK ON MIC TO RECORD";
  SpeechToText speechToText = SpeechToText();
  var isListening = false;

  void checkMic() async{
    bool micAvailable = await speechToText.initialize();

    if(micAvailable){
      print("MicroPhone Available");
    }else{
      print("User Denied th use of speech micro");
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkMic();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(textSpeech),

              GestureDetector(
                onTap: () async{
                  if(!isListening){
                    bool micAvailable = await speechToText.initialize();

                    if(micAvailable){
                      setState(() {
                        isListening = true;
                      });

                      speechToText.listen(
                          listenFor: Duration(seconds: 20),
                          onResult: (result){
                            setState(() {
                              textSpeech = result.recognizedWords;
                              isListening = false;
                            });
                          }
                      );


                    }
                  }else{
                    setState(() {
                      isListening = false;

                      speechToText.stop();
                    });
                  }
                },
                child: CircleAvatar(
                  child: isListening ? Icon(Icons.record_voice_over): Icon(Icons.mic),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}