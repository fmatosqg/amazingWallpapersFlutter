import 'dart:convert';

import 'package:amazing_wallpapers_flutter/domain/api/AlbumDto.dart';
import 'package:http/http.dart';

/// Gets album information from server.
///
class AlbumApi {
  final _serverDomain = "https://www.amazingdomain.net/";
  final _albumDirectory = "albums";
  // final _albumKspUrl =
  // "album/customrss?url=https://www.reddit.com/r/KerbalSpaceProgram/.rss";

  @override
  Future<List<AlbumListDto>> getAlbumListAsync() async {
    var response = await get('$_serverDomain$_albumDirectory');
    final json = jsonDecode(response.body);

    return AlbumListDto.listFromJson(json);
  }

  Future<AlbumDetailDto> getAlbumDetail(String relativeUrl) async {
    final response = await get('$_serverDomain$relativeUrl');
    final json = jsonDecode(response.body);

    return AlbumDetailDto.fromJson(json);
  }
}
