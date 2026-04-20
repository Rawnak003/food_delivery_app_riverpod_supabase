
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_supabase_riverpod/src/core/theme/app_text_style.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/route/route_name.dart';
import '../../../../models/product_model.dart';
import '../../../../view_models/riverpods/product_detail_provider.dart';

class CustomProductCard extends ConsumerWidget {
  const CustomProductCard({
    super.key,
    required this.product,
  });

  final FoodModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = AppTextStyle.auto(context);
    return GestureDetector(
      onTap: () {
        ref.read(productDetailProvider.notifier).setProduct(product);
        if (ref.watch(productDetailProvider).product == null) {
          return;
        }
        Navigator.pushNamed(
          context,
          RouteNames.productDetailsScreen,
        );
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
                          loadingBuilder:
                              (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColors.redColor,
                                strokeWidth: 2,
                                value:
                                loadingProgress
                                    .expectedTotalBytes !=
                                    null
                                    ? loadingProgress
                                    .cumulativeBytesLoaded /
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
                  ),
                  Text(
                    product.name,
                    style: textTheme.titleLarge(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                    ),
                  ),
                  Text(
                    product.specialItems,
                    style: textTheme.bodyLarge(),
                  ),
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
                onTap: (){},
                child: CircleAvatar(
                  radius: 15.r,
                  backgroundColor: Colors.red.shade50,
                  child: Image.asset(
                    "assets/icon/fire.png",
                    height: 20.w,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}