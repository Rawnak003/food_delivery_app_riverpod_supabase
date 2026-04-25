class CartItemModel {
  final int id;
  final int productId;
  final int quantity;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      productId: json['product_id'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toMap(String userId) {
    return {
      'user_id': userId,
      'product_id': productId,
      'quantity': quantity,
    };
  }
}