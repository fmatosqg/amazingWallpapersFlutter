import 'package:flutter/cupertino.dart';

@immutable
class AlbumListDto {
  AlbumListDto({this.id, this.niceName, this.thumbnail, this.url});

  final String id;
  final String niceName;
  final String thumbnail;
  final String url;

  factory AlbumListDto.fromJson(Map<String, dynamic> json) {
    return new AlbumListDto(
        niceName: json['niceName'],
        thumbnail: json['thumbnail'],
        id: json['name'],
        url: json['url']);
  }

  static List<AlbumListDto> listFromJson(List<dynamic> json) {
    List list = new List();

    list = json.map((item) => new AlbumListDto.fromJson(item)).toList();

    return list;
  }
}

@immutable
class AlbumDetailDto {
  final String link;
  final List<AlbumDetailPictureDto> photos;

  AlbumDetailDto({this.link,this.photos});

  factory AlbumDetailDto.fromJson(Map<String, dynamic> json) {
    return AlbumDetailDto(
      link: json['link'],
      photos: AlbumDetailPictureDto.listFromJson(json['photos'])
    );
  }
}

@immutable
class AlbumDetailPictureDto {
  final String caption;
  final String url;

  AlbumDetailPictureDto({this.caption,this.url});

  factory AlbumDetailPictureDto.fromJson(Map<String, dynamic> json) {
    return new AlbumDetailPictureDto(
      caption: json['caption'],
      url:json['url'],
    );
  }

  static List<AlbumDetailPictureDto> listFromJson(List<dynamic> json) {
    List list = new List();

    list =
        json.map((item) => new AlbumDetailPictureDto.fromJson(item)).toList();

    return list;
  }
}
