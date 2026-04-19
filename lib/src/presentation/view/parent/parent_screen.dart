import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/app_colors.dart';
import '../cart/cart_screen.dart';
import '../favourite/favourite_screen.dart';
import '../home/screens/home_screen.dart';
import '../profile/profile_screen.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({super.key});

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  int _currentIndex = 0;
  final List<Widget> screens = [
    HomeScreen(),
    FavouriteScreen(),
    ProfileScreen(),
    CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
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
                _buildNavItem(Iconsax.home_15, "A", 0),
                SizedBox(width: 10.w),
                _buildNavItem(Iconsax.heart, "B", 1),
                SizedBox(width: 90.w),
                _buildNavItem(CupertinoIcons.person, "C", 2),
                SizedBox(width: 10.w),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _buildNavItem(Iconsax.shopping_cart, "D", 3),
                    Positioned(
                      top: 12,
                      right: -7,
                      child: CircleAvatar(
                        radius: 10.r,
                        backgroundColor: AppColors.redColor,
                        child: Text(
                          "0",
                          style: TextStyle(fontSize: 12.sp, color: Colors.white),
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

  Widget _buildNavItem(IconData icon, String label, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24.w,
            color: _currentIndex == index
                ? AppColors.redColor
                : Colors.grey.shade800,
          ),
          SizedBox(height: 2.h),
          CircleAvatar(
            radius: 3.r,
            backgroundColor: _currentIndex == index
                ? AppColors.redColor
                : Colors.white,
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
