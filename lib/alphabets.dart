import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
//import 'dart:math';

class AlphabetsPage extends StatelessWidget {
  final String selectedLanguage;

  AlphabetsPage({required this.selectedLanguage});

  // Example data for alphabets, their spellings, and corresponding images
  final List<Map<String, dynamic>> alphabetData = [
    {'letter': 'A', 'kannada': 'ಎ', 'image': 'assets/alphabets/A.jpg'},
    {'letter': 'B', 'kannada': 'ಬ', 'image': 'assets/alphabets/B.jpg'},
    {'letter': 'C', 'kannada': 'ಸ', 'image': 'assets/alphabets/C.jpg'},
    {'letter': 'D', 'kannada': 'ಡಿ', 'image': 'assets/alphabets/D.jpg'},
    {'letter': 'E', 'kannada': 'ಇ', 'image': 'assets/alphabets/E.jpg'},
    {'letter': 'F', 'kannada': 'ಎಫ್', 'image': 'assets/alphabets/F.jpg'},
    {'letter': 'G', 'kannada': 'ಜಿ', 'image': 'assets/alphabets/G.jpg'},
    {'letter': 'H', 'kannada': 'ಹೆ', 'image': 'assets/alphabets/H.jpg'},
    {'letter': 'I', 'kannada': 'ಐ', 'image': 'assets/alphabets/I.jpg'},
    {'letter': 'J', 'kannada': 'ಜೇ', 'image': 'assets/alphabets/J.jpg'},
    {'letter': 'K', 'kannada': 'ಕೆ', 'image': 'assets/alphabets/K.jpg'},
    {'letter': 'L', 'kannada': 'ಎಲ್', 'image': 'assets/alphabets/L.jpg'},
    {'letter': 'M', 'kannada': 'ಎಮ್', 'image': 'assets/alphabets/M.jpg'},
    {'letter': 'N', 'kannada': 'ಎನ್', 'image': 'assets/alphabets/N.jpg'},
    {'letter': 'O', 'kannada': 'ಓ', 'image': 'assets/alphabets/O.jpg'},
    {'letter': 'P', 'kannada': 'ಪ', 'image': 'assets/alphabets/P.jpg'},
    {'letter': 'Q', 'kannada': 'ಕ್ಯೂ', 'image': 'assets/alphabets/Q.jpg'},
    {'letter': 'R', 'kannada': 'ಆರ್', 'image': 'assets/alphabets/R.jpg'},
    {'letter': 'S', 'kannada': 'ಎಸ್', 'image': 'assets/alphabets/S.jpg'},
    {'letter': 'T', 'kannada': 'ಟೀ', 'image': 'assets/alphabets/T.jpg'},
    {'letter': 'U', 'kannada': 'ಯು', 'image': 'assets/alphabets/U.jpg'},
    {'letter': 'V', 'kannada': 'ವಿ', 'image': 'assets/alphabets/V.jpg'},
    {'letter': 'W', 'kannada': 'ಡಬಲ್ ಯು', 'image': 'assets/alphabets/W.jpg'},
    {'letter': 'X', 'kannada': 'ಎಕ್ಸ್', 'image': 'assets/alphabets/X.jpg'},
    {'letter': 'Y', 'kannada': 'ವೈ', 'image': 'assets/alphabets/Y.jpg'},
    {'letter': 'Z', 'kannada': 'ಜಡ್', 'image': 'assets/alphabets/Z.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedLanguage == 'en' ? 'Alphabets' : 'ಅಕ್ಷರಗಳು'), // Title based on selected language
      ),
      body: Container(
        color: Colors.black87, // Set background color to black87
        child: AlphabetFlipCard(isEnglish: selectedLanguage == 'en', alphabetData: alphabetData), // Pass language flag and alphabet data
      ),
    );
  }
}

class AlphabetFlipCard extends StatelessWidget {
  final bool isEnglish; // Flag for language selection (English or Kannada)
  final List<Map<String, dynamic>> alphabetData; // Alphabet data passed from AlphabetsPage

  AlphabetFlipCard({required this.isEnglish, required this.alphabetData}); // Constructor updated

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two cards in one row
        childAspectRatio: 1.0,
        mainAxisSpacing: 10.0, // Space between rows
        crossAxisSpacing: 10.0, // Space between columns
      ),
      itemCount: alphabetData.length,
      itemBuilder: (context, index) {
        final item = alphabetData[index];

        return FlipCard(
          front: Card(
            color: Color(0xFF424242), // Set the card color
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isEnglish ? item['letter'] : item['kannada'], // Display letter in English or Kannada
                    style: TextStyle(fontSize: 30, color: Colors.white), // White text color
                  ),
                ],
              ),
            ),
          ),
          back: Card(
            color: Color(0xFF424242), // Set the card color
            child: Image.asset(
              item['image'], // Display corresponding image
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}

// Main function to run the app
void main() {
  runApp(MaterialApp(
    home: AlphabetsPage(selectedLanguage: 'en'), // Change 'en' to 'kn' for Kannada
  ));
}
