// import 'package:flutter/material.dart';
// import '../database/db_helper.dart';
// import 'SigmlPlayerPage.dart'; // Import DBHelper

// class TextConverterPage extends StatefulWidget {
//   final String selectedLanguage;
//   TextConverterPage({required this.selectedLanguage});

//   @override
//   _TextConverterPageState createState() => _TextConverterPageState();
// }

// class _TextConverterPageState extends State<TextConverterPage> {
//   String enteredWord = '';
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<String> fetchDataFromDatabase(String word) async {
//     DBHelper dbHelper = DBHelper();
//     // Get the SigmlFile object for the word
//     final sigmlFile = await dbHelper.getSigmlFileByWord(word.toLowerCase());

//     // Check if sigmlFile is null, and if not, return its sigmlData as a String
//     if (sigmlFile != null) {
//       return sigmlFile.sigmlData; // Return the actual sigmlData string
//     } else {
//       return "No matching SiGML file found!"; // Return a default message if no matching file
//     }
//   }

//   void navigateToSigmlPlayer(String sigmlData) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => SigmlPlayerPage(sigmlData: sigmlData),
//       ),
//     );
//   }

//   void handleConversion() async {
//     setState(() {
//       isLoading = true;
//     });

//     String sigmlText = await fetchDataFromDatabase(enteredWord);

//     setState(() {
//       isLoading = false;
//     });

//     if (sigmlText != "No matching SiGML file found!") {
//       navigateToSigmlPlayer(sigmlText);
//     } else {
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Error'),
//             content: Text(sigmlText),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Text to ISL Converter - ${widget.selectedLanguage}'),
//         backgroundColor: Colors.black,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               onChanged: (value) {
//                 setState(() {
//                   enteredWord = value;
//                 });
//               },
//               decoration: InputDecoration(
//                 labelText: 'Enter word to convert',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//             if (isLoading)
//               CircularProgressIndicator()
//             else
//               ElevatedButton(
//                 onPressed: enteredWord.isNotEmpty ? handleConversion : null,
//                 child: Text('Convert to ISL'),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
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

  //Fetch SiGML data from Firestore
  Future<String> fetchDataFromFirestore(String word) async {
    try {
      // Reference the Firestore collection
      final firestore = FirebaseFirestore.instance;
      final docSnapshot = await firestore
          .collection('sigml_files') // Collection name from your Firestore
          .doc(word.toLowerCase()) // Use the entered word as the document ID
          .get();

      if (docSnapshot.exists) {
        // Return the SiGML data if the document exists
        return docSnapshot.data()?['0'] ?? "No SiGML data found!";
      } else {
        // Handle case where no document exists
        return "No matching SiGML file found!";
      }
    } catch (e) {
      // Handle Firestore errors
      print("Error fetching data: $e");
      return "Error fetching data from Firestore!";
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

    String sigmlText = await fetchDataFromFirestore(enteredWord);

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
