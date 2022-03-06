import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkang_admin/models/product_model.dart';

class ProductOrderModel {
  final String id;
  int quantity;
  final ProductModel product;

  ProductOrderModel({this.id = '', required this.quantity, required this.product});

  factory ProductOrderModel.fromMap(String id, Map<dynamic, dynamic> json) {
    return ProductOrderModel(
      id: id,
      quantity: json['quantity'] as int,
      product: ProductModel.fromMap(id, json['product']),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'quantity': quantity,
      'product': product.toJson(),
      'updatedAt': FieldValue.serverTimestamp()
    };
  }

  Map<String, Object?> toJsonOrder() {
    return {
      'quantity': quantity,
      'product': product.toJsonOrder(),
    };
  }
}
