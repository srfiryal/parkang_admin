import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkang_admin/models/product_order_model.dart';
import 'package:parkang_admin/models/shipment_model.dart';
import 'package:parkang_admin/models/shipping_model.dart';

class OrderModel {
  final String id, uid, additionalComments, paymentMethod, status, shipmentReceipt, paymentUrl;
  final bool hasPay;
  final int totalPrice;
  final ShippingModel shippingModel;
  final ShipmentModel shipmentModel;
  final List<ProductOrderModel> products;

  OrderModel({
    this.id = '0',
    this.shipmentReceipt = '-',
    this.paymentUrl = '-',
    required this.additionalComments,
    required this.uid,
    required this.paymentMethod,
    required this.status,
    required this.hasPay,
    required this.totalPrice,
    required this.shippingModel,
    required this.shipmentModel,
    required this.products,
  });

  factory OrderModel.fromMap(String id, Map<dynamic, dynamic> json) {
    ShippingModel shippingModel = ShippingModel.fromMap('', json['shippingModel'] as Map<String, dynamic>);
    ShipmentModel shipmentModel = ShipmentModel.fromMap('', json['shipmentModel'] as Map<String, dynamic>);
    List<dynamic> listJson = json['products'];
    List<ProductOrderModel> products = listJson.map((item) {
      return ProductOrderModel.fromMap('', item);
    }).toList();

    return OrderModel(
        additionalComments: json['additionalComments'] as String,
        paymentMethod: json['paymentMethod'] as String,
        paymentUrl: json['paymentUrl'] as String,
        uid: json['uid'] as String,
        status: json['status'] as String,
        shipmentReceipt: json['shipmentReceipt'] as String,
        hasPay: json['hasPay'] as bool,
        totalPrice: json['totalPrice'] as int,
        shippingModel: shippingModel,
        shipmentModel: shipmentModel,
        products: products
    );
  }

  Map<String, Object?> toJson() {
    List<dynamic> productList = [];
    productList = products.map((product) {
      return product.toJsonOrder();
    }).toList();

    return {
      'additionalComments': additionalComments.isEmpty ? '-' : additionalComments,
      'paymentMethod': paymentMethod,
      'status': status,
      'uid': uid,
      'hasPay': hasPay,
      'paymentUrl': paymentUrl,
      'shipmentReceipt': shipmentReceipt,
      'totalPrice': totalPrice,
      'shippingModel': shippingModel.toJson(),
      'shipmentModel': shipmentModel.toJson(),
      'products': productList,
      'createdAt': FieldValue.serverTimestamp()
    };
  }
}
