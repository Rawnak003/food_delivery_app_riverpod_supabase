import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_supabase_riverpod/src/view_models/states/all_provider_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/product_model.dart';

final allProductProvider =
    NotifierProvider<AllProductProvider, AllProviderState>(
      AllProductProvider.new,
    );

class AllProductProvider extends Notifier<AllProviderState> {

  final sb = Supabase.instance.client;

  @override
  AllProviderState build() {
    fetchFoodProducts();
    return AllProviderState();
  }

  Future<void> fetchFoodProducts() async {
    try {
      final response = await Supabase.instance.client
          .from('food_products')
          .select();
      final data = response as List;
      final allProducts = data.map((json) => FoodModel.fromJson(json)).toList();
      state = state.copyWith(
        products: allProducts,
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      debugPrint("\n\nFetch Products Error: ${e.toString()}\n\n");
    }
  }
}
