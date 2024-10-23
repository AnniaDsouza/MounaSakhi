import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package
import 'learn.dart'; // Import your learn page
import 'speech_converter.dart'; // Import your speech converter page
import 'text_converter.dart'; // Import your text converter page
import 'localization.dart'; // Import your localization file

class SelectionPage extends StatefulWidget {
  final String selectedLanguage; // Add selectedLanguage as a parameter

  SelectionPage({required this.selectedLanguage}); // Constructor

  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  late String _selectedLanguage;
  final List<String> _languages = ['English', 'Kannada']; // Language options

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.selectedLanguage; // Initialize _selectedLanguage from widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Go back to the previous page
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.black87, // Dark background color
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            // Select a Language Display
            GestureDetector(
              onTap: () {
                _showLanguageOptions(context); // Show language options when tapped
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFF616161), // Light grey background
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.getTranslation('select_language', _selectedLanguage) ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Icon(Icons.more_vert, color: Colors.white),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            // Learn Section
            GestureDetector(
              onTap: () {
                // Navigate to Learn page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LearnPage(selectedLanguage: _selectedLanguage),
                  ),
                );
              },
              child: buildOptionCard(
                title: AppLocalizations.getTranslation('learn', _selectedLanguage) ?? '',
                animationPath: 'assets/lottie/learn.json', // Lottie animation path
              ),
            ),
            SizedBox(height: 30),
            // Speech to ISL Converter Section
            GestureDetector(
              onTap: () {
                // Navigate to Speech Converter page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SpeechConverterPage(selectedLanguage: _selectedLanguage),
                  ),
                );
              },
              child: buildOptionCard(
                title: AppLocalizations.getTranslation('speech_converter', _selectedLanguage) ?? '',
                animationPath: 'assets/lottie/speech1.json', // Lottie animation path
              ),
            ),
            SizedBox(height: 30),
            // Text to ISL Converter Section
            GestureDetector(
              onTap: () {
                // Navigate to Text Converter page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TextConverterPage(selectedLanguage: _selectedLanguage),
                  ),
                );
              },
              child: buildOptionCard(
                title: AppLocalizations.getTranslation('text_converter', _selectedLanguage) ?? '',
                animationPath: 'assets/lottie/text3.json', // Lottie animation path
              ),
            ),
            SizedBox(height: 30),
            // Add Lottie animation at the bottom
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Lottie.asset(
                  'assets/lottie/learn2.json', // Path to your Lottie file
                  height: 250, // Adjust height as needed
                  fit: BoxFit.cover, // Fit the animation within the container
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show language options
  void _showLanguageOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF424242), // Dark background for the dialog
          title: Text(
            AppLocalizations.getTranslation('select_language_title', _selectedLanguage) ?? '',
            style: TextStyle(color: Colors.white),
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _languages.map((language) {
                return ListTile(
                  title: Text(
                    language,
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedLanguage = language == 'Kannada' ? 'kn' : 'en'; // Update selected language code
                    });
                    Navigator.pop(context); // Close the dialog
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  // Function to build the option card for each section
  Widget buildOptionCard({required String title, required String animationPath}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFF424242), // Dark grey background
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Text on the left
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis, // Prevent text overflow
            ),
          ),
          SizedBox(width: 20),
          // Lottie animation on the right with left padding
          Padding(
            padding: EdgeInsets.only(left: 5, right: 5), // Add left and right padding
            child: Lottie.asset(
              animationPath,
              height: 80,
              width: 80,
              fit: BoxFit.cover, // Ensure the animation scales correctly
            ),
          ),
        ],
      ),
    );
  }
}
