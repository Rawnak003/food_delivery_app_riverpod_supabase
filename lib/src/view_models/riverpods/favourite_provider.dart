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
    ref.listen(authStateProvider, (_, __) {
      ref.invalidateSelf();
    });

    final data = await repo.getFavourites();

    _listenRealtime();

    return data;
  }

  void _listenRealtime() {
    final stream = repo.watchFavourites();

    stream.listen((data) {
      state = AsyncData(data);
    });
  }

  Future<void> toggle(int id) async {
    final current = state.value ?? [];

    final isFav = current.contains(id);

    if (isFav) {
      state = AsyncData(current.where((e) => e != id).toList());
      await repo.remove(id);
    } else {
      state = AsyncData([...current, id]);
      await repo.add(id);
    }
  }

  bool isFavourite(int id) {
    return state.value?.contains(id) ?? false;
  }
}
