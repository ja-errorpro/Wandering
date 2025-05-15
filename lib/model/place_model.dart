import 'package:flutter/material.dart';

class PlaceModel {
  String? id;
  String? name;
  String? description;
  Image? image;
  List<String>? categories;
  // double? latitude; // 緯度
  // double? longitude; // 經度

  PlaceModel({
    this.id,
    this.name,
    this.description,
    this.image,
    this.categories,
    // this.latitude,
    // this.longitude,
  });

  PlaceModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    image = json['image'] != null ? Image.network(json['image']) : null;
    // categories = json['categories'] != null
    //     ? List<String>.from(json['categories'])
    // latitude = json['latitude'];
    // longitude = json['longitude'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    if (image != null) {
      data['image'] = image!.image.toString(); // 這裡需要根據實際情況處理圖片
    }
    if (categories != null) {
      data['categories'] = categories;
    }
    // data['latitude'] = latitude;
    // data['longitude'] = longitude;
    return data;
  }

  factory PlaceModel.fromMap(Map<String, dynamic> map) {
    return PlaceModel(
      name: map['name'],
      description: map['description'],
      image: map['image'] != null ? Image.network(map['image']) : null,
      categories: map['categories'] != null
          ? List<String>.from(map['categories'])
          : [],
      // latitude: map['latitude'],
      // longitude: map['longitude'],
    );
  }
}
