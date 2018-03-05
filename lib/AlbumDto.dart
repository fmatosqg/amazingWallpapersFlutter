class AlbumDto {

  AlbumDto({String id, String niceName, String thumbnail}) {
    this.thumbnail = thumbnail;
    this.niceName = niceName;
  }

  String id;
  String niceName = "nice";
  String thumbnail = "https://scontent-frt3-2.cdninstagram.com/vp/99d744b652e3acbc1da4977d3a3c770c/5B45E495/t51.2885-15/e35/27892594_1977419992285579_3382350220921667584_n.jpg";

  factory AlbumDto.fromJson(Map<String, dynamic> json) {
    return new AlbumDto(
      niceName: json['niceName'],
      thumbnail: json['thumbnail'],
    );
  }

  static List<AlbumDto> listFromJson(List<dynamic> json) {
    List list = new List();

    list = json.map((item) =>
    new AlbumDto.fromJson(item)).toList();

    return list;
  }

}