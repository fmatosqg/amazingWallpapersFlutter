import 'dart:io';

import 'package:amazing_wallpapers_flutter/domain/api/AlbumApi.dart';
import 'package:amazing_wallpapers_flutter/domain/api/AlbumDto.dart';
import 'package:amazing_wallpapers_flutter/domain/fileManager.dart';
import 'package:amazing_wallpapers_flutter/domain/getItFactory.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
        return _buildWrap2(_calculateImageWidth(constraints.biggest.width));
      },
    );
  }

  double _calculateImageWidth(double totalWidth) {
    final int numRows = (totalWidth / minImageWidth).floor();

    return totalWidth / numRows;
  }

  Widget _buildWrap2(double widgetWidth) {
    final api = locator.get<AlbumApi>();
    return FutureBuilder<List<AlbumDto>>(
      future: api.getAlbumListAsync(),
      initialData: [],
      builder: (context, snapshot) {
        return Wrap(
          children:
              snapshot.data.map((e) => AlbumView(e, widgetWidth)).toList(),
        );
      },
    );
  }

  Widget _buildWrap(double imageWidth) {
    final indices = List<int>.generate(20, (index) => index);

    return Wrap(
        children: indices
            .map((e) => Container(
                  padding: EdgeInsets.all(4),
                  width: imageWidth,
                  child: _showImage(e),
                ))
            .toList());
  }

  Widget _showImage(int count) {
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
}

class AlbumView extends StatelessWidget {
  final AlbumDto albumDto;
  final double widgetWidth;

  AlbumView(this.albumDto, this.widgetWidth);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widgetWidth,
      child: Container(
        color: Colors.amberAccent,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              height: 200,
              child: _imageView(albumDto.thumbnail),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(albumDto.niceName),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageView(String thumbnailUrl) {
    try {
      // return Image.network(thumbnailUrl);
      if (thumbnailUrl != null) {
        return Image(
          image: NetworkImage(thumbnailUrl),
        );
      }
      return Container();
    } catch (e) {
      return Container(
        child: Text("Error ${e.toString()}"),
      );
    }
  }
}
