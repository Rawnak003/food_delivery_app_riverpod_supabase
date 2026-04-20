import 'package:food_delivery_supabase_riverpod/src/models/categories_model.dart';
import 'package:food_delivery_supabase_riverpod/src/models/product_model.dart';

class HomeState {
  final bool isLoading;
  final bool isProductLoading;
  final String? selectedCategory;
  final String? errorMessage;
  final List<FoodModel> products;
  final List<CategoryModel> categories;

  const HomeState({
    this.isLoading = true,
    this.isProductLoading = false,
    this.selectedCategory,
    this.errorMessage,
    this.products = const [],
    this.categories = const [],
  });

  HomeState copyWith({
    bool? isLoading,
    bool? isProductLoading,
    String? selectedCategory,
    String? errorMessage,
    List<FoodModel>? products,
    List<CategoryModel>? categories,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      isProductLoading: isProductLoading ?? this.isProductLoading,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      errorMessage: errorMessage ?? this.errorMessage,
      products: products ?? this.products,
      categories: categories ?? this.categories,
    );
  }
}
