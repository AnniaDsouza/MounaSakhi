import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import 'SigmlPlayerPage.dart'; // Import DBHelper

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

  Future<String> fetchDataFromDatabase(String word) async {
    DBHelper dbHelper = DBHelper();
    // Get the SigmlFile object for the word
    final sigmlFile = await dbHelper.getSigmlFileByWord(word.toLowerCase());

    // Check if sigmlFile is null, and if not, return its sigmlData as a String
    if (sigmlFile != null) {
      return sigmlFile.sigmlData; // Return the actual sigmlData string
    } else {
      return "No matching SiGML file found!"; // Return a default message if no matching file
    }
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

    String sigmlText = await fetchDataFromDatabase(enteredWord);

    setState(() {
      isLoading = false;
    });

    if (sigmlText != "No matching SiGML file found!") {
      navigateToSigmlPlayer(sigmlText);
    } else {
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
