import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_supabase_riverpod/src/presentation/view/home/widgets/custom_product_card.dart';
import 'package:food_delivery_supabase_riverpod/src/view_models/riverpods/all_product_provider.dart';
import 'package:food_delivery_supabase_riverpod/src/view_models/riverpods/parent_screen_provider.dart';

import '../../../core/theme/app_text_style.dart';
import '../../../view_models/riverpods/favourite_provider.dart';

class FavouriteScreen extends ConsumerWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = AppTextStyle.auto(context);

    final favState = ref.watch(favouriteProvider);

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => ref.read(parentScreenProvider.notifier).setPage(0),
        ),
        title: Text(
          'Favorites',
          style: textTheme.titleLarge(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: favState.when(

        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(
          child: Text(
            "Something went wrong",
            style: textTheme.bodyMedium(fontWeight: FontWeight.w600),
          ),
        ),

        data: (favIds) {
          if (favIds.isEmpty) {
            return Center(
              child: Text(
                "No Favorite Products Found",
                style: textTheme.bodyMedium(fontWeight: FontWeight.w600),
              ),
            );
          }

          final productList = ref.watch(allProductProvider).products;

          final favProducts = productList
              .where((p) => favIds.contains(p.id))
              .toList();

          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
            child: GridView.builder(
              itemCount: favProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .64,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final fav = favProducts[index];
                return CustomProductCard(product: fav);
              },
            ),
          );
        },
      ),
    );
  }
}