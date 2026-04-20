import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_supabase_riverpod/src/core/constants/app_colors.dart';
import 'package:food_delivery_supabase_riverpod/src/presentation/view/home/widgets/custom_product_card.dart';
import 'package:food_delivery_supabase_riverpod/src/presentation/widgets/app_loader.dart';

import '../../../../core/theme/app_text_style.dart';
import '../../../../view_models/riverpods/all_product_provider.dart';

class AllProductScreen extends ConsumerWidget {
  const AllProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = AppTextStyle.auto(context);

    final state = ref.watch(allProductProvider);
    final productList = state.products;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'All Products',
          style: textTheme.titleLarge(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: state.isLoading
          ? AppLoader.wave(color: AppColors.primary)
          : state.errorMessage != null
          ? Center(
              child: Text(
                "Error: ${state.errorMessage}",
                style: textTheme.bodyMedium(fontWeight: FontWeight.w600),
              ),
            )
          : Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
              child: GridView.builder(
                itemCount: productList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: .64,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final product = productList[index];
                  return CustomProductCard(product: product);
                },
              ),
            ),
    );
  }
}
