import 'package:cloud_firestore/cloud_firestore.dart';

class ShippingModel {
  final String id,
      name,
      province,
      city,
      subDistrict,
      postalCode,
      address,
      phone;

  ShippingModel(
      {this.id = '',
      required this.name,
      required this.province,
      required this.city,
      required this.subDistrict,
      required this.postalCode,
      required this.address,
      required this.phone});

  factory ShippingModel.fromMap(String id, Map<dynamic, dynamic> json) {
    return ShippingModel(
      id: id,
      name: json['name'] as String,
      province: json['province'] as String,
      city: json['city'] as String,
      subDistrict: json['subDistrict'] as String,
      postalCode: json['postalCode'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'province': province,
      'city': city,
      'postalCode': postalCode,
      'subDistrict': subDistrict,
      'address': address,
      'phone': phone,
      'updatedAt': FieldValue.serverTimestamp()
    };
  }
}
