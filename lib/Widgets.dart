import 'package:flutter/material.dart';

class ThumbnailView extends StatelessWidget {
  String _thumbnail;

  ThumbnailView({String thumbnail}) {
    _thumbnail = thumbnail;
  }

  factory ThumbnailView.forDesignTime() {
    return new ThumbnailView();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.blueGrey[200],
      foregroundDecoration: new BoxDecoration(
          gradient: new LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.grey[800].withOpacity(0.1),
            Colors.grey[800].withOpacity(0.9)
          ])),
      child: new Image.network(
        _thumbnail,
        height: 150.0,
        fit: BoxFit.cover,
      ),
    );
  }
}

class TextCaption extends Text {
  TextCaption(String data) : super(data);

  @override
  Widget build(BuildContext context) {
    Widget w = super.build(context);
    return w;
  }
}
