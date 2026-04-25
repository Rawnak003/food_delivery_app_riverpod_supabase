import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/product_model.dart';
import '../../repositories/cart_repository.dart';
import '../states/cart_state.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepository();
});

final cartProvider = NotifierProvider<CartNotifier, CartState>(CartNotifier.new);

class CartNotifier extends Notifier<CartState> {
  late CartRepository repo;
  final sb = Supabase.instance.client;

  String get _userId => sb.auth.currentUser!.id;

  @override
  CartState build() {
    repo = ref.read(cartRepositoryProvider);
    Future.microtask(() => _loadCart());
    return CartState();
  }

  Future<void> _loadCart() async {
    final rawItems = await repo.getCart(_userId);

    final List<CartItem> items = [];

    try {
      for (final item in rawItems) {
        final food = await repo.getFoodById(item.productId);
        items.add(CartItem(
          cartId: item.id, // ✅ properly set
          food: food,
          quantity: item.quantity,
        ));
      }

      state = CartState(items: items);
    } catch (e) {
      print("\n\n\n$e\n\n\n");
      state = CartState();
    }
  }

  // =========================
  // ADD ITEM (optimistic)
  // =========================
  Future<void> addItem(FoodModel food, {int quantity = 1}) async {
    // 1. Check user
    print('\n\n\n=== ADD TO CART PRESSED ===');
    print('User ID: $_userId');
    print('Food ID: ${food.id}');
    print('Quantity: $quantity\n\n\n');

    final current = [...state.items];
    final index = current.indexWhere((e) => e.food.id == food.id);

    if (index != -1) {
      current[index] = current[index].copyWith(
        quantity: current[index].quantity + quantity,
      );
      state = CartState(items: current, deliveryFee: state.deliveryFee);
    } else {
      current.add(CartItem(cartId: -1, food: food, quantity: quantity));
      state = CartState(items: current, deliveryFee: state.deliveryFee);
    }

    print('\n\nOptimistic state updated. Items count: ${state.items.length}');

    try {
      for (int i = 0; i < quantity; i++) {
        await repo.addToCart(_userId, food.id);
      }
      print('\n\nSupabase insert SUCCESS\n\n');
      await _loadCart();
      print('\n\nCart reloaded. Items count: ${state.items.length}\n\n');
    } catch (e, stack) {
      print('\n\nERROR adding to cart: $e\n\n');
      print('\n\nSTACK: $stack\n\n');
      await _loadCart();
    }
  }

  // =========================
  // DECREASE ITEM
  // =========================
  Future<void> decreaseItem(FoodModel food) async {
    final current = [...state.items];
    final index = current.indexWhere((e) => e.food.id == food.id);

    if (index == -1) return;

    final item = current[index];

    // Optimistic update
    if (item.quantity == 1) {
      current.removeAt(index);
    } else {
      current[index] = item.copyWith(quantity: item.quantity - 1);
    }
    state = CartState(items: current, deliveryFee: state.deliveryFee);

    try {
      await repo.decrease(_userId, food.id);
    } catch (_) {
      await _loadCart(); // rollback
    }
  }

  // =========================
  // REMOVE ITEM
  // =========================
  Future<void> removeItem(int cartId) async {
    final current = state.items.where((e) => e.cartId != cartId).toList();
    state = CartState(items: current, deliveryFee: state.deliveryFee);

    try {
      await repo.removeItem(cartId); // ✅ passes the DB row id
    } catch (_) {
      await _loadCart(); // rollback
    }
  }
}