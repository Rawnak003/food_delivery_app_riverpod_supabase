import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_supabase_riverpod/src/view_models/states/home_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/categories_model.dart';
import '../../models/product_model.dart';

final homeProvider = NotifierProvider<HomeProvider, HomeState>(
  HomeProvider.new,
);

class HomeProvider extends Notifier<HomeState> {
  @override
  HomeState build() {
    init();
    return const HomeState();
  }

  final sb = Supabase.instance.client;

  Future<void> init() async {
    try {
      final categories = await fetchCategories();
      if (categories.isNotEmpty) {
        state = state.copyWith(
          categories: categories,
          selectedCategory: categories.first.name,
          isLoading: false,
          errorMessage: null,
        );

        await fetchFoodProducts(categories.first.name);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      debugPrint("\n\nHome Screen Init Error: ${e.toString()}\n\n");
    }
  }

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await sb.from('category_items').select();
      return (response as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      debugPrint("\n\nFetch Category Error: ${e.toString()}\n\n");
      return [];
    }
  }

  Future<void> fetchFoodProducts(String category) async {
    state = state.copyWith(isProductLoading: true);
    try {
      final response = await sb
          .from('food_products')
          .select()
          .eq('category', category);
      final products = (response as List)
          .map((json) => FoodModel.fromJson(json))
          .toList();

      state = state.copyWith(products: products, isProductLoading: false, errorMessage: null);
    } catch (e) {
      debugPrint("\n\nFetch Products Error: ${e.toString()}\n\n");
      state = state.copyWith(
        isProductLoading: false,
        errorMessage: e.toString(),
      );
      return;
    }
  }

  Future<void> setSelectedCategory(String category) async {
    if (state.selectedCategory == category) return;
    state = state.copyWith(selectedCategory: category);
    await fetchFoodProducts(category);
  }
}
