import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id, name, description, imageUrl, categoryId;
  final int price;
  final bool isActive;

  ProductModel(
      {this.id = '',
      required this.name,
      required this.description,
      required this.imageUrl,
      required this.price,
      required this.categoryId,
      required this.isActive});

  factory ProductModel.fromMap(String id, Map<dynamic, dynamic> json) {
    return ProductModel(
      id: id,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: json['price'] ?? 0,
      categoryId: json['categoryId'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }
  ProductModel.fromJson(Map<String, Object?> json)
      : this(
    name: json['name']! as String,
    description: json['description']! as String,
    imageUrl: json['imageUrl']! as String,
    price: json['price']! as int,
    categoryId: json['categoryId']! as String,
    isActive: json['isActive']! as bool,
  );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'categoryId': categoryId,
      'isActive': isActive,
      'createdAt': FieldValue.serverTimestamp()
    };
  }
}