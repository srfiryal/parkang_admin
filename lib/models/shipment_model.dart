import 'package:cloud_firestore/cloud_firestore.dart';

class ShipmentModel {
  final String estimation, name;
  final int price;

  ShipmentModel(
      {
      required this.name,
      required this.estimation,
      required this.price});

  factory ShipmentModel.fromMap(String id, Map<dynamic, dynamic> json) {
    return ShipmentModel(
      name: json['name'] ?? '',
      estimation: json['estimation'] ?? '',
      price: json['price'] ?? 0,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'estimation': estimation,
      'price': price,
      'createdAt': FieldValue.serverTimestamp()
    };
  }
}
