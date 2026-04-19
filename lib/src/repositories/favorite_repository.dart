import 'package:supabase_flutter/supabase_flutter.dart';

class FavoriteRepository {
  FavoriteRepository(this.sb);

  final SupabaseClient sb;

  String? get userId => sb.auth.currentUser?.id;

  Future<List<int>> getFavourites() async {
    if (userId == null) return [];

    final data = await sb
        .from('favourites')
        .select('product_id')
        .eq('user_id', userId!);

    return (data as List).map((e) => e['product_id'] as int).toList();
  }

  Future<void> add(int id) async {
    if (userId == null) return;

    await sb.from('favourites').insert({'user_id': userId, 'product_id': id});
  }

  Future<void> remove(int id) async {
    if (userId == null) return;

    await sb.from('favourites').delete().match({
      'user_id': userId!,
      'product_id': id,
    });
  }

  Stream<List<int>> watchFavourites() {
    if (userId == null) return const Stream.empty();

    return sb
        .from('favourites')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId!)
        .map((data) => data.map((e) => e['product_id'] as int).toList());
  }
}
