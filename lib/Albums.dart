import 'dart:async';

import 'package:amazingwallpapers/AlbumDto.dart';
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
  AlbumsView();

  factory AlbumsView.forDesignTime() {
    return new AlbumsView();
  }

  @override
  State<StatefulWidget> createState() => new AlbumsViewState();
}

class AlbumsViewState extends State<AlbumsView> implements AlbumsViewLoader {
  AlbumsPresenter _presenter;

  List<AlbumDto> _albumList;
  List<AlbumDto> _albumListUnfiltered;
  List<String> _dismissedIds = new List();

  Scaffold _scaffold;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _isTutorialShown = false;

  @override
  Widget build(BuildContext context) {
    _scaffold = new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(
          'Albums',
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: _buildAlbumCell(),
    );

    return _scaffold;
  }

  void onSignedInError() {
    var alert = new AlertDialog(
      title: new Text("Sign in Error"),
      content: new Text("There was an error signing in. Please try again."),
    );
    showDialog(context: context, child: alert);
  }

  @override
  Future<Null> loadFailed(String errorMessage) async {
    return showDialog<Null>(
      context: context,
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
              Navigator.of(context).pop();
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
      _albumListUnfiltered = albumList;

      filterList();

      if (!_isTutorialShown) {
        _scaffoldKey.currentState.showSnackBar(
          new SnackBar(content: Text("Swipe cards to dismiss")),
        );
      }
      _isTutorialShown = true;
    });
  }

  List filterList() {
    _albumList = new List();
    _albumList.addAll(_albumListUnfiltered);

    _albumList.removeWhere((album) => _dismissedIds.contains(album.idd));

    print("List before cleaning ${_albumListUnfiltered.length}");
    print("List after cleaning ${_albumList.length}");

    return _albumList;
  }

  @override
  loadingItems() {
    // TODO: implement loadingItems
  }

  Widget _buildAlbumCell() {
    Widget w;

    if (_albumList == null) {
      w = new Center(
        child: new Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Text("Loading"),
            ),
          ],
        ),
      );
    } else {
      List<Widget> list = _albumList
          .map((album) => new _CellAlbum(album, onDismissed))
          .toList();

      w = new ListView(children: list);
    }

    return w;
  }

  void onDismissed(
      String id, DismissDirection direction, BuildContext context) {
    setState(() {
      _dismissedIds.add(id);
      filterList();
    });

    showSnackBar(id, context);
  }

  void showSnackBar(String id, BuildContext context) {
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Row(
      children: <Widget>[
        new Expanded(
          child: new Text(
            'Dismissed $id',
            maxLines: 1,
            overflow: TextOverflow.fade,
          ),
        ),
        new MaterialButton(
            onPressed: () {
              _undoDismiss(id);
            },
            textColor: Colors.blue,
            child: new Text(
              "Undo",
            ))
      ],
    )));
  }

  _undoDismiss(String id) {
    setState(() {
      _dismissedIds.remove(id);
      print("Why did you press the snackbar???");
      filterList();
    });
  }
}

typedef void OnDismissAlbum(
    String id, DismissDirection direction, BuildContext context);

class _CellAlbum extends StatelessWidget {
  AlbumDto _albumDto;
  OnDismissAlbum _dismissable;

  _CellAlbum(this._albumDto, this._dismissable);

  factory _CellAlbum.forDesignTime() {
    return new _CellAlbum(null, null);
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: new Dismissible(
        key: new Key(_albumDto.idd),
        onDismissed: (direction) =>
            _dismissable(_albumDto.idd, direction, context),
        child: new Card(
          elevation: 4.0,
          child: new Container(
            color: Colors.grey[800],
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new ThumbnailView(thumbnail: _albumDto.thumbnail),
                new Padding(
                  padding: new EdgeInsets.all(8.0),
                  child: new TextCaption(
                    _albumDto.niceName,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
