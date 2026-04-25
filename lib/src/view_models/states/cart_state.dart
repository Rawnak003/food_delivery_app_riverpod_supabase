import '../../models/product_model.dart';

class CartState {
  final List<CartItem> items;
  final double deliveryFee;

  CartState({
    this.items = const [],
    this.deliveryFee = 2.0,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get total => subtotal + deliveryFee;
}

class CartItem {
  final int cartId;
  final FoodModel food;
  final int quantity;

  CartItem({
    required this.cartId,
    required this.food,
    required this.quantity,
  });

  double get total => food.price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      cartId: cartId,
      food: food,
      quantity: quantity ?? this.quantity,
    );
  }
}