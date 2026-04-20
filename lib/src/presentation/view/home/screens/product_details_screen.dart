import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_supabase_riverpod/src/core/constants/app_colors.dart';
import 'package:food_delivery_supabase_riverpod/src/core/theme/app_text_style.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';
import '../../../../view_models/riverpods/product_detail_provider.dart';
import '../widgets/product_details_screen_app_bar.dart';

class ProductDetailsScreen extends ConsumerWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final textTheme = AppTextStyle.auto(context);

    final state = ref.watch(productDetailProvider);
    final notifier = ref.read(productDetailProvider.notifier);

    final product = state.product;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        elevation: 0,
        backgroundColor: Colors.transparent,
        label: MaterialButton(
          onPressed: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          color: AppColors.redColor,
          height: 52.h,
          minWidth: 220.w,
          child: Text(
            'Add to Cart',
            style: textTheme.bodyLarge(
              overrideColor: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Stack(
        alignment: AlignmentGeometry.bottomCenter,
        children: [
          Container(
            height: size.height,
            width: size.width,
            color: AppColors.imageBackground1,
            child: Image.asset(
              "assets/food pattern.png",
              color: AppColors.imageBackground2,
              repeat: ImageRepeat.repeatY,
            ),
          ),
          Container(
            height: size.height * 0.75,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r),
                topRight: Radius.circular(30.r),
              ),
            ),
          ),
          SizedBox(
            height: size.height,
            width: size.width,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 70.h),
                    Center(
                      child: Hero(
                        tag: product!.id,
                        child: Image.network(
                          product.imageDetail,
                          fit: BoxFit.fill,
                          height: 300.h,
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
                    SizedBox(height: 12.h),
                    Center(
                      child: Container(
                        height: 45.h,
                        width: 120.w,
                        decoration: BoxDecoration(
                          color: AppColors.redColor,
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          spacing: 8.w,
                          children: [
                            GestureDetector(
                              onTap: () {
                                notifier.decrement();
                              },
                              child: Icon(
                                Iconsax.minus,
                                size: 24.w,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              state.quantity.toString(),
                              style: textTheme.titleLarge(
                                overrideColor: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                notifier.increment();
                              },
                              child: Icon(
                                Iconsax.add,
                                size: 24.w,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: textTheme.titleLarge(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    product.specialItems,
                                    style: textTheme.titleSmall(
                                      overrideColor: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
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
                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildInfo(
                                textTheme,
                                iconPath: 'assets/icon/star.png',
                                text: product.rate.toString(),
                              ),
                              _buildInfo(
                                textTheme,
                                iconPath: 'assets/icon/fire.png',
                                text: "${product.kcal.toString()} kcal",
                              ),
                              _buildInfo(
                                textTheme,
                                iconPath: 'assets/icon/time.png',
                                text: product.time.toString(),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Description',
                              style: textTheme.titleMedium(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          ReadMoreText(
                            product.description,
                            textAlign: TextAlign.justify,
                            style: textTheme.titleSmall(
                              overrideColor: Colors.black87,
                              fontWeight: FontWeight.w400,
                            ),
                            trimLength: 120,
                            colorClickableText: AppColors.redColor,
                            trimExpandedText: 'Read Less',
                            trimCollapsedText: 'Read More',
                            moreStyle: textTheme.titleSmall(
                              overrideColor: AppColors.redColor,
                              fontWeight: FontWeight.w600,
                            ),
                            lessStyle: textTheme.titleSmall(
                              overrideColor: AppColors.redColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 100.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 54.h,
            left: 4.w,
            right: 4.w,
            child: ProductDetailsScreenAppBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(
    AppTextStyle textTheme, {
    required String iconPath,
    required String text,
  }) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4.w,
      children: [
        Image.asset(iconPath, height: 22.w, width: 22.w),
        Text(
          text,
          style: textTheme.titleMedium(
            overrideColor: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
