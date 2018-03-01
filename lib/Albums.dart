import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlbumsView extends StatelessWidget {

  AlbumRepo _repo = ServiceLocator.getAlbumRepo();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text('Albums')),
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
      child: new Card(
          child:
          new SizedBox(
            height: 200.0,
              child: new Image.network(
                _albumDto.thumbnail,
                fit: BoxFit.fitWidth,),
//            ),
          )
      ),
    );
  }
}

class AlbumRepo {
  List<AlbumDto> getAlbumList() {
    return null;
  }
}

class AlbumDto {

  AlbumDto({String id, String niceName, String thumbnail}) {
    this.thumbnail = thumbnail;
  }

  String id;
  String niceName = "nice";
  String thumbnail;
}

class ServiceLocator {
  static AlbumRepo getAlbumRepo() {
    return new MockedAlbumRepo();
  }
}

class MockedAlbumRepo extends AlbumRepo {
  List<AlbumDto> getAlbumList() {
    List list = new List<AlbumDto>();

    list.add(new AlbumDto(
        thumbnail: "https://scontent-frt3-2.cdninstagram.com/vp/99d744b652e3acbc1da4977d3a3c770c/5B45E495/t51.2885-15/e35/27892594_1977419992285579_3382350220921667584_n.jpg"));
    list.add(new AlbumDto(
        thumbnail: "https://scontent-lht6-1.cdninstagram.com/vp/80c29607484f586669b5c6a0565eb83e/5B102070/t51.2885-15/e35/28436109_2068670090078578_2891429235581255680_n.jpg"));

    list.add(new AlbumDto(
        thumbnail: "https://scontent-lht6-1.cdninstagram.com/vp/80c29607484f586669b5c6a0565eb83e/5B102070/t51.2885-15/e35/28436109_2068670090078578_2891429235581255680_n.jpg"));

    return list;
  }
}