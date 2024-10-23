import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Import Lottie
import 'selection_page.dart'; // Import your updated SelectionPage
import 'localization.dart'; // Import your localization file

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _selectedLanguage = 'en'; // Default language

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(), // Remove dark theme handling
      home: HomePage(
        selectedLanguage: _selectedLanguage,
        onLanguageChanged: (String newLanguage) {
          setState(() {
            _selectedLanguage = newLanguage;
          });
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onLanguageChanged;

  HomePage({
    required this.selectedLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        backgroundColor: Color(0xFF4C4C4C),//Color(0xFF4C4C4C), // Set consistent background color
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green.shade700,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Languages'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                _showLanguageOptions(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.black87, // Set consistent background color
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Lottie Animation
                      Container(
                        width: 250,
                        height: 250,
                        child: Lottie.asset(
                          'assets/lottie/namaste.json', // Path to your Lottie animation
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 20),
                      // Welcome Text
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        decoration: BoxDecoration(
                          color: Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'WELCOME',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              AppLocalizations.getTranslation('welcome', selectedLanguage) ?? 'ನಮಸ್ಕಾರ',
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      // Get Started Button
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to SelectionPage with the selected language
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectionPage(
                                selectedLanguage: selectedLanguage,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF58CC02), // Button background color
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
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
          title: Text(
            AppLocalizations.getTranslation('select_language_title', selectedLanguage) ?? '',
            style: TextStyle(color: Colors.black), // Change color for readability
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: ['English', 'Kannada'].map((language) {
                return ListTile(
                  title: Text(
                    language,
                    style: TextStyle(color: Colors.black), // Change color for readability
                  ),
                  onTap: () {
                    String newLanguage = language == 'Kannada' ? 'kn' : 'en';
                    onLanguageChanged(newLanguage); // Update selected language
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
}
//Colors: #fb347f, #fc770b, #fde22e, #7ede29, #7318d0