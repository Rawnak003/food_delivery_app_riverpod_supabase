import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_supabase_riverpod/src/view_models/states/product_detail_state.dart';

import '../../models/product_model.dart';

final productDetailProvider =
    NotifierProvider<ProductDetailProvider, ProductDetailState>(
      ProductDetailProvider.new,
    );

class ProductDetailProvider extends Notifier<ProductDetailState> {
  @override
  ProductDetailState build() {
    return ProductDetailState();
  }

  void increment() {
    state = state.copyWith(quantity: state.quantity + 1);
  }

  void decrement() {
    state = state.copyWith(
      quantity: state.quantity > 1 ? state.quantity - 1 : 1,
    );
  }

  void setProduct(FoodModel product) {
    state = state.copyWith(product: product);
  }
}
