import 'package:parkang_admin/models/order_item_model.dart';

class OrderModel {
  final String id;
  final String status;
  final String buyersName;
  final String buyersPhone;
  final String address;
  final List<OrderItemModel> items;
  final int orderSummary;
  final int shippingFee;
  final int totalPrice;
  final String paymentMethod;
  final String shipmentMethod;
  final String shipmentReceipt;

  OrderModel(
      this.id,
      this.status,
      this.buyersName,
      this.buyersPhone,
      this.address,
      this.items,
      this.orderSummary,
      this.shippingFee,
      this.totalPrice,
      this.paymentMethod,
      this.shipmentMethod,
      this.shipmentReceipt);
}
