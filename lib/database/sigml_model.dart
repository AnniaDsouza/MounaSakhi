class SigmlFile {
  final int? id;
  final String fileName;
  final String sigmlData;

  SigmlFile({this.id, required this.fileName, required this.sigmlData});

  // Convert SiGML file to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fileName': fileName,
      'sigmlData': sigmlData,
    };
  }

  // Convert a map back to a SigmlFile object
  factory SigmlFile.fromMap(Map<String, dynamic> map) {
    return SigmlFile(
      id: map['id'],
      fileName: map['fileName'],
      sigmlData: map['sigmlData'],
    );
  }
}
