import 'dart:io';

import 'package:amazing_wallpapers_flutter/domain/fileManager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget preview(int count) {
  if (!kIsWeb) {
    if (Platform.isLinux) {
      return FutureBuilder(
          future: getFilePath(count),
          initialData: null,
          builder: (context, snapshot) {
            return snapshot.data != null
                ? Image.file(File(snapshot.data))
                : Text("empty");
          });
    } else {
      return Text("not web and not linux");
    }
  } else {
    return Text("count $count");
  }
}

class Preview extends StatelessWidget {
  final minImageWidth = 200;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      color: Colors.amber,
      child: ListView(
        children: [
          Align(
            alignment: Alignment.center,
            child: _buildResponsibleWrap(),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsibleWrap() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // return Text("what ${constraints.biggest.width}");
        return _buildWrap(_calculateImageWidth(constraints.biggest.width));
      },
    );
  }

  double _calculateImageWidth(double totalWidth) {
    final int numRows = (totalWidth / minImageWidth).floor();

    return totalWidth / numRows;
  }

  Widget _buildWrap(double imageWidth) {
    final indices = List<int>.generate(20, (index) => index);

    return Wrap(
        children: indices
            .map((e) => Container(
                  padding: EdgeInsets.all(4),
                  width: imageWidth,
                  child: preview(e),
                ))
            .toList());
  }
}
