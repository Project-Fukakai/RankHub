import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:archive/archive.dart';

class SaveFileReader {
  final String url;
  late Uint8List zipBytes;

  SaveFileReader(this.url);

  Future<void> load() async {
    try {
      final res = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 20));
      if (res.statusCode != 200) {
        throw Exception("Failed to download save file: ${res.statusCode}");
      }
      zipBytes = res.bodyBytes;
    } on TimeoutException {
      throw Exception("Download save file timeout");
    }
  }

  Archive _openZip() {
    return ZipDecoder().decodeBytes(zipBytes);
  }

  Uint8List readRecord() {
    final archive = _openZip();
    final file = archive.findFile("gameRecord");
    if (file == null) throw Exception("Missing gameRecord");

    final data = Uint8List.fromList(file.content as List<int>);

    if (data.isEmpty || data[0] != 0x01) {
      throw Exception("Invalid record");
    }

    return data.sublist(1);
  }

  Uint8List readProgress() {
    final archive = _openZip();
    final file = archive.findFile("gameProgress");
    if (file == null) throw Exception("Missing gameProgress");
    return Uint8List.fromList(file.content as List<int>);
  }

  Uint8List readUser() {
    final archive = _openZip();
    final file = archive.findFile("user");
    if (file == null) throw Exception("Missing user");
    return Uint8List.fromList(file.content as List<int>);
  }
}
