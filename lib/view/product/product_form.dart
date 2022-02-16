import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkang_admin/models/category_model.dart';
import 'package:parkang_admin/models/product_model.dart';
import 'package:parkang_admin/services/database_service.dart';
import 'package:parkang_admin/shared/custom_text_field.dart';
import 'package:parkang_admin/shared/loading.dart';
import 'package:parkang_admin/shared/shared_code.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({Key? key, this.isEdit = false, this.model}) : super(key: key);
  final bool isEdit;
  final ProductModel? model;

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _isActive = true;
  XFile _imageFile = XFile('');
  String _imageUrl = '';
  final String _defaultImageUrl = 'https://firebasestorage.googleapis.com/v0/b/parkang-e7109.appspot.com/o/cubes.png?alt=media&token=924d5580-e41d-480b-a18c-fc940f590c2a';
  final picker = ImagePicker();
  List<CategoryModel> _categoryDropdownList = [];
  String _category = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.model != null) {
      _nameController.text = widget.model!.name;
      _descriptionController.text = widget.model!.description;
      _priceController.text = widget.model!.price.toString();
      _weightController.text = widget.model!.weight.toString();
      _imageUrl = widget.model!.imageUrl;
      _isActive = widget.model!.isActive;
    }
    _imageUrl = _imageUrl.isEmpty ? _defaultImageUrl : _imageUrl;
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _getCategoryDropdownData();
    _setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isEdit ? 'Edit Product' : 'Add Product')),
      body: _isLoading
          ? const Center(child: Loading())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          SizedBox(
                            width: 100.0,
                            height: 100.0,
                            child: _imageFile.path == ''
                                ? Image.network(_imageUrl)
                                : ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.file(File(_imageFile.path),
                                    fit: BoxFit.fill)),
                          ),
                          Positioned.fill(
                            child: Align(
                                alignment: Alignment.bottomRight,
                                child: SizedBox(
                                  width: 35.0,
                                  height: 35.0,
                                  child: FloatingActionButton(
                                    elevation: 0.0,
                                    onPressed: () => pickImage(),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 18.0,
                                    ),
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                              label: 'Name',
                              controller: _nameController,
                              validator: SharedCode.emptyValidator),
                          const SizedBox(height: 15),
                          CustomTextField(
                              label: 'Description',
                              minLines: 3,
                              controller: _descriptionController,
                              validator: SharedCode.emptyValidator),
                          const SizedBox(height: 15),
                          CustomTextField(
                              label: 'Price',
                              textInputType: TextInputType.number,
                              controller: _priceController,
                              validator: SharedCode.emptyValidator),
                          const SizedBox(height: 15),
                          CustomTextField(
                              label: 'Weight (in gram)',
                              textInputType: TextInputType.number,
                              controller: _weightController,
                              validator: SharedCode.emptyValidator),
                          const SizedBox(height: 15),
                          _buildDropdownCategory(),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Is Available'),
                              Switch(value: _isActive, onChanged: (b) {
                                setState(() {
                                  _isActive = b;
                                });
                              }),
                            ],
                          ),
                          const SizedBox(height: 15),
                          OutlinedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _uploadToFirebase(context);
                                }
                              },
                              child: Text(widget.isEdit ? 'Save' : 'Add')),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _setLoading(bool isLoading) {
    if (mounted) {
      setState(() {
        _isLoading = isLoading;
      });
    } else {
      _isLoading = isLoading;
    }
  }

  Future<void> _save() async {
    _setLoading(true);
    try {
      String name = _nameController.text;
      int price = int.parse(_priceController.text);
      int weight = int.parse(_weightController.text);
      String description = _descriptionController.text;
      ProductModel model = ProductModel(name: name, price: price, categoryId: _category, description: description, imageUrl: _imageUrl, isActive: _isActive, weight: weight);
      widget.isEdit ? await DatabaseService().saveProduct(widget.model!, model) : await DatabaseService().addProduct(model);
      SharedCode.showSnackBar(context, 'success', widget.isEdit ? 'Product has been edited' : 'Product has been added');
      Navigator.pop(context);
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      SharedCode.showSnackBar(context, 'error', e.toString());
    }
  }

  Future<void> _uploadToFirebase(BuildContext context) async {
    _setLoading(true);
    if (_imageFile.path.isNotEmpty) {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });

        String fileName =
            '${DateTime.now().millisecondsSinceEpoch.toString()}.png';
        Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('category/$fileName');
        File file = File(_imageFile.path);
        UploadTask uploadTask = firebaseStorageRef.putFile(file);
        TaskSnapshot taskSnapshot = await uploadTask;
        taskSnapshot.ref.getDownloadURL().then(
              (url) async {
            _imageUrl = url;
            await _save();
          },
        ).catchError((err) {
          SharedCode.showSnackBar(context, 'error', err);
        });
      }
    } else {
      await _save();
    }
    _setLoading(false);
  }

  Future pickImage() async {
    final pickedFile =
    await picker.pickImage(source: ImageSource.gallery, maxHeight: 200);
    print(pickedFile!.path);

    setState(() {
      _imageFile = pickedFile;
    });
  }

  Widget _buildDropdownCategory() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Category'),
        const SizedBox(height: 5.0),
        Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border.all(color: Colors.black),
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                isExpanded: true,
                value: _category,
                onChanged: (String? newValue) {
                  setState(() {
                    _category = newValue!;
                  });
                },
                items: _categoryDropdownList.map((value) {
                  return DropdownMenuItem<String>(
                    value: value.id,
                    child: Text(value.title),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _getCategoryDropdownData() async {
    _categoryDropdownList = [];
    CollectionReference category =
    FirebaseFirestore.instance.collection('categories');
    QuerySnapshot snapshot =
    await category.orderBy('createdAt', descending: false).get();
    if (snapshot.size > 0) {
      for (var element in snapshot.docs) {
        Map<String, dynamic> document = element.data() as Map<String, dynamic>;
        CategoryModel model = CategoryModel.fromMap(element.id, document);
        _categoryDropdownList.add(model);
      }

      _category = _categoryDropdownList[0].id;
    }
  }
}
