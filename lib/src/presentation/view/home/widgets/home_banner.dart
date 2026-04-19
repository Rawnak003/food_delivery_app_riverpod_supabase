
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../widgets/primary_button.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({
    super.key,
    required this.textTheme,
  });

  final AppTextStyle textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.imageBackground1,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Image.asset(
              "assets/food pattern.png",
              color: AppColors.imageBackground2,
              height: 170.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(width: 16.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150.w,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'The Fastest In Delivery ',
                            style: textTheme.titleLarge(
                              fontWeight: FontWeight.w600,
                              overrideColor: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "Food",
                            style: textTheme.titleLarge(
                              fontWeight: FontWeight.bold,
                              overrideColor: AppColors.redColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: 120.w,
                    child: PrimaryButton(
                      onTap: (){},
                      buttonTitle: "Order Now",
                      buttonColor: AppColors.redColor,
                      isRounded: true,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Image.asset("assets/courier.png", height: 120.h,),
              SizedBox(width: 16.w)
            ],
          )
        ],
      ),
    );
  }
}