class ImageModel {
  int? id;
  String? imgUrl;
  String? name;
  String? area;
  String? club;

  ImageModel({this.id, this.imgUrl, this.name, this.area, this.club});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      imgUrl: json['imgUrl'],
      name: json['name'],
      area: json['area'],
      club: json['club'],
    );
  }
}
