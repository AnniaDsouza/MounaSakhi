import 'package:flutter/material.dart';
import 'SigmlPlayerPage.dart';

class TextConverterPage extends StatefulWidget {
  final String selectedLanguage;

  TextConverterPage({required this.selectedLanguage});

  @override
  _TextConverterPageState createState() => _TextConverterPageState();
}

class _TextConverterPageState extends State<TextConverterPage> {
  String enteredWord = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  // Simulating data fetching from a database based on user input
  String fetchDataFromDatabase(String word) {
    // Mapping of words to SiGML data
    Map<String, String> sigmlDatabase = {
      'one': '''<?xml version="1.0" encoding="utf-8"?> 
                <sigml> 
                  <hns_sign gloss="one"> 
                    <hamnosys_nonman />
                  </hns_sign> 
                </sigml>''',
      'two': '''<?xml version="1.0" encoding="utf-8"?> 
                <sigml> 
                  <hns_sign gloss="two"> 
                    <hamnosys_nonman />
                  </hns_sign> 
                </sigml>''',
      // Add more mappings here as needed
    };

    return sigmlDatabase[word.toLowerCase()] ?? "No matching SiGML file found!";
  }

  void navigateToSigmlPlayer(String sigmlData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SigmlPlayerPage(sigmlData: sigmlData),
      ),
    );
  }

  void handleConversion() async {
    setState(() {
      isLoading = true;
    });

    String sigmlText = fetchDataFromDatabase(enteredWord);

    setState(() {
      isLoading = false;
    });

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

            // Show loading indicator if fetching data
            if (isLoading)
              CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: enteredWord.isNotEmpty ? handleConversion : null,
                child: Text('Convert to ISL'),
              ),
          ],
        ),
      ),
    );
  }
}
