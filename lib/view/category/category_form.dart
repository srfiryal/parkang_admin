import 'package:flutter/material.dart';
import 'package:parkang_admin/models/category_model.dart';
import 'package:parkang_admin/services/database_service.dart';
import 'package:parkang_admin/shared/custom_text_field.dart';
import 'package:parkang_admin/shared/loading.dart';
import 'package:parkang_admin/shared/shared_code.dart';

class CategoryForm extends StatefulWidget {
  const CategoryForm({Key? key, this.isEdit = false, this.model}) : super(key: key);
  final bool isEdit;
  final CategoryModel? model;

  @override
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.model != null) {
      _titleController.text = widget.model!.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isEdit ? 'Edit Category' : 'Add Category')),
      body: _isLoading
          ? const Center(child: Loading())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                          label: 'Name',
                          controller: _titleController,
                          validator: SharedCode.emptyValidator),
                      const SizedBox(height: 15),
                      OutlinedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _save();
                            }
                          },
                          child: Text(widget.isEdit ? 'Save' : 'Add')),
                      const SizedBox(height: 15),
                    ],
                  ),
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
      CategoryModel model = CategoryModel(title: _titleController.text);
      widget.isEdit ? await DatabaseService().saveCategory(widget.model!, model) : await DatabaseService().addCategory(model);
      SharedCode.showSnackBar(context, 'success', widget.isEdit ? 'Category has been edited' : 'Category has been added');
      Navigator.pop(context);
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      SharedCode.showSnackBar(context, 'error', e.toString());
    }
  }
}
