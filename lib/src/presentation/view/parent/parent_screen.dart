import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_supabase_riverpod/src/view_models/riverpods/parent_screen_provider.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/app_colors.dart';
import '../../../view_models/riverpods/cart_provider.dart';
import '../cart/cart_screen.dart';
import '../favourite/favourite_screen.dart';
import '../home/screens/home_screen.dart';
import '../profile/profile_screen.dart';

class ParentScreen extends ConsumerWidget {
  ParentScreen({super.key});

  final List<Widget> screens = [
    HomeScreen(),
    FavouriteScreen(),
    ProfileScreen(),
    CartScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final currentIndex = ref.watch(parentScreenProvider);

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            height: 90.h,
            decoration: BoxDecoration(color: Colors.white),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(Iconsax.home_15, "A", 0, ref),
                SizedBox(width: 10.w),
                _buildNavItem(Iconsax.heart, "B", 1, ref),
                SizedBox(width: 90.w),
                _buildNavItem(CupertinoIcons.person, "C", 2, ref),
                SizedBox(width: 10.w),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _buildNavItem(Iconsax.shopping_cart, "D", 3, ref),
                    Positioned(
                      top: 12,
                      right: -7,
                      child: GestureDetector(
                        onTap: () {
                          ref.read(parentScreenProvider.notifier).setPage(3);
                        },
                        child: CircleAvatar(
                          radius: 10.r,
                          backgroundColor: AppColors.redColor,
                          child: Text(
                            ref.watch(cartProvider).items.length.toString(),
                            style: TextStyle(fontSize: 12.sp, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 150,
                      top: -25,
                      child: CircleAvatar(
                        radius: 32.r,
                        backgroundColor: AppColors.redColor,
                        child: Icon(
                          CupertinoIcons.search,
                          size: 32.w,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, WidgetRef ref) {
    final currentIndex = ref.watch(parentScreenProvider);
    return InkWell(
      onTap: () {
        ref.read(parentScreenProvider.notifier).setPage(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24.w,
            color: currentIndex == index
                ? AppColors.redColor
                : Colors.grey.shade800,
          ),
          SizedBox(height: 2.h),
          CircleAvatar(
            radius: 3.r,
            backgroundColor: currentIndex == index
                ? AppColors.redColor
                : Colors.white,
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
