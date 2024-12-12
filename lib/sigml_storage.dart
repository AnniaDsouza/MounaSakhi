import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';
import 'dart:io';

// Upload a SigML file to Firebase Storage
Future<void> uploadSigMLFile(String filePath, String fileName) async {
  final storageRef = FirebaseStorage.instance.ref().child('sigml_files/$fileName');
  
  // Read the file and upload
  final file = File(filePath);
  try {
    await storageRef.putFile(file);
    print('File uploaded successfully');
  } catch (e) {
    print('Error uploading file: $e');
  }
}

// Download a SigML file from Firebase Storage
Future<void> downloadSigMLFile(String fileName, String localPath) async {
  final storageRef = FirebaseStorage.instance.ref().child('sigml_files/$fileName');
  
  try {
    await storageRef.writeToFile(File(localPath));
    print('File downloaded successfully');
  } catch (e) {
    print('Error downloading file: $e');
  }
}
