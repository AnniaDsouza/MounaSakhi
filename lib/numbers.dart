import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'dart:math';

class NumbersPage extends StatelessWidget {
  final String selectedLanguage; // Add this to handle the language selection

  NumbersPage({required this.selectedLanguage});

  // Example data for numbers, their spellings, and corresponding images
  final List<Map<String, dynamic>> numberData = [
    {'number': 0, 'english': 'Zero', 'kannada': 'ಶೂನ್ಯ', 'kannada_number': '೦', 'image': 'assets/numbers/0.jpg'},
    {'number': 1, 'english': 'One', 'kannada': 'ಒಂದು', 'kannada_number': '೧', 'image': 'assets/numbers/1.jpg'},
    {'number': 2, 'english': 'Two', 'kannada': 'ಎರಡು', 'kannada_number': '೨', 'image': 'assets/numbers/2.jpg'},
    {'number': 3, 'english': 'Three', 'kannada': 'ಮೂರು', 'kannada_number': '೩', 'image': 'assets/numbers/3.jpg'},
    {'number': 4, 'english': 'Four', 'kannada': 'ನಾಲ್ಕು', 'kannada_number': '೪', 'image': 'assets/numbers/4.jpg'},
    {'number': 5, 'english': 'Five', 'kannada': 'ಐದು', 'kannada_number': '೫', 'image': 'assets/numbers/5.jpg'},
    {'number': 6, 'english': 'Six', 'kannada': 'ಆರು', 'kannada_number': '೬', 'image': 'assets/numbers/6.jpg'},
    {'number': 7, 'english': 'Seven', 'kannada': 'ಏಳು', 'kannada_number': '೭', 'image': 'assets/numbers/7.jpg'},
    {'number': 8, 'english': 'Eight', 'kannada': 'ಎಂಟು', 'kannada_number': '೮', 'image': 'assets/numbers/8.jpg'},
    {'number': 9, 'english': 'Nine', 'kannada': 'ಒಂಬತ್ತು', 'kannada_number': '೯', 'image': 'assets/numbers/9.jpg'},
    {'number': 10, 'english': 'Ten', 'kannada': 'ಹತ್ತು', 'kannada_number': '೧೦', 'image': 'assets/numbers/10.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedLanguage == 'en' ? 'Numbers' : 'ಸಂಖ್ಯೆಗಳು'), // Title based on selected language
      ),
      body: Container(
        color: Color(0xFF222222), // Set background color to black87
        child: NumberFlipCard(isEnglish: selectedLanguage == 'en', numberData: numberData), // Pass language flag and number data
      ),
    );
  }
}

class NumberFlipCard extends StatelessWidget {
  final bool isEnglish; // Flag for language selection (English or Kannada)
  final List<Map<String, dynamic>> numberData; // Number data passed from NumbersPage

  NumberFlipCard({required this.isEnglish, required this.numberData}); // Constructor updated

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two cards in one row
        childAspectRatio: 1.0,
      ),
      itemCount: numberData.length,
      itemBuilder: (context, index) {
        final item = numberData[index];

        // Generate a random color for the current card
        Color cardColor = _getUniqueColor(index);

        return FlipCard(
          front: Card(
            color: cardColor, // Set the card color to the unique color
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isEnglish ? '${item['number']}' : item['kannada_number'], // Display number in English or Kannada
                    style: TextStyle(fontSize: 30, color: Colors.white), // White text color
                  ),
                  Text(
                    isEnglish ? item['english'] : item['kannada'], // Number spelling
                    style: TextStyle(fontSize: 20, color: Colors.white), // White text color
                  ),
                ],
              ),
            ),
          ),
          back: Card(
            color: cardColor, // Set the card color to the unique color
            child: Image.asset(
              item['image'], // Display corresponding image
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  // Function to generate a unique color for adjacent cards
  Color _getUniqueColor(int index) {
    List<Color> colors = [
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];

    // Get the last used color (if any)
    Color lastColor = index > 0 ? colors[(index - 1) % colors.length] : Colors.transparent;

    // Filter out the last color from the available colors
    List<Color> availableColors = colors.where((color) => color != lastColor).toList();

    // Select a random color from the available colors
    return availableColors[Random().nextInt(availableColors.length)];
  }
}

// Main function to run the app
void main() {
  runApp(MaterialApp(
    home: NumbersPage(selectedLanguage: 'en'), // Change 'en' to 'kn' for Kannada
  ));
}
