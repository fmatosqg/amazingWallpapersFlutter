import 'package:flutter/cupertino.dart';

@immutable
class AlbumDto {
  AlbumDto({this.idd, this.niceName, this.thumbnail});

  final String idd;
  final String niceName;
  final String thumbnail;

  factory AlbumDto.fromJson(Map<String, dynamic> json) {
    return new AlbumDto(
      niceName: json['niceName'],
      thumbnail: json['thumbnail'],
      idd: json['niceName'],
    );
  }

  static List<AlbumDto> listFromJson(List<dynamic> json) {
    List list = new List();

    list = json.map((item) => new AlbumDto.fromJson(item)).toList();

    return list;
  }
}
