class OrderItemModel {
  final String productId;
  final String productName;
  final String productImageUrl;
  final int pricePerItem;
  final int amount;
  final int totalPrice;

  OrderItemModel(this.productId, this.productName, this.productImageUrl,
      this.pricePerItem, this.amount, this.totalPrice);
}