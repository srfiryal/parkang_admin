import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkang_admin/models/order_model.dart';
import 'package:parkang_admin/models/product_order_model.dart';
import 'package:parkang_admin/services/database_service.dart';
import 'package:parkang_admin/shared/custom_text_field.dart';
import 'package:parkang_admin/shared/loading.dart';
import 'package:parkang_admin/shared/shared_code.dart';
import 'package:parkang_admin/view/view_image.dart';

class OrderDetail extends StatefulWidget {
  final OrderModel orderModel;

  const OrderDetail({Key? key, required this.orderModel}) : super(key: key);

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  bool _isLoading = false;
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
        TextButton(child: const Text('Submit'), onPressed: () async {
          Navigator.pop(context);
          _setLoading(true);
          await DatabaseService().changeOrderShipmentReceipt(widget.orderModel.id, _receiptController.text);
          widget.orderModel.shipmentReceipt = _receiptController.text;
          _setLoading(false);
          Navigator.pop(context);
          Future.delayed(Duration.zero, () {
            SharedCode.showSnackBar(context, 'success', 'Shipment Receipt has been updated');
          });
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

  void _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('O R D E R   D E T A I L')),
      body: _isLoading ? const Loading() : SingleChildScrollView(
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
            _buildDivider(),
            widget.orderModel.paymentMethod == 'bank'
                ? _buildImage()
                : const SizedBox.shrink(),
            const SizedBox(height: 30.0),
            widget.orderModel.status == 'completed' || widget.orderModel.status == 'canceled' ? const SizedBox.shrink() : _buildButton()
          ],
        ),
      ),
    );
  }

  Widget _buildButton() {
    String status = widget.orderModel.status;
    String nextStatus = 'delivered';
    switch (status) {
      case 'unpaid':
        nextStatus = 'processed';
        break;
      case 'processed':
        nextStatus = 'delivered';
        break;
      case 'delivered':
        nextStatus = 'completed';
        break;
    }
    String tempNextStatus = '${nextStatus[0].toUpperCase()}${nextStatus.substring(1)}';
    return Column(
      children: [
        widget.orderModel.status == 'delivered' ? OutlinedButton(
            onPressed: () async {
              SharedCode.showConfirmationDialog(context, 'Confirmation', 'Are you sure you want to change this order\'s shipment receipt?', () async {
                _showReceiptDialog();
              });
            }, child: const Text('Change Shipment Receipt')) : const SizedBox.shrink(),

        (widget.orderModel.hasPay && widget.orderModel.paymentUrl.isNotEmpty) || widget.orderModel.paymentMethod == 'cod' ? OutlinedButton(
            onPressed: () async {
              SharedCode.showConfirmationDialog(context, 'Confirmation', 'Are you sure you want to change this order\'s status to $tempNextStatus?', () async {
                Navigator.pop(context);
                _setLoading(true);
                await DatabaseService().changeOrderStatus(widget.orderModel.id, nextStatus);
                _setLoading(false);
                Navigator.pop(context);
                Future.delayed(Duration.zero, () {
                  SharedCode.showSnackBar(context, 'success', 'Order\'s status has been changed to $tempNextStatus');
                });
              });
            }, child: Text('Change Status to $tempNextStatus')) : const SizedBox.shrink(),
        status == 'processed' && widget.orderModel.paymentMethod == 'bank'
            ? OutlinedButton(
            style: OutlinedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              SharedCode.showConfirmationDialog(context, 'Confirmation', 'Are you sure you want to deny this payment?', () async {
                Navigator.pop(context);
                _setLoading(true);
                await DatabaseService().denyPayment(widget.orderModel.id);
                _setLoading(false);
                Navigator.pop(context);
                Future.delayed(Duration.zero, () {
                  SharedCode.showSnackBar(context, 'success', 'Payment has been denied');
                });
              });
            },
            child: const Text('Deny Payment'))
            : const SizedBox.shrink(),
        OutlinedButton(
            style: OutlinedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              SharedCode.showConfirmationDialog(context, 'Confirmation', 'Are you sure you want to cancel this order?', () async {
                Navigator.pop(context);
                _setLoading(true);
                await DatabaseService().cancelOrder(widget.orderModel.id);
                _setLoading(false);
                Navigator.pop(context);
                Future.delayed(Duration.zero, () {
                  SharedCode.showSnackBar(context, 'success', 'Order has been canceled');
                });
              });
            },
            child: const Text('Cancel Order')),
      ],
    );
  }

  Widget _buildImage() {
    return widget.orderModel.hasPay ? InkWell(
        onTap: () => SharedCode.navigatorPush(
            context,
            ViewImage(
                imageUrl: widget.orderModel.paymentUrl,
                title: 'Payment Receipt')),
        child: Image.network(widget.orderModel.paymentUrl, height: 200)) : const Center(child: Text('User haven\'t uploaded their payment receipt.', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,));
  }

  Widget _buildOrderStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Text(widget.orderModel.id,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, color: Colors.black))),
        Text(widget.orderModel.paymentMethod == 'bank' ? 'BCA Transfer' : 'COD',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: SharedCode.getOrderStatusColor(
                    context, widget.orderModel.status))),
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
            Text(widget.orderModel.shippingModel.name,
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
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
          return _buildOrderItemLayout(widget.orderModel.products[index], index,
              widget.orderModel.products.length);
        });
  }

  Widget _buildOrderItemLayout(ProductOrderModel model, int index, int length) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: 8.0, bottom: index != (length - 1) ? 8.0 : 13.0),
          child: Row(
            children: [
              Image.network(model.product.imageUrl,
                  width: 70.0, height: 70.0, fit: BoxFit.cover),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(model.product.name),
                    Text('${model.quantity}x'),
                  ],
                ),
              ),
              Text(
                  SharedCode.rupiahFormat
                      .format(model.quantity * model.product.price),
                  style: GoogleFonts.poppins(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500)),
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
      _buildTextLabel('Shipment Method',
          widget.orderModel.paymentMethod == 'bank' ? 'BCA Transfer' : 'COD'),
      const SizedBox(height: 2.0),
      _buildTextLabel('Shipment Receipt', widget.orderModel.shipmentReceipt),
    ]);
  }

  Widget _buildPricing() {
    return Column(children: [
      _buildTextLabel('Payment Method',
          widget.orderModel.paymentMethod == 'bank' ? 'BCA Transfer' : 'COD'),
      const SizedBox(height: 10.0),
      _buildPricingLabel(
          'Shipping Fee', widget.orderModel.shipmentModel.price, false),
      const SizedBox(height: 2.0),
      _buildPricingLabel('Total Amount', widget.orderModel.totalPrice, true),
    ]);
  }

  Widget _buildPricingLabel(String label, int price, bool isTotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(SharedCode.rupiahFormat.format(price),
            style: GoogleFonts.poppins(
                fontWeight: isTotal ? FontWeight.w500 : FontWeight.normal,
                color: isTotal ? Theme.of(context).primaryColor : Colors.black,
                fontSize: isTotal ? 16.0 : 14.0)),
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
