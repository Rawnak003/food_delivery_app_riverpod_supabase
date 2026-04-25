import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/product_model.dart';
import '../../repositories/cart_repository.dart';
import '../states/cart_state.dart';
import 'auth_state_provider.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepository();
});

final cartProvider = NotifierProvider<CartNotifier, CartState>(CartNotifier.new);

class CartNotifier extends Notifier<CartState> {
  late CartRepository repo;
  final sb = Supabase.instance.client;
  String get _userId => sb.auth.currentUser!.id;

  final Map<int, Timer> _debounceTimers = {};
  bool _isSyncing = false;

  @override
  CartState build() {
    repo = ref.read(cartRepositoryProvider);

    ref.listen(authStateProvider, (previous, next) {
      final user = next.value?.session?.user;
      if (user != null) {
        _loadCart();
      } else {
        state = CartState();
      }
    });

    return CartState();
  }

  Future<void> _loadCart() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final rawItems = await repo.getCart(_userId);
      final List<CartItem> items = [];

      for (final item in rawItems) {
        final food = await repo.getFoodById(item.productId);
        items.add(CartItem(
          cartId: item.id,
          food: food,
          quantity: item.quantity,
        ));
      }

      state = CartState(items: items, deliveryFee: state.deliveryFee);
    } catch (e) {
      print('Load cart error: $e');
    } finally {
      _isSyncing = false;
    }
  }

  void _scheduleQuantitySync(int foodId) {
    _debounceTimers[foodId]?.cancel();
    _debounceTimers[foodId] = Timer(const Duration(milliseconds: 600), () async {
      final item = state.items.firstWhere(
            (e) => e.food.id == foodId,
        orElse: () => CartItem(cartId: -1, food: _dummyFood(), quantity: 0),
      );

      try {
        if (item.quantity <= 0) {
          return;
        }
        await repo.setQuantity(_userId, foodId, item.quantity);
      } catch (e) {
        print('Sync error: $e');
        await _loadCart();
      }
    });
  }

  FoodModel _dummyFood() => FoodModel(
    id: -1, name: '', price: 0, rate: 0, specialItems: '',
    category: '', kcal: 0, time: '', description: '',
    imageCard: '', imageDetail: '',
  );

  // =========================
  // ADD ITEM
  // =========================
  Future<void> addItem(FoodModel food, {int quantity = 1}) async {
    final current = [...state.items];
    final index = current.indexWhere((e) => e.food.id == food.id);

    if (index != -1) {
      current[index] = current[index].copyWith(
        quantity: current[index].quantity + quantity,
      );
    } else {
      current.add(CartItem(cartId: -1, food: food, quantity: quantity));
      state = CartState(items: current, deliveryFee: state.deliveryFee);

      try {
        await repo.addToCart(_userId, food.id, quantity);
        await _loadCart();
      } catch (e) {
        print('Add new item error: $e');
        await _loadCart();
      }
      return;
    }

    state = CartState(items: current, deliveryFee: state.deliveryFee);

    _scheduleQuantitySync(food.id);
  }

  // =========================
  // DECREASE ITEM
  // =========================
  Future<void> decreaseItem(FoodModel food) async {
    final current = [...state.items];
    final index = current.indexWhere((e) => e.food.id == food.id);
    if (index == -1) return;

    final item = current[index];

    if (item.quantity == 1) {
      await removeItem(item.cartId);
      return;
    }

    current[index] = item.copyWith(quantity: item.quantity - 1);
    state = CartState(items: current, deliveryFee: state.deliveryFee);

    _scheduleQuantitySync(food.id);
  }

  // =========================
  // REMOVE ITEM
  // =========================
  Future<void> removeItem(int cartId) async {
    final foodId = state.items
        .firstWhere((e) => e.cartId == cartId,
        orElse: () => CartItem(cartId: -1, food: _dummyFood(), quantity: 0))
        .food.id;
    _debounceTimers[foodId]?.cancel();

    final current = state.items.where((e) => e.cartId != cartId).toList();
    state = CartState(items: current, deliveryFee: state.deliveryFee);

    try {
      await repo.removeItem(cartId);
    } catch (e) {
      print('Remove error: $e');
      await _loadCart();
    }
  }
}