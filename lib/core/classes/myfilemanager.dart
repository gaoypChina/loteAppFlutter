import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class MyFileManager{
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.json');
  }

  Future<File> writeCounter(Map<String, dynamic> map) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('${compress(json.encode(map))}');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<int> length() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.length();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  static String compress(String json) {
    final enCodedJson = utf8.encode(json);
    final gZipJson = gzip.encode(enCodedJson);
    final base64Json = base64.encode(gZipJson);
    return base64Json;

    final decodeBase64Json = base64.decode(base64Json);
    final decodegZipJson = gzip.decode(decodeBase64Json);
    final originalJson = utf8.decode(decodegZipJson);
    }
}