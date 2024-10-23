import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:video_player/video_player.dart';

class WordsPage extends StatelessWidget {
  final String selectedLanguage;

  WordsPage({required this.selectedLanguage});

  final List<Map<String, dynamic>> wordData = [
    
   
    {'word': 'Coffee', 'kannada': 'ಕಾಫಿ', 'video': 'assets/words/coffee.mp4'},
   
    {'word': 'Eat', 'kannada': 'ತಿನ್ನು', 'video': 'assets/words/eat.mp4'},
    {'word': 'Evening', 'kannada': 'ಮಧ್ಯಾಹ್ನ', 'video': 'assets/words/evening.mp4'},
    {'word': 'Good Afternoon', 'kannada': 'ಶುಭ ಮಧ್ಯಾಹ್ನ', 'video': 'assets/words/good_afternoon.mp4'},
    {'word': 'Good Morning', 'kannada': 'ಶುಭೋದಯ', 'video': 'assets/words/good_morning.mp4'},
    {'word': 'Good Night', 'kannada': 'ಶುಭ ರಾತ್ರಿ', 'video': 'assets/words/good_night.mp4'},
    {'word': 'Happy', 'kannada': 'ಆನಂದ', 'video': 'assets/words/happy.mp4'},
    {'word': 'Hello', 'kannada': 'ಹಲೋ', 'video': 'assets/words/hello.mp4'},

    {'word': 'Please', 'kannada': 'ದಯವಿಟ್ಟು', 'video': 'assets/words/please.mp4'},
  
    {'word': 'Sad', 'kannada': 'ದುಃಖ', 'video': 'assets/words/sad.mp4'},
    {'word': 'Sleep', 'kannada': 'ನಿದ್ರೆ', 'video': 'assets/words/sleep.mp4'},
    {'word': 'Sorry', 'kannada': 'ಕ್ಷಮಿಸಿ', 'video': 'assets/words/sorry.mp4'},
  
    {'word': 'Tea', 'kannada': 'ಚಹಾ', 'video': 'assets/words/tea.mp4'},
    {'word': 'Thank You', 'kannada': 'ಧನ್ಯವಾದಗಳು', 'video': 'assets/words/thank_you.mp4'},
    {'word': 'Water', 'kannada': 'ನೀರು', 'video': 'assets/words/water.mp4'},
    {'word': 'Yes', 'kannada': 'ಹೌದು', 'video': 'assets/words/yes.mp4'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedLanguage == 'en' ? 'Words' : 'ಪದಗಳು'),
      ),
      body: Container(
        color: Colors.black87,
        child: WordFlipCard(isEnglish: selectedLanguage == 'en', wordData: wordData),
      ),
    );
  }
}

class WordFlipCard extends StatefulWidget {
  final bool isEnglish;
  final List<Map<String, dynamic>> wordData;

  WordFlipCard({required this.isEnglish, required this.wordData});

  @override
  _WordFlipCardState createState() => _WordFlipCardState();
}

class _WordFlipCardState extends State<WordFlipCard> {
  late List<VideoPlayerController> _controllers;
  final List<bool> _isInitialized;

  _WordFlipCardState() : _isInitialized = List.generate(20, (index) => false); // Assuming 20 items

  @override
  void initState() {
    super.initState();
    _controllers = widget.wordData.map((item) {
      return VideoPlayerController.asset(item['video']);
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _playVideo(int index) {
    for (int i = 0; i < _controllers.length; i++) {
      if (i != index) {
        _controllers[i].pause();
      }
    }
    // Reset and play the selected video
    _controllers[index].seekTo(Duration.zero);
    _controllers[index].play();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.wordData.length,
      itemBuilder: (context, index) {
        final item = widget.wordData[index];

        return FlipCard(
          front: Card(
            color: Colors.blue,
            elevation: 4,
            child: Container(
              height: 200,
              child: Center(
                child: Text(
                  widget.isEnglish ? item['word'] : item['kannada'],
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
          ),
          back: Card(
            color: Colors.blue,
            child: FutureBuilder(
              future: _controllers[index].initialize(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // Mark as initialized
                  _isInitialized[index] = true;
                  return AspectRatio(
                    aspectRatio: _controllers[index].value.aspectRatio,
                    child: VideoPlayer(_controllers[index]),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          onFlip: () {
            if (!_isInitialized[index]) {
              // Avoid playing video if not initialized
              return;
            }
            _playVideo(index);
          },
        );
      },
    );
  }
}

// Main function to run the app
void main() {
  runApp(MaterialApp(
    home: WordsPage(selectedLanguage: 'en'),
  ));
}
