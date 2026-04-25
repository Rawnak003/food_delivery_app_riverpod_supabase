import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_supabase_riverpod/src/core/constants/app_colors.dart';
import 'package:food_delivery_supabase_riverpod/src/core/theme/app_text_style.dart';
import 'package:food_delivery_supabase_riverpod/src/presentation/view/home/widgets/home_app_bar.dart';
import 'package:food_delivery_supabase_riverpod/src/presentation/view/home/widgets/home_banner.dart';
import 'package:food_delivery_supabase_riverpod/src/presentation/widgets/app_loader.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/route/route_name.dart';
import '../../../../view_models/riverpods/home_provider.dart';
import '../../../../view_models/states/home_state.dart';
import '../widgets/custom_product_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = AppTextStyle.auto(context);

    final state = ref.watch(homeProvider);
    final notifier = ref.read(homeProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                _buildCategoryList(textTheme, state, notifier),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Popular Now",
                      style: textTheme.titleLarge(fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.allProductScreen);
                      },
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
                _buildProductList(textTheme, state, notifier),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList(AppTextStyle textTheme, HomeState state, HomeProvider notifier) {

    if (state.isLoading) {
      return Center(child: AppLoader.wave(color: AppColors.redColor));
    }

    if (state.categories.isEmpty) {
      return Center(
        child: Text(
          "No Categories Found",
          style: textTheme.bodyMedium(fontWeight: FontWeight.w600),
        ),
      );
    }

    final categoriesList = state.categories;
    final selectedCategory = state.selectedCategory;

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
              notifier.setSelectedCategory(category.name);
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
  }

  Widget _buildProductList(AppTextStyle textTheme, HomeState state, HomeProvider notifier) {

    if (state.isProductLoading) {
      return Center(child: AppLoader.wave(color: AppColors.redColor));
    }

    if (state.errorMessage != null) {
      return Center(
        child: Text(
          "Error: ${state.errorMessage}",
          style: textTheme.bodyMedium(fontWeight: FontWeight.w600),
        ),
      );
    }

    if (state.products.isEmpty) {
      return Center(
        child: Text(
          "No Products Found",
          style: textTheme.bodyMedium(fontWeight: FontWeight.w600),
        ),
      );
    }

    final foodProducts = state.products;

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
  }
}
