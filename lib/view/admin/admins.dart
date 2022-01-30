import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parkang_admin/models/role_model.dart';
import 'package:parkang_admin/shared/loading.dart';
import 'package:parkang_admin/view/admin/admin_form.dart';

class Admins extends StatefulWidget {
  const Admins({Key? key}) : super(key: key);

  @override
  _AdminsState createState() => _AdminsState();
}

class _AdminsState extends State<Admins> {
  final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'admin').orderBy('createdAt', descending: true).snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (b) => const AdminForm()));
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

          return snapshot.data!.docs.isEmpty ? const Center(child: Text('You don\'t have any admins.')) : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  RoleModel model = RoleModel.fromMap(document.id, data);
                  return _buildMenuItem(model);
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(RoleModel model) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                  Text(model.email),
                ],
              )),
            ],
          ),
        ),
        const SizedBox(height: 5),
        const Divider(color: Colors.grey),
        const SizedBox(height: 5),
      ],
    );
  }
}
