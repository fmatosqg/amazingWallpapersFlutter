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
    return _registerWidgetInstance(0, new AlbumsView());
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

  @override
  Widget build(BuildContext context) {
    _scaffold = _registerWidgetInstance(1, new Scaffold(
      appBar: _registerWidgetInstance(2, new AppBar(
        title: _registerWidgetInstance(3, new Text('Albums')),
      )),
      body: _registerWidgetInstance(4, _buildAlbumCell()),
    ));

    return _scaffold;
  }

  void onSignedInError() {
    var alert = _registerWidgetInstance(5, new AlertDialog(
      title: _registerWidgetInstance(6, new Text("Sign in Error")),
      content: _registerWidgetInstance(7, new Text("There was an error signing in. Please try again.")),
    ));
    showDialog(context: context, child: alert);
  }

  @override
  Future<Null> loadFailed(String errorMessage) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      child: _registerWidgetInstance(8, new AlertDialog(
//        title: new Text('Rewind and remember'),
        content: _registerWidgetInstance(9, new SingleChildScrollView(
          child: _registerWidgetInstance(10, new ListBody(
            children: <Widget>[
              _registerWidgetInstance(11, new Text(errorMessage)),
            ],
          )),
        )),
        actions: <Widget>[
          _registerWidgetInstance(12, new FlatButton(
            child: _registerWidgetInstance(13, new Text('OK')),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
        ],
      )),
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
      w = _registerWidgetInstance(14, new Center(
        child: _registerWidgetInstance(15, new Column(
          children: [
            _registerWidgetInstance(16, new Text("Loading")),
          ],
        )),
      ));
    } else {
      List<Widget> list = _albumList
          .map((album) => _registerWidgetInstance(17, new _CellAlbum(album, onDismissed)))
          .toList();

      w = _registerWidgetInstance(18, new ListView(children: list));
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
    Scaffold.of(context).showSnackBar(_registerWidgetInstance(19, new SnackBar(
            content: _registerWidgetInstance(20, new Row(
          children: <Widget>[
            _registerWidgetInstance(21, new Expanded(
              child: _registerWidgetInstance(22, new Text(
                'Dismissed $id',
                maxLines: 1,
                overflow: TextOverflow.fade,
              )),
            )),
            _registerWidgetInstance(23, new MaterialButton(
                onPressed: () {
                  _undoDismiss(id);
                },
                textColor: Colors.blue,
                child: _registerWidgetInstance(24, new Text(
                  "Undo",
                ))))
          ],
        )))));
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
    return _registerWidgetInstance(25, new _CellAlbum(null, null));
  }

  @override
  Widget build(BuildContext context) {
    return _registerWidgetInstance(26, new Padding(
      padding: new EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: _registerWidgetInstance(27, new Dismissible(
        key: new Key(_albumDto.idd),
        onDismissed: (direction) =>
            _dismissable(_albumDto.idd, direction, context),
        child: _registerWidgetInstance(28, new Card(
          elevation: 4.0,
          child: _registerWidgetInstance(29, new Container(
            color: Colors.grey[800],
            child: _registerWidgetInstance(30, new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _registerWidgetInstance(31, new ThumbnailView(thumbnail: _albumDto.thumbnail)),
                _registerWidgetInstance(32, new Padding(
                  padding: new EdgeInsets.all(8.0),
                  child: _registerWidgetInstance(33, new TextCaption(
                    _albumDto.niceName,
                  )),
                )),
              ],
            )),
          )),
        )),
      )),
    ));
  }
}

final flutterDesignerWidgets = <int, Widget>{};

T _registerWidgetInstance<T extends Widget>(int id, T widget) {
  flutterDesignerWidgets[id] = widget;
  return widget;
}
