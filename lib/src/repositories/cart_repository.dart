import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartRepository {
  final _client = Supabase.instance.client;

  Future<List<CartItemModel>> getCart(String userId) async {
    final res = await _client.from('cart').select().eq('user_id', userId);
    return (res as List).map((e) => CartItemModel.fromJson(e)).toList();
  }

  Future<FoodModel> getFoodById(int id) async {
    final res = await _client
        .from('food_products')
        .select()
        .eq('id', id)
        .single();
    return FoodModel.fromJson(res);
  }

  // ✅ Add or increase by 1
  Future<void> addToCart(String userId, int foodId) async {
    print('\n\nRepository addToCart called. userId: $userId, foodId: $foodId\n\n');

    try {
      final existing = await _client
          .from('cart')
          .select('id, quantity')
          .eq('user_id', userId)
          .eq('product_id', foodId)
          .maybeSingle();

      print('\n\nExisting row: $existing\n\n');

      if (existing != null) {
        await _client.from('cart').update({
          'quantity': (existing['quantity'] as int) + 1,
        }).eq('id', existing['id']);
        print('\n\nUpdated existing row\n\n');
      } else {
        await _client.from('cart').insert({
          'user_id': userId,
          'product_id': foodId,
          'quantity': 1,
          'created_at': DateTime.now().toIso8601String(),
        });
        print('\n\nInserted new row\n\n');
      }
    } catch (e) {
      print('\n\nRepository ERROR: $e\n\n');
      rethrow; // ← important! lets the notifier catch it too
    }
  }

  Future<void> decrease(String userId, int foodId) async {
    final existing = await _client
        .from('cart')
        .select()
        .eq('user_id', userId)
        .eq('product_id', foodId)
        .maybeSingle();

    if (existing == null) return;

    if (existing['quantity'] <= 1) {
      await _client.from('cart').delete().eq('id', existing['id']);
    } else {
      await _client.from('cart').update({
        'quantity': existing['quantity'] - 1,
      }).eq('id', existing['id']);
    }
  }

  Future<void> removeItem(int id) async {
    await _client.from('cart').delete().eq('id', id);
  }
}