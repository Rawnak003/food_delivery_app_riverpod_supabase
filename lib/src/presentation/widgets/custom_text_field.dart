import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/theme/app_text_style.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    this.prefixIconPath,
    this.suffixIconPath,
    required this.controller,
    this.isObscure,
    this.suffixIconOnTap,
    required this.action,
    this.validator,
    this.onChanged, this.keyboardType,
  });

  final String label;
  final String? prefixIconPath;
  final String? suffixIconPath;
  final TextEditingController controller;
  final bool? isObscure;
  final TextInputType? keyboardType;
  final VoidCallback? suffixIconOnTap;
  final TextInputAction action;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextStyle.auto(context);
    return TextFormField(
      controller: controller,
      obscureText: isObscure ?? false,
      textInputAction: action,
      keyboardType: keyboardType,
      style: textTheme.bodyLarge().copyWith(
        fontSize: (isObscure ?? false) ? 16.sp : 14.sp,
        letterSpacing: (isObscure ?? false) ? 4.0 : 0.0,
        height: 1.2, // 🔥 controls vertical spacing
      ),
      obscuringCharacter: '●',
      cursorHeight: 24.sp,
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.white, width: 2.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: AppColors.primaryDark.withValues(alpha: 1),
            width: 2.w,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.black54, width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 1),
            width: 2.w,
          ),
        ),
        label: Text(label),
        labelStyle: textTheme.bodyLarge(),
        prefixIcon: prefixIconPath != null
            ? Padding(
          padding: EdgeInsets.only(left: 16.w, right: 8.w),
          child: SvgPicture.asset(
            prefixIconPath!,
            height: 16.h,
            width: 16.w,
          ),
        )
            : const SizedBox(),
        prefixIconConstraints: BoxConstraints(minWidth: 16.w, minHeight: 16.w),
        suffixIcon: suffixIconPath != null
            ? GestureDetector(
          onTap: suffixIconOnTap,
          child: Padding(
            padding: EdgeInsets.only(right: 16.w, left: 8.w),
            child: SvgPicture.asset(
              suffixIconPath!,
              height: 16.h,
              width: 16.w,
            ),
          ),
        )
            : const SizedBox(),
        suffixIconConstraints: BoxConstraints(minWidth: 16.w, minHeight: 16.w),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
      ),
      onChanged: onChanged,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}