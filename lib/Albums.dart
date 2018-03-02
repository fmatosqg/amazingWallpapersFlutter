import 'dart:async';

import 'package:amazingwallpapers/Domain.dart';
import 'package:amazingwallpapers/Widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


abstract class AlbumsViewLoader {
  loadingItems();

  loadedItems(List<AlbumDto> albumList);

  loadFailed(String errorMessage);
}

class AlbumsView extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new AlbumsViewState();

}


class AlbumsViewState extends State<AlbumsView> implements AlbumsViewLoader {

  final AlbumRepo _repo = ServiceLocator.getAlbumRepo();

  AlbumsPresenter _presenter;

  BuildContext _context;

  List<_CellAlbum> _albumCellList;

  List<AlbumDto> _albumList;

  AlbumsView() {
//    _presenter = ServiceLocator.getAlbumsPresenter();
//    _presenter.loadData(this);

//    _albumCellList = _buildAlbumCell();
  }

  List<_CellAlbum> getCells() {
    if (_albumCellList != null) {
      return _albumCellList;
    } else {
      return new List<_CellAlbum>();
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return new Scaffold(
        appBar: new AppBar(title: new Text('Albums')),
        backgroundColor: Colors.grey[100],
        body: new ListView(
            children: _buildAlbumCell()
//            children: getCells()
        )
    );
  }

  void onSignedInError() {
    var alert = new AlertDialog(
      title: new Text("Sign in Error"),
      content: new Text("There was an error signing in. Please try again."),
    );
    showDialog(context: _context, child: alert);
  }

  @override
  Future<Null> loadFailed(String errorMessage) async {
    return showDialog<Null>(
      context: _context,
      barrierDismissible: false, // user must tap button!
      child: new AlertDialog(
//        title: new Text('Rewind and remember'),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text(errorMessage),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text('OK'),
            onPressed: () {
              Navigator.of(_context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _presenter = ServiceLocator.getAlbumsPresenter();
    _presenter.loadData(this);
  }

  @override
  loadedItems(List<AlbumDto> albumList) {
    setState(() {
      _albumList = albumList;
    }
    );
  }

  @override
  loadingItems() {
    // TODO: implement loadingItems
  }

  List<_CellAlbum> _buildAlbumCell() {
    List<AlbumDto> list = _albumList;

    if (list == null) {
      list = new List<AlbumDto>();
    }

    return list.map((album) =>
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
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,

            children: <Widget>[

              new ThumbnailView(thumbnail: _albumDto.thumbnail),
              new Padding(
                padding: new EdgeInsets.all(8.0),
                child:
                new TextCaption(
                    "Very long text that will span multiple lines easilyyy really reallyyyy"),
              ),
            ],

          ),
        ),
      ),

//      ),
    );
  }
}
