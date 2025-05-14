import 'package:flutter/material.dart';

class PlaceModel {
  String? name;
  String? description;
  Image? image;
  double? latitude; // 緯度
  double? longitude; // 經度

  PlaceModel({
    this.name,
    this.description,
    this.image,
    this.latitude,
    this.longitude,
  });

  PlaceModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    image = json['image'] != null ? Image.network(json['image']) : null;
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    if (image != null) {
      data['image'] = image!.image.toString(); // 這裡需要根據實際情況處理圖片
    }
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
