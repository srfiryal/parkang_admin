import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkang_admin/models/order_model.dart';
import 'package:parkang_admin/models/product_order_model.dart';
import 'package:parkang_admin/shared/custom_text_field.dart';
import 'package:parkang_admin/shared/shared_code.dart';

class OrderDetail extends StatefulWidget {
  final OrderModel orderModel;
  const OrderDetail({Key? key, required this.orderModel}) : super(key: key);

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  final TextEditingController _receiptController = TextEditingController();

  void _showReceiptDialog() {
    AlertDialog alert = AlertDialog(
      title: const Text('Shipment Receipt'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(label: 'Receipt ID', controller: _receiptController),
        ],
      ),
      actions: [
        TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(context).pop()),
        TextButton(child: const Text('Submit'), onPressed: () {
          Navigator.of(context).pop();
        }),
      ],

    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('O R D E R   D E T A I L')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderStatus(),
            _buildDivider(),
            _buildBuyerInfo(),
            _buildDivider(),
            _buildOrderItemList(),
            _buildShipmentInfo(),
            _buildDivider(),
            _buildPricing(),
            const SizedBox(height: 30.0),
            OutlinedButton(onPressed: () {}, child: const Text('Change to Next Status')),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.orderModel.paymentMethod == 'bank' ? 'BCA Transfer' : 'COD', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: SharedCode.getOrderStatusColor(context, widget. orderModel.status))),
      ],
    );
  }

  Widget _buildBuyerInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.orderModel.shippingModel.name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            Text(widget.orderModel.shippingModel.phone)
          ],
        ),
        const SizedBox(height: 8.0),
        Text(widget.orderModel.shippingModel.address),
      ],
    );
  }

  Widget _buildOrderItemList() {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: widget.orderModel.products.length,
        itemBuilder: (context, index) {
          return _buildOrderItemLayout(widget.orderModel.products[index], index, widget.orderModel.products.length);
        }
    );
  }
  
  Widget _buildOrderItemLayout(ProductOrderModel item, int index, int length) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: index != (length - 1) ? 8.0 : 13.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(item.product.imageUrl, width: 70.0, height: 70.0, fit: BoxFit.cover),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.product.name),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${item.quantity}x'),
                          Text(SharedCode.rupiahFormat.format(item.product.price)),
                        ]
                    ),
                    const SizedBox(height: 7.0),
                    Align(alignment: Alignment.centerRight, child: Text(SharedCode.rupiahFormat.format(item.product.price * item.quantity), style: GoogleFonts.poppins(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w500))),
                  ],
                ),
              ),
            ],
          ),
        ),
        index != (length - 1)
          ? const Divider(indent: 5.0, endIndent: 5.0)
          : const Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Divider(color: Colors.grey),
          )
      ],
    );
  }

  int _countTotalProduct() {
    List<int> prices = [];
    for (var element in widget.orderModel.products) {
      prices.add(element.product.price * element.quantity);
    }
    return prices.sum;
  }

  int _countTotalAndDelivery() {
    List<int> prices = [];
    for (var element in widget.orderModel.products) {
      prices.add(element.product.price * element.quantity);
    }
    return prices.sum + widget.orderModel.shipmentModel.price;
  }


  Widget _buildTextLabel(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value),
      ],
    );
  }

  Widget _buildShipmentInfo() {
    return Column(children: [
      _buildTextLabel('Shipment Method', widget.orderModel.paymentMethod == 'bank' ? 'BCA Transfer' : 'COD'),
      const SizedBox(height: 2.0),
      _buildTextLabel('Shipment Receipt', widget.orderModel.shipmentReceipt),
    ]);
  }

  Widget _buildPricing() {
    return Column(children: [
      _buildTextLabel('Payment Method', widget.orderModel.paymentMethod == 'bank' ? 'BCA Transfer' : 'COD'),
      const SizedBox(height: 10.0),
      _buildPricingLabel('Shipping Fee', widget.orderModel.shipmentModel.price, false),
      const SizedBox(height: 2.0),
      _buildPricingLabel('Total Amount', widget.orderModel.totalPrice, true),
    ]);
  }

  Widget _buildPricingLabel(String label, int price, bool isTotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(SharedCode.rupiahFormat.format(price), style: GoogleFonts.poppins(fontWeight: isTotal ? FontWeight.w500 : FontWeight.normal, color: isTotal ? Theme.of(context).primaryColor : Colors.black, fontSize: isTotal ? 16.0 : 14.0)),
      ],
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Divider(color: Colors.grey),
    );
  }
}
