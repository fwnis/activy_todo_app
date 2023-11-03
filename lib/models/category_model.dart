import 'package:flutter/material.dart';

class CategoryModel {
  String id;
  String name;
  MaterialColor color;

  CategoryModel({
    required this.id,
    required this.name,
    required this.color,
  });

  CategoryModel.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        color = map["color"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "color": color,
    };
  }
}
