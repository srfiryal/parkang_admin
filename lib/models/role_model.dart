import 'package:cloud_firestore/cloud_firestore.dart';

class RoleModel {
  final String role, name, email;

  RoleModel({required this.role, required this.name, required this.email});

  factory RoleModel.fromMap(String id, Map<dynamic, dynamic> json) {
    return RoleModel(
      role: json['role'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
  RoleModel.fromJson(Map<String, Object?> json)
      : this(
    role: json['role']! as String,
    name: json['name']! as String,
    email: json['email']! as String,
  );

  Map<String, Object?> toJson() {
    return {
      'role': role,
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp()
    };
  }
}