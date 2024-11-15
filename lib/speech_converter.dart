import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';
import 'SigmlPlayerPage.dart'; // Import the SigmlPlayerPage

class SpeechConverterPage extends StatefulWidget {
  final String selectedLanguage;

  SpeechConverterPage({required this.selectedLanguage});

  @override
  _SpeechConverterPageState createState() => _SpeechConverterPageState();
}

class _SpeechConverterPageState extends State<SpeechConverterPage> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final GoogleTranslator _translator = GoogleTranslator();
  bool _isListening = false;
  String _text = '';

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  void _initializeSpeech() async {
    await _speech.initialize(
      onStatus: (status) {
        if (status == 'done') {
          setState(() {
            _isListening = false; // Reset listening state
          });
        }
      },
      onError: (error) {
        print('Error: $error');
      },
    );
  }

  void _listen() async {
    if (_isListening) {
      _speech.stop();
    } else {
      String locale = widget.selectedLanguage == 'kn' ? 'kn-IN' : 'en-US';

      _speech.listen(
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords; // Capture recognized words
          });
        },
        localeId: locale,
      );
    }
    setState(() {
      _isListening = !_isListening;
    });
  }

  void _navigateToSigmlPlayer() {
    // Navigate to SigmlPlayerPage with the recognized text as the sigmlData
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SigmlPlayerPage(sigmlData: 'hello.sigml'), // You can use _text to dynamically change the sigmlData
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech to ISL Converter'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selected Language: ${widget.selectedLanguage}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Recognized Text:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              _text.isEmpty ? 'Say something...' : _text,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            IconButton(
              icon: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                size: 50,
                color: Colors.green,
              ),
              onPressed: _listen,
            ),
            SizedBox(height: 20),
            Text(
              'Press the microphone to start speaking',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _navigateToSigmlPlayer,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
