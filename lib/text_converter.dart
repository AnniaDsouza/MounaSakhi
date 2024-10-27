import 'package:flutter/material.dart';
import 'SigmlPlayerPage.dart'; // Ensure you import the SigmlPlayerPage

class TextConverterPage extends StatefulWidget {
  final String selectedLanguage;

  TextConverterPage({required this.selectedLanguage});

  @override
  _TextConverterPageState createState() => _TextConverterPageState();
}

class _TextConverterPageState extends State<TextConverterPage> {
  String enteredWord = '';

  @override
  void initState() {
    super.initState();
  }

  // Simulating data fetching from a database based on user input
  String fetchDataFromDatabase() {
    // Example: Fetching SiGML data based on user input
    if (enteredWord.toLowerCase() == 'one') {
      return '''<?xml version="1.0" encoding="utf-8"?> 
          <sigml> 
            <hns_sign gloss="one"> 
              <hamnosys_nonman />
            </hns_sign> 
          </sigml>''';
    } else {
      return "No matching SiGML file found!";
    }
  }

  void navigateToSigmlPlayer(String sigmlText) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SigmlPlayerPage(sigmlFileName: sigmlText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text to ISL Converter - ${widget.selectedLanguage}'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text input for user to enter a word
            TextField(
              onChanged: (value) {
                setState(() {
                  enteredWord = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Enter word to convert',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            
            // Button to fetch the SiGML file based on input
            ElevatedButton(
              onPressed: () {
                String sigmlText = fetchDataFromDatabase();
                if (sigmlText != "No matching SiGML file found!") {
                  navigateToSigmlPlayer(sigmlText);
                } else {
                  // Show an alert if no SiGML data found
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text(sigmlText),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Convert to ISL'),
            ),
          ],
        ),
      ),
    );
  }
}
