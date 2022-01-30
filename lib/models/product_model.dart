import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id, name, description, imageUrl, categoryId;
  final int price;

  ProductModel(
      {this.id = '',
      required this.name,
      required this.description,
      required this.imageUrl,
      required this.price,
      required this.categoryId});

  factory ProductModel.fromMap(String id, Map<dynamic, dynamic> json) {
    return ProductModel(
      id: id,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: json['price'] ?? 0,
      categoryId: json['categoryId'] ?? '',
    );
  }
  ProductModel.fromJson(Map<String, Object?> json)
      : this(
    name: json['name']! as String,
    description: json['description']! as String,
    imageUrl: json['imageUrl']! as String,
    price: json['price']! as int,
    categoryId: json['categoryId']! as String,
  );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'categoryId': categoryId,
      'createdAt': FieldValue.serverTimestamp()
    };
  }
}