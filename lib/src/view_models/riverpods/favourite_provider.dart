import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../repositories/favorite_repository.dart';

final favouriteRepoProvider = Provider<FavoriteRepository>((ref) {
  final sb = Supabase.instance.client;
  return FavoriteRepository(sb);
});

final authStateProvider = StreamProvider((ref) {
  final sb = Supabase.instance.client;
  return sb.auth.onAuthStateChange;
});

final favouriteProvider = AsyncNotifierProvider<FavouriteNotifier, List<int>>(
  FavouriteNotifier.new,
);

class FavouriteNotifier extends AsyncNotifier<List<int>> {
  late final repo = ref.read(favouriteRepoProvider);

  @override
  Future<List<int>> build() async {
    ref.watch(authStateProvider);
    return await repo.getFavourites();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await repo.getFavourites());
  }

  Future<bool> toggle(int id) async {
    final current = state.value ?? [];
    final isFav = current.contains(id);

    try {
      if (isFav) {
        await repo.remove(id);
      } else {
        await repo.add(id);
      }
      await refresh();
      return !isFav;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return isFav;
    }
  }

  bool isFavourite(int id) {
    final current = state.value ?? [];
    return current.contains(id);
  }
}
