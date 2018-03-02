import 'package:amazingwallpapers/Domain.dart';
import 'package:amazingwallpapers/Widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlbumsView extends StatelessWidget {

  AlbumRepo _repo = ServiceLocator.getAlbumRepo();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text('Albums')),
        backgroundColor: Colors.grey[100],
        body: new ListView(
            children: _buildAlbumCell()
        )
    );
  }

  List<_CellAlbum> _buildAlbumCell() {
    return _repo.getAlbumList().map((album) =>
    new _CellAlbum(album)
    ).toList();
  }

}

class _CellAlbum extends StatelessWidget {
  AlbumDto _albumDto;

  _CellAlbum(AlbumDto albumDto) {
    _albumDto = albumDto;
    print(_albumDto.niceName);
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),

      child:
      new Card(
          elevation: 4.0,

          child:
          new Container(
            color: Colors.grey[200],
            child: new Padding(
              padding: new EdgeInsets.all(10.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,

                children: <Widget>[

                  new ThumbnailView(thumbnail: _albumDto.thumbnail),
                  new Padding(
                    padding: new EdgeInsets.symmetric(vertical: 8.0),
                    child:
                    new TextCaption(
                        "Very long text that will span multiple lines easilyyy really reallyyyy"),
                  ),
                ],
              ),
            ),
          )
      )
      ,


//      ),
    );
  }
}
