import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onTap,
    required this.buttonTitle,
    this.buttonColor,
    this.iconPath,
    this.titleColor,
    this.isRounded,
    this.isOutlined, this.borderColor,
  });

  final VoidCallback onTap;
  final String buttonTitle;
  final Color? buttonColor;
  final Color? borderColor;
  final String? iconPath;
  final Color? titleColor;
  final bool? isRounded;
  final bool? isOutlined;

  @override
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.width > 600;

    double buttonHeight = isTablet ? 36.w : 48.w;
    double iconSize = isTablet ? 32.w : 24.w;
    double fontSize = isTablet ? 16.sp : 16.sp;
    double borderRadius = isTablet
        ? (isRounded ?? false ? 45.r : 12.r)
        : (isRounded ?? false ? 45.r : 12.r);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: buttonHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isOutlined ?? false ? AppColors.background : buttonColor ?? AppColors.primary,
          border: Border.all(color: borderColor ?? buttonColor ?? AppColors.primary, width: 1.w),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (iconPath != null)
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: SvgPicture.asset(
                  iconPath!,
                  height: iconSize,
                  width: iconSize,
                  // ignore: deprecated_member_use
                  color: titleColor ?? Colors.white,
                ),
              ),
            Text(
              buttonTitle,
              style: TextStyle(
                fontSize: fontSize,
                color: titleColor ?? Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}