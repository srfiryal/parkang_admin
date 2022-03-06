import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id, name, description, imageUrl, categoryId;
  final int price, weight;
  final bool isActive;

  ProductModel(
      {this.id = '',
        required this.name,
        required this.description,
        required this.imageUrl,
        required this.price,
        required this.weight,
        required this.categoryId,
        required this.isActive
      });

  factory ProductModel.fromMap(String id, Map<dynamic, dynamic> json) {
    return ProductModel(
      id: id,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: json['price'] ?? 0,
      weight: json['weight'] ?? 0,
      categoryId: json['categoryId'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'weight': weight,
      'categoryId': categoryId,
      'isActive': isActive,
      'createdAt': FieldValue.serverTimestamp()
    };
  }

  Map<String, Object?> toJsonOrder() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'weight': weight,
      'categoryId': categoryId,
      'isActive': isActive,
    };
  }
}