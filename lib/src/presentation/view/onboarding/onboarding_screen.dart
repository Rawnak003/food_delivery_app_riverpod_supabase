import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_supabase_riverpod/src/data/shared_pref_data.dart';
import 'package:food_delivery_supabase_riverpod/src/presentation/widgets/primary_button.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/route/route_name.dart';
import '../../../core/theme/app_text_style.dart';
import '../../../models/on_bording_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextStyle.auto(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            color: AppColors.imageBackground1,
            child: Image.asset(
              "assets/food pattern.png",
              color: AppColors.imageBackground2,
              repeat: ImageRepeat.repeatY,
            ),
          ),

          Positioned(
            top: -60.h,
            left: 0,
            right: 0,
            child: Image.asset("assets/chef.png"),
          ),

          Positioned(
            top: 145.h,
            right: 40.w,
            child: Image.asset("assets/leaf.png", width: 80.w),
          ),
          Positioned(
            top: 370.h,
            right: 20.w,
            child: Image.asset("assets/chili.png", width: 80.w),
          ),
          Positioned(
            top: 300.h,
            left: 0.w,
            child: Image.asset("assets/ginger.png", width: 90.w),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 180.h,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: data.length,
                      onPageChanged: _onPageChanged,
                      itemBuilder: (context, index) {
                        final item = data[index];

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: item['title1'],
                                    style: textTheme.headlineLarge(
                                      fontWeight: FontWeight.w600,
                                      overrideColor: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: item['title2'],
                                    style: textTheme.headlineLarge(
                                      fontWeight: FontWeight.bold,
                                      overrideColor: AppColors.redColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              item['description']!,
                              textAlign: TextAlign.center,
                              style: textTheme.bodyLarge(
                                overrideColor: Colors.grey.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 20.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      data.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        width: currentIndex == index ? 20.w : 8.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: currentIndex == index
                              ? AppColors.redColor
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30.h),

                  PrimaryButton(
                    onTap: () async {
                      if (currentIndex == data.length - 1) {
                        // TODO: mark onboarding done
                        await SharedPreferenceData.setOnboardingSeen();
                        Navigator.pushNamedAndRemoveUntil(context, RouteNames.loginScreen, (predicate) => false);
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    buttonTitle: currentIndex == data.length - 1
                        ? "Get Started"
                        : "Next",
                    buttonColor: AppColors.redColor,
                  ),

                  SizedBox(height: 10.h),

                  TextButton(
                    onPressed: () {
                      _pageController.animateToPage(
                        data.length - 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text(
                      "Skip",
                      style: textTheme.bodyMedium(
                        overrideColor: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
