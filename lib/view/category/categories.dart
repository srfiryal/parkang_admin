import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parkang_admin/models/category_model.dart';
import 'package:parkang_admin/services/database_service.dart';
import 'package:parkang_admin/shared/loading.dart';
import 'package:parkang_admin/shared/shared_code.dart';
import 'package:parkang_admin/view/category/category_form.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance.collection('categories').orderBy('createdAt', descending: true).snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Category')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (b) => const CategoryForm()));
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Loading());
          }

          return snapshot.data!.docs.isEmpty ? const Center(child: Text('You don\'t have any categories.')) : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  CategoryModel model = CategoryModel.fromMap(document.id, data);
                  return _buildMenuItem(model);
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(CategoryModel model) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model.title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              )),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: VerticalDivider(color: Colors.grey),
              ),
              GestureDetector(
                  onTap: () {
                    SharedCode.navigatorPush(context, CategoryForm(isEdit: true, model: model));
                  },
                  child: const Icon(Icons.edit, color: Colors.grey)
              ),
              const SizedBox(width: 5.0),
              GestureDetector(
                  onTap: () {
                    _showConfirmationDialog(model);
                  },
                  child: const Icon(Icons.delete, color: Colors.red)
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        const Divider(color: Colors.grey),
        const SizedBox(height: 5),
      ],
    );
  }

  Future<void> _showConfirmationDialog(CategoryModel model) async {
    SharedCode.showConfirmationDialog(
        context,
        'Confirmation',
        'Are you sure to delete this category?',
        () async {
          await DatabaseService().deleteCategory(model);
          Navigator.pop(context);
          SharedCode.showSnackBar(context, 'success', 'Category has been deleted.');
        }
    );
  }
}
