import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;

  const AppBackground({
    super.key,
    required this.child,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: AppColors.imageBackground1,
            child: Image.asset(
              "assets/food pattern.png",
              color: AppColors.imageBackground2,
              repeat: ImageRepeat.repeatY,
            ),
          ),
        ),

        SafeArea(
          child: Column(
            children: [
              ?appBar,
              Expanded(child: child),
            ],
          ),
        ),
      ],
    );
  }
}