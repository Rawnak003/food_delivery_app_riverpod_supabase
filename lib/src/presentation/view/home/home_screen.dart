import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_supabase_riverpod/src/core/constants/app_colors.dart';
import 'package:food_delivery_supabase_riverpod/src/core/theme/app_text_style.dart';
import 'package:food_delivery_supabase_riverpod/src/models/categories_model.dart';
import 'package:food_delivery_supabase_riverpod/src/models/product_model.dart';
import 'package:food_delivery_supabase_riverpod/src/presentation/view/home/widgets/home_app_bar.dart';
import 'package:food_delivery_supabase_riverpod/src/presentation/view/home/widgets/home_banner.dart';
import 'package:food_delivery_supabase_riverpod/src/presentation/widgets/app_loader.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'widgets/custom_product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<CategoryModel>> futureCategories = fetchCategories();
  late Future<List<FoodModel>> futureFoodProducts = Future.value([]);
  List<CategoryModel> categoriesList = [];
  List<FoodModel> productList = [];
  bool isLoading = true;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    try {
      final categories = await futureCategories;
      if (categories.isNotEmpty) {
        setState(() {
          categoriesList = categories;
          selectedCategory = categoriesList.first.name;

          futureFoodProducts = fetchFoodProducts(selectedCategory!);
        });
      }
    } catch (e) {
      debugPrint("\n\nInitialization Error: ${e.toString()}\n\n");
    }
  }

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await Supabase.instance.client
          .from('category_items')
          .select();
      return (response as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint("\n\nFetch Category Error: ${e.toString()}\n\n");
      return [];
    }
  }

  Future<List<FoodModel>> fetchFoodProducts(String category) async {
    try {
      final response = await Supabase.instance.client
          .from('food_products')
          .select()
          .eq('category', category);
      return (response as List)
          .map((json) => FoodModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint("\n\nFetch Products Error: ${e.toString()}\n\n");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextStyle.auto(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20.h,
              children: [
                HomeAppBar(textTheme: textTheme),
                HomeBanner(textTheme: textTheme),
                Text(
                  "Categories",
                  style: textTheme.titleLarge(fontWeight: FontWeight.bold),
                ),
                _buildCategoryList(textTheme),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Popular Now",
                      style: textTheme.titleLarge(fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 4.w,
                        children: [
                          Text(
                            "View all",
                            style: textTheme.titleSmall(
                              overrideColor: AppColors.orangeColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            height: 18.h,
                            width: 18.w,
                            decoration: BoxDecoration(
                              color: AppColors.orangeColor,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Icon(
                              Iconsax.arrow_right_3,
                              size: 12.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _buildProductList(textTheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList(AppTextStyle textTheme) {
    return FutureBuilder(
      future: futureCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: AppLoader.wave(color: AppColors.redColor));
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              "No Categories Found",
              style: textTheme.bodyMedium(fontWeight: FontWeight.w600),
            ),
          );
        }
        return SizedBox(
          height: 60.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount: categoriesList.length,
            itemBuilder: (context, index) {
              final category = categoriesList[index];
              return GestureDetector(
                onTap: () {
                  if (selectedCategory == category.name) return;
                  setState(() {
                    selectedCategory = category.name;
                    futureFoodProducts = fetchFoodProducts(selectedCategory!);
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: selectedCategory == category.name
                        ? AppColors.redColor
                        : AppColors.greyColor,
                    borderRadius: BorderRadius.circular(32.r),
                  ),
                  child: Row(
                    spacing: 8.w,
                    children: [
                      CircleAvatar(
                        radius: 20.r,
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Image.network(
                            category.image,
                            height: 20.h,
                            width: 20.w,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.fastfood, color: AppColors.redColor),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.redColor,
                                  strokeWidth: 2,
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Text(
                        category.name,
                        style: textTheme.bodyLarge(
                          overrideColor: selectedCategory == category.name
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(width: 10.w);
            },
          ),
        );
      },
    );
  }

  Widget _buildProductList(AppTextStyle textTheme) {
    return FutureBuilder<List<FoodModel>>(
      future: futureFoodProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: AppLoader.wave(color: AppColors.redColor));
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: textTheme.bodyMedium(fontWeight: FontWeight.w600),
            ),
          );
        }
        final foodProducts = snapshot.data ?? [];
        if (foodProducts.isEmpty) {
          return Center(
            child: Text(
              "No Products Found",
              style: textTheme.bodyMedium(fontWeight: FontWeight.w600),
            ),
          );
        }
        return SizedBox(
          height: 270.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: foodProducts.length,
            itemBuilder: (context, index) {
              final product = foodProducts[index];
              return CustomProductCard(product: product);
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(width: 10.w);
            },
          ),
        );
      },
    );
  }
}
