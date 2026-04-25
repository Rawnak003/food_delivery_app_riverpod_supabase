import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_supabase_riverpod/src/core/theme/app_text_style.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/route/route_name.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../models/product_model.dart';
import '../../../../view_models/riverpods/favourite_provider.dart';
import '../../../../view_models/riverpods/product_detail_provider.dart';

class CustomProductCard extends ConsumerWidget {
  const CustomProductCard({super.key, required this.product});

  final FoodModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = AppTextStyle.auto(context);
    final favState = ref.watch(favouriteProvider);

    final isFav = favState.maybeWhen(
      data: (ids) => ids.contains(product.id),
      orElse: () => false,
    );
    return GestureDetector(
      onTap: () {
        ref.read(productDetailProvider.notifier).setProduct(product);
        if (ref.watch(productDetailProvider).product == null) {
          return;
        }
        precacheImage(NetworkImage(product.imageDetail), context);
        Navigator.pushNamed(context, RouteNames.productDetailsScreen);
      },
      child: Card(
        elevation: 5,
        child: Stack(
          children: [
            Container(
              width: 200.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 4.h,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.w),
                    child: SizedBox(
                      height: 150.h,
                      child: Hero(
                        tag: product.id,
                        child: Image.network(
                          product.imageCard,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.fastfood, color: Colors.black54),
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
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Text(
                    product.name,
                    style: textTheme.titleLarge(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                    ),
                  ),
                  Text(product.specialItems, style: textTheme.bodyLarge()),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '\$ ',
                          style: textTheme.bodySmall(
                            fontWeight: FontWeight.bold,
                            overrideColor: AppColors.redColor,
                          ),
                        ),
                        TextSpan(
                          text: product.price.toString(),
                          style: textTheme.titleLarge(
                            fontWeight: FontWeight.bold,
                            overrideColor: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 8.w,
              top: 8.w,
              child: GestureDetector(
                onTap: () async {
                  final notifier = ref.read(favouriteProvider.notifier);

                  final isAdded = await notifier.toggle(product.id);

                  if (isAdded) {
                    AppToast.showToast("Added to favorites");
                  } else {
                    AppToast.showToast("Removed from favorites");
                  }
                },
                child: AnimatedContainer(
                  height: 30.w,
                  width: 30.w,
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFav ? Colors.red.shade100 : Colors.white,
                  ),
                  padding: EdgeInsets.all(5),
                  child: Image.asset("assets/icon/fire.png", height: 20.w),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
