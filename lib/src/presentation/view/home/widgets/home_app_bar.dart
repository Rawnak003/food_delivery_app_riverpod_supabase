import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/route/route_name.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../widgets/action_button.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key, required this.textTheme});

  final AppTextStyle textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ActionButton(icon: "assets/icon/dash.png"),
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4.w,
          children: [
            Icon(Iconsax.location, size: 20.w, color: AppColors.redColor),
            Text(
              "Bangladesh",
              style: textTheme.titleLarge(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(
              Iconsax.arrow_down_1,
              size: 16.w,
              color: AppColors.orangeColor,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        ActionButton(
          icon: "assets/profile.png",
          onTap: () {
            final supabase = Supabase.instance.client;
            supabase.auth.signOut();
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteNames.loginScreen,
              (predicate) => false,
            );
          },
        ),
      ],
    );
  }
}
