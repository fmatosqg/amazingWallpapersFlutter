import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

void writeFile(int count) {
  debugPrint("File is writter");

  _writeAsync().then((value) => {debugPrint("Done")});

  readFile(count).then((value) => debugPrint("whaha ${value.length}"));
}

Future<void> _writeAsync() async {
  final directory = await getApplicationDocumentsDirectory();

  debugPrint("Directory is " + directory.absolute.path);

  final path = directory.path;

  final file = File('$path/counter.txt');
  file.writeAsStringSync("count");
}

Future<Directory> _folderGallery() async {
  final d = await getApplicationDocumentsDirectory();
  return Directory('${d.path}/../.galleries/images');
}

Future<String> getFilePath(int count) async {
  final dir = await _folderGallery();
  final c = count.toString().padLeft(2,'0');
  final file = File('${dir.path}/image$c.jpg.png');

  return file.path;
}

Future<Uint8List> readFile(int count) async {
  final dir = await _folderGallery();
  final file = File('${dir.path}/image0$count.jpg.png');
  return await file.readAsBytes();
}
