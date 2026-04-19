import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/action_button.dart';

class ProductDetailsScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProductDetailsScreenAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 12.w,),
        ActionButton(icon: Icons.arrow_back_ios_new, isIcon: true, onTap: () => Navigator.pop(context)),
        Spacer(),
        ActionButton(icon: Icons.more_horiz_outlined, isIcon: true,),
        SizedBox(width: 12.w,),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}
