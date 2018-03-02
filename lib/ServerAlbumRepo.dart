import 'dart:async';

import 'package:amazingwallpapers/Domain.dart';



class ServerAlbumRepo extends AlbumRepo {

  @override
  List<AlbumDto> getAlbumList(){
    return null;
  }

  @override
  Future<List<AlbumDto>> getAlbumListAsync(){
    return new Future.value(getAlbumList());
  }
}