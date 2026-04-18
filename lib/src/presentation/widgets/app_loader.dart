import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../core/constants/app_colors.dart';

class AppLoader {
  AppLoader._();

  /// 🔵 Circular Loader
  static Widget circular({
    Color? color,
    double? size,
    double strokeWidth = 3,
  }) {
    return Center(
      child: SizedBox(
        width: size ?? 30.w,
        height: size ?? 30.w,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          color: color ?? AppColors.primary,
        ),
      ),
    );
  }

  /// 🌊 Wave Loader (your custom one)
  static Widget wave({
    Color? color,
    double? size,
  }) {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: color ?? AppColors.primary,
        size: size ?? 40.w,
      ),
    );
  }

  /// 🔥 Dots Loader (extra)
  static Widget dots({
    Color? color,
    double? size,
  }) {
    return Center(
      child: LoadingAnimationWidget.dotsTriangle(
        color: color ?? AppColors.primary,
        size: size ?? 40.w,
      ),
    );
  }

  /// 🧊 Full Screen Loader (Overlay)
  static Widget overlay({
    Color? backgroundColor,
    Widget? child,
  }) {
    return Stack(
      children: [
        child ?? const SizedBox(),
        Positioned.fill(
          child: Container(
            color: backgroundColor ?? Colors.black.withOpacity(0.3),
            child: AppLoader.circular(),
          ),
        ),
      ],
    );
  }
}