import 'package:supabase_flutter/supabase_flutter.dart';

class OrderRepository {
  final supabase = Supabase.instance.client;

  String get userId => supabase.auth.currentUser!.id;

  Future<void> createOrder({
    required double total,
    required List<Map<String, dynamic>> items,
  }) async {
    final order = await supabase.from('orders').insert({
      'user_id': userId,
      'total': total,
    }).select().single();

    final orderId = order['id'];

    final orderItems = items.map((item) {
      return {
        'order_id': orderId,
        'product_id': item['product_id'],
        'quantity': item['quantity'],
      };
    }).toList();

    await supabase.from('order_items').insert(orderItems);
  }
}