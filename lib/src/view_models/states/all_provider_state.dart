import '../../models/product_model.dart';

class AllProviderState {
  final List<FoodModel> products;
  final bool isLoading;
  final String? errorMessage;

  AllProviderState({
    this.products = const [],
    this.isLoading = true,
    this.errorMessage,
  });

  AllProviderState copyWith({
    bool? isLoading,
    List<FoodModel>? products,
    String? errorMessage,
  }) {
    return AllProviderState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
