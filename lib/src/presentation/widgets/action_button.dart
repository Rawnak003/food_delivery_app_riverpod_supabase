import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_colors.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key, this.icon, this.bgColor, this.onTap, required this.isIcon, this.image,
  });

  final bool isIcon;
  final IconData? icon;
  final String? image;
  final Color? bgColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45.w,
        width: 45.w,
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: bgColor ?? AppColors.greyColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: isIcon ? Icon(icon) : Image.asset(image ?? "",),
      ),
    );
  }
}