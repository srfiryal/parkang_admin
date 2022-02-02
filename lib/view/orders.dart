import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkang_admin/models/order_item_model.dart';
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
    const Tab(text: 'In Progress'),
    const Tab(text: 'On Delivery'),
    const Tab(text: 'Completed'),
    const Tab(text: 'Canceled'),
  ];
  bool _isLoading = false;
  late List<OrderModel> _orders;
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(length: _tabMenus.length, vsync: this);
    _getPrefs();
  }

  Future<void> _getPrefs() async {
    _setLoading(true);

    List<OrderItemModel> _orderItems = [
      OrderItemModel('', 'Produk 1', 'https://brumano.b-cdn.net/wp-content/uploads/2018/12/Royal-Blue-Casual-Check-Shirt-1-min.jpg', 10000, 1, 10000),
      OrderItemModel('', 'Produk 2', 'https://brumano.b-cdn.net/wp-content/uploads/2018/12/Royal-Blue-Casual-Check-Shirt-1-min.jpg', 10000, 1, 10000),
      OrderItemModel('', 'Produk 3', 'https://brumano.b-cdn.net/wp-content/uploads/2018/12/Royal-Blue-Casual-Check-Shirt-1-min.jpg', 10000, 2, 20000)
    ];
    _orders = [
      OrderModel('#29012022-1', 'In Progress', 'Buyer', '08123456789', 'Jl. Satu No. 2, RT004 RW005, Kel. Enam, Kec. Tujuh, Kota Delapan', _orderItems, 40000, 10000, 50000, 'Cash', 'Delivery', '-'),
      OrderModel('#29012022-2', 'In Progress', 'Buyer', '08123456789', 'Jl. Satu No. 2, RT004 RW005, Kel. Enam, Kec. Tujuh, Kota Delapan', _orderItems, 40000, 10000, 50000, 'Bank Transfer',  'JNE', '12345678'),
      OrderModel('#29012022-3', 'In Progress', 'Buyer', '08123456789', 'Jl. Satu No. 2, RT004 RW005, Kel. Enam, Kec. Tujuh, Kota Delapan', _orderItems, 40000, 10000, 50000, 'Cash', 'JNT', '12345678'),
    ];

    _setLoading(false);
  }

  void _setLoading(bool loading) {
    if (mounted) {
      setState(() {
        _isLoading = loading;
      });
    } else {
      _isLoading = loading;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? const Loading() : Column(
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: _orders.length,
          itemBuilder: (context, index) {
            return _buildItemCard(_orders[index]);
          }
      ),
    );
  }

  Widget _buildItemCard(OrderModel orderModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
      child: Card(
        elevation: 6.0,
        child: InkWell(
          onTap: () => SharedCode.navigatorPush(context, OrderDetail(orderModel: orderModel)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(orderModel.status, style: GoogleFonts.poppins(fontSize: 12.0, fontWeight: FontWeight.bold, color: SharedCode.getOrderStatusColor(context, orderModel.status))),
                    Text(orderModel.id, style: GoogleFonts.poppins(fontSize: 12.0))
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(orderModel.buyersName, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    Text(orderModel.buyersPhone)
                  ],
                ),
                const SizedBox(height: 5.0),
                Text(orderModel.address),
                const SizedBox(height: 10.0),
                Text('${orderModel.items.length} items'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
