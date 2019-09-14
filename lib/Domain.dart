import 'dart:async';

import 'AlbumDto.dart';
import 'Albums.dart';
import 'ServerAlbumRepo.dart';

abstract class AlbumRepo {
  List<AlbumDto> getAlbumList();

  Future<List<AlbumDto>> getAlbumListAsync();
}

class ServiceLocator {
  static AlbumRepo getAlbumRepo() {
    return new ServerAlbumRepo();
  }

  static getAlbumsPresenter() {
    return new AlbumsPresenter(albumRepo: getAlbumRepo());
  }
}

class AlbumsPresenter {
  AlbumRepo _albumRepo;

  AlbumsPresenter({AlbumRepo albumRepo}) {
    _albumRepo = albumRepo;
  }

  void loadData(AlbumsViewLoader view) {
    var stream = new Stream.periodic(const Duration(seconds: 10), (count) {
      print("Fire periodic stream");
      _fetchData(view);
    });

    stream.listen((result) {
      print("Listen periodic stream");
    });
  }

  String _fetchData(AlbumsViewLoader view) {
    view.loadingItems();

    _albumRepo
        .getAlbumListAsync()
        .then((list) => view.loadedItems(list))
        .catchError((onError) {
      view.loadFailed("Just because");
    });

    return "Ok periodic stream";
  }
}
