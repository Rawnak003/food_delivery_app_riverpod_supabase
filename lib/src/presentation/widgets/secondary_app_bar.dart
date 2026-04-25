import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_text_style.dart';
import 'action_button.dart';

class SecondaryAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SecondaryAppBar({
    super.key,
    required this.hasMore,
    required this.title,
    this.onTapBack,
    this.onTapMore,
  });

  final bool hasMore;
  final String title;
  final VoidCallback? onTapBack;
  final VoidCallback? onTapMore;

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextStyle.auto(context);
    return Row(
      children: [
        SizedBox(width: 12.w),
        ActionButton(
          icon: Icons.arrow_back_ios_new,
          isIcon: true,
          onTap: () {
            if (onTapBack != null) {
              onTapBack!();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        Spacer(),
        Text(
          title,
          style: textTheme.titleLarge(fontWeight: FontWeight.bold),
        ),
        Spacer(),
        hasMore
            ? ActionButton(icon: Icons.more_horiz_outlined, isIcon: true)
            : SizedBox(height: 45.w, width: 45.w),
        SizedBox(width: 12.w),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}
