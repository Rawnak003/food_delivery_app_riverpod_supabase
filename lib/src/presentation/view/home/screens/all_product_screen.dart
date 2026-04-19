import 'package:flutter/material.dart';
import 'package:food_delivery_supabase_riverpod/src/core/constants/app_colors.dart';
import 'package:food_delivery_supabase_riverpod/src/models/product_model.dart';
import 'package:food_delivery_supabase_riverpod/src/presentation/view/home/widgets/custom_product_card.dart';
import 'package:food_delivery_supabase_riverpod/src/presentation/widgets/app_loader.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/theme/app_text_style.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({super.key});

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  final supabase = Supabase.instance.client;
  List<FoodModel> productList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFoodProducts();
  }

  Future<void> fetchFoodProducts() async {
    try {
      final response = await Supabase.instance.client
          .from('food_products')
          .select();
      final data = response as List;
      setState(() {
        productList = data.map((json) => FoodModel.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint("\n\nFetch Products Error: ${e.toString()}\n\n");
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextStyle.auto(context);
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
      body: isLoading
          ? AppLoader.wave(color: AppColors.primary)
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
