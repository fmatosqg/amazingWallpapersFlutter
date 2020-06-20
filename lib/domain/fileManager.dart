import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

void writeFile(int count) {
  debugPrint("File is written");

  _writeAsync().then((value) => {debugPrint("Done")});
}

Future<void> _writeAsync() async {
  try {
    final directory = await getApplicationDocumentsDirectory();

    debugPrint("Directory is " + directory.absolute.path);

    final path = directory.path;

    final file = File('$path/counter.txt');
    file.writeAsStringSync("count");
  } catch (e) {
    debugPrint("Catch $e");
  }
}

Future<Directory> _folderGallery() async {
  final d = await getApplicationDocumentsDirectory();
  return Directory('${d.path}/../.galleries/images');
}

Future<String> getFilePath(int count) async {
  try {
    final dir = await _folderGallery();
    final c = count.toString().padLeft(2, '0');
    final file = File('${dir.path}/image$c.jpg.png');
    debugPrint("Path is ${file.path}");

    return file.path;
  } catch (e) {
    debugPrint("asdasdas  adssa ");
    return "nope";
  }
}

