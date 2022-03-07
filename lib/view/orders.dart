import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkang_admin/models/order_model.dart';
import 'package:parkang_admin/shared/loading.dart';
import 'package:parkang_admin/shared/shared_code.dart';
import 'package:parkang_admin/view/order_detail.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> with SingleTickerProviderStateMixin {
  final List<Tab> _tabMenus = [
    const Tab(text: 'Unpaid'),
    const Tab(text: 'In Progress'),
    const Tab(text: 'On Delivery'),
    const Tab(text: 'Completed'),
    const Tab(text: 'Canceled'),
  ];
  final List<OrderModel> _orders = [];
  late TabController _tabController;

  Stream<QuerySnapshot> _stream = FirebaseFirestore.instance
      .collection('orders')
      .where('status', isEqualTo: 'unpaid')
      .orderBy('createdAt', descending: true)
      .snapshots();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(length: _tabMenus.length, vsync: this);
    _tabController.addListener(() {
      String status = 'unpaid';
      switch (_tabController.index) {
        case 0:
          status = 'unpaid';
          break;
        case 1:
          status = 'processed';
          break;
        case 2:
          status = 'delivered';
          break;
        case 3:
          status = 'completed';
          break;
        case 4:
          status = 'canceled';
          break;
      }
      setState(() {
        _stream = FirebaseFirestore.instance
            .collection('orders')
            .where('status', isEqualTo: status)
            .orderBy('createdAt', descending: true)
            .snapshots();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TabBar(
          tabs: _tabMenus,
          controller: _tabController,
          isScrollable: true,
        ),
        Container(height: 1.0, color: Colors.grey),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildTabContent(),
              _buildTabContent(),
              _buildTabContent(),
              _buildTabContent(),
              _buildTabContent(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent() {
    return StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Loading());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text('You don\'t have any orders in this category.'));
          }

          _orders.clear();
          for (var element in snapshot.data!.docs) {
            if (element.data() != null) {
              OrderModel model = OrderModel.fromMap(
                  element.id, element.data() as Map<String, dynamic>);
              _orders.add(model);
            }
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.0),
            child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  return _buildItemCard(_orders[index]);
                }),
          );
        });
  }

  Widget _buildItemCard(OrderModel orderModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
      child: Card(
        elevation: 6.0,
        child: InkWell(
          onTap: () => SharedCode.navigatorPush(
              context, OrderDetail(orderModel: orderModel)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        orderModel.paymentMethod == 'bank'
                            ? 'BCA Transfer'
                            : 'COD',
                        style: GoogleFonts.poppins(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: SharedCode.getOrderStatusColor(
                                context, orderModel.status))),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(orderModel.shippingModel.name,
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    Text(orderModel.shippingModel.phone)
                  ],
                ),
                const SizedBox(height: 5.0),
                Text(orderModel.shippingModel.address),
                const SizedBox(height: 10.0),
                Text('${orderModel.products.length} products'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
