import 'dart:async';
import 'dart:convert';

import 'package:amazingwallpapers/AlbumDto.dart';
import 'package:amazingwallpapers/Domain.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ServerAlbumRepo extends AlbumRepo {

  final _ServerDomain = "http://amazingdomain.net/";
  final _AlbumDirectory = "albums";
  final _AlbumKspUrl = "album/customrss?url=https://www.reddit.com/r/KerbalSpaceProgram/.rss";

  @override
  List<AlbumDto> getAlbumList() {
    debugPrint("Hello log world");
    List list = new List<AlbumDto>();

    list.add(new AlbumDto(
        thumbnail: "https://scontent-frt3-2.cdninstagram.com/vp/99d744b652e3acbc1da4977d3a3c770c/5B45E495/t51.2885-15/e35/27892594_1977419992285579_3382350220921667584_n.jpg",
        niceName: "Test album 1"
    ));


    return list;
  }

  @override
  Future<List<AlbumDto>> getAlbumListAsync() async {
    var response = await http.get('${_ServerDomain}${_AlbumDirectory}');
    final json = JSON.decode(response.body);

    return AlbumDto.listFromJson(json);

  }
}