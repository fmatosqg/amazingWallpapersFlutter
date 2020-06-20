import 'package:amazing_wallpapers_flutter/domain/api/AlbumApi.dart';
import 'package:amazing_wallpapers_flutter/domain/api/AlbumDto.dart';
import 'package:amazing_wallpapers_flutter/domain/getItFactory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AlbumDetailView extends StatelessWidget {
  final AlbumListDto albumDto;
  AlbumDetailView(this.albumDto);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("Detail a ${albumDto.id} a ${albumDto.url}"),
          FutureBuilder<AlbumDetailDto>(
              future: locator.get<AlbumApi>().getAlbumDetail(albumDto.url),
              builder: (context, snapshot) => _buildList(snapshot?.data)),
          Text("Footer"),
        ],
      ),
    );
  }

  Widget _buildCard(AlbumDetailPictureDto first) {
    return Container(
      color: Colors.amber[100],
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      child: Image.network(first.url ?? ''),
    );
  }

  Widget _buildList(AlbumDetailDto data) {
    final photos = data?.photos;

    final bool isLoading = data == null;
    final bool isEmpty = photos?.length == 0;

    return Expanded(
        child: Placeholder(
      isEmpty: isEmpty,
      isLoading: isLoading,
      child: SingleChildScrollView(
        child: Column(
          children:
              photos?.map((e) => _buildCard(e))?.toList() ?? [Container()],
        ),
      ),
    ));
  }
}

class Placeholder extends StatelessWidget {
  final bool isLoading;
  final bool isEmpty;
  final Widget child;

  Placeholder({this.child, this.isLoading = false, this.isEmpty = false});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Column(
        children: [
          _buildLoadingScreen(),
        ],
      );
    } else if (isEmpty) {
      return Column(
        children: [
          Text("Is empty"),
        ],
      );
    } else {
      return child;
    }
  }

  Widget _buildLoadingScreen() {
    return Container(
        width: 100,
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        ));
  }
}
