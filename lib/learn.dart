import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package
import 'alphabets.dart'; // Import the alphabets page
import 'numbers.dart'; // Import the numbers page
import 'words.dart'; // Import the words page
import 'sentences.dart'; // Import the sentences page

class LearnPage extends StatelessWidget {
  final String selectedLanguage;

  LearnPage({required this.selectedLanguage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getLocalizedText('Learn'),
          style: TextStyle(fontSize: 22),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigates back to the previous screen
          },
        ),
        backgroundColor: Color.fromARGB(255, 52, 52, 52), // Matches the dark style in the UI
      ),
      body: Container(
        color: Color(0xFF222222), // Set background color to #4c4c4c
        child: Column(
          children: [
            // Add the Lottie animation here
            Lottie.asset(
              'assets/lottie/learn3.json', // Path to your Lottie file
              height: 200, // Adjust height as needed
              fit: BoxFit.cover, // Fit the animation within the container
            ),
            SizedBox(height: 20), // Added some padding for spacing

            // Button List (Alphabets, Numbers, Words, Sentences)
            _buildOptionButton(
              context,
              title: _getLocalizedText('Alphabets'),
              icon: _getIconForCategory('Alphabets'),
              color: Colors.pink,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlphabetsPage(selectedLanguage: selectedLanguage), // Pass selectedLanguage
                  ),
                );
              },
            ),
            _buildOptionButton(
              context,
              title: _getLocalizedText('Numbers'),
              icon: _getIconForCategory('Numbers'),
              color: Colors.greenAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NumbersPage(selectedLanguage: selectedLanguage), // Pass selectedLanguage
                  ),
                );
              },
            ),
            _buildOptionButton(
              context,
              title: _getLocalizedText('Words'),
              icon: _getIconForCategory('Words'),
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WordsPage(selectedLanguage: selectedLanguage), // Pass selectedLanguage
                  ),
                );
              },
            ),
            _buildOptionButton(
              context,
              title: _getLocalizedText('Sentences'),
              icon: _getIconForCategory('Sentences'),
              color: Colors.purpleAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SentencesPage(selectedLanguage: selectedLanguage), // Pass selectedLanguage
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Method to create each option button
  Widget _buildOptionButton(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required VoidCallback onTap, // Added onTap callback
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: ElevatedButton(
        onPressed: onTap, // Set the onTap callback here
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade700, // Use backgroundColor instead of primary
          padding: EdgeInsets.symmetric(vertical: 15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Rounded edges
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Wrap the Text widget in a Padding widget to add space
            Padding(
              padding: const EdgeInsets.only(left: 16.0), // Add left padding here
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            Row(
              children: [
                Icon(icon, color: color, size: 28), // Icon color and size
                SizedBox(width: 16), // Added right space
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to get localized text based on the selected language
  String _getLocalizedText(String key) {
    Map<String, Map<String, String>> localizedTexts = {
      'en': {
        'Learn': 'Learn',
        'Alphabets': 'Alphabets',
        'Numbers': 'Numbers',
        'Words': 'Words',
        'Sentences': 'Sentences',
      },
      'kn': {
        'Learn': 'ಕಲಿ',
        'Alphabets': 'ಅಕ್ಷರಗಳು',
        'Numbers': 'ಸಂಖ್ಯೆಗಳು',
        'Words': 'ಪದಗಳು',
        'Sentences': 'ವಾಕ್ಯಗಳು',
      },
    };

    return localizedTexts[selectedLanguage]?[key] ?? key; // Fallback to key if no translation found
  }

  // Helper function to get icons based on the selected language and category
  IconData _getIconForCategory(String category) {
    Map<String, IconData> englishIcons = {
      'Alphabets': Icons.font_download,
      'Numbers': Icons.format_list_numbered,
      'Words': Icons.text_snippet,
      'Sentences': Icons.notes,
    };

    Map<String, IconData> kannadaIcons = {
      'Alphabets': Icons.keyboard, // Icon for Kannada alphabets
      'Numbers': Icons.calculate, // Icon for Kannada numbers
      'Words': Icons.text_snippet, // Icon for Kannada words
      'Sentences': Icons.notes, // Icon for Kannada sentences
    };

    // Return Kannada icons if the selected language is Kannada ('kn')
    if (selectedLanguage == 'kn') {
      return kannadaIcons[category] ?? Icons.help; // Fallback to help icon
    }

    // Return English icons by default
    return englishIcons[category] ?? Icons.help; // Fallback to help icon
  }
}

void main() {
  runApp(MaterialApp(
    home: LearnPage(selectedLanguage: 'en'), // Change 'en' to 'kn' for Kannada
  ));
}
