import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id, title;

  CategoryModel({this.id = '', required this.title});

  factory CategoryModel.fromMap(String id, Map<dynamic, dynamic> json) {
    return CategoryModel(
      id: id,
      title: json['title'] ?? '',
    );
  }
  CategoryModel.fromJson(Map<String, Object?> json)
      : this(
    title: json['title']! as String,
  );

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'createdAt': FieldValue.serverTimestamp()
    };
  }
}