import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parkang_admin/models/category_model.dart';
import 'package:parkang_admin/models/product_model.dart';
import 'package:parkang_admin/models/role_model.dart';

class DatabaseService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  Future<String> getUserRole(String uid) async {
    try {
      DocumentSnapshot snapshot = await users.doc(uid).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return data['role'];
    } catch (e) {
      print(e.toString());
      return 'Error';
    }
  }

  Future<dynamic> createDefaultUser(
      String uid, String role, User? user, String name) async {
    try {
      RoleModel roleModel =
          RoleModel(role: 'admin', email: user!.email ?? '', name: name);
      await users.doc(uid).set(roleModel.toJson());
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future<dynamic> addCategory(CategoryModel model) async {
    try {
      QuerySnapshot snapshot =
          await categories.where('title', isEqualTo: model.title).get();
      if (snapshot.docs.isNotEmpty) {
        throw 'Category with this title already exist.';
      }
      await categories.add(model.toJson());
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future<dynamic> deleteCategory(CategoryModel model) async {
    try {
      await categories.doc(model.id).delete();
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future<dynamic> saveCategory(
      CategoryModel oldModel, CategoryModel model) async {
    if (oldModel.title != model.title) {
      try {
        QuerySnapshot snapshot =
            await categories.where('title', isEqualTo: model.title).get();
        if (snapshot.docs.isNotEmpty) {
          throw 'Category with this title already exist';
        }
        await categories.doc(oldModel.id).set(model.toJson());
      } catch (e) {
        print(e.toString());
        return e.toString();
      }
    }
  }

  Future<dynamic> addProduct(ProductModel model) async {
    try {
      await products.add(model.toJson());
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future<dynamic> deleteProduct(ProductModel model) async {
    try {
      await products.doc(model.id).delete();
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future<dynamic> saveProduct(ProductModel oldModel, ProductModel model) async {
    try {
      await products.doc(oldModel.id).set(model.toJson());
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
