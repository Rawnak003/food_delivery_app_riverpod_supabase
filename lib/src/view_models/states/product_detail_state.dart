import 'package:food_delivery_supabase_riverpod/src/models/product_model.dart';

class ProductDetailState {
  final int quantity;
  final FoodModel? product;
  ProductDetailState({this.quantity = 1, this.product});

  ProductDetailState copyWith({int? quantity, FoodModel? product}) {
    return ProductDetailState(
      quantity: quantity ?? this.quantity,
      product: product ?? this.product,
    );
  }
}
