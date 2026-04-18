import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_supabase_riverpod/src/core/constants/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/shared_pref_data.dart';
import '../auth/login_screen.dart';
import '../home/home_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final supabase = Supabase.instance.client;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // 🌟 Smooth fade
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    // 🔵 Smooth zoom-in (key improvement)
    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    // ✍️ Text delay effect
    _textAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    );

    _controller.forward();

    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(seconds: 2));

    final hasSeenOnboarding =
    SharedPreferenceData.hasSeenOnboarding();

    final session = supabase.auth.currentSession;

    if (session != null) {
      _goTo(const HomeScreen());
      return;
    }

    if (!hasSeenOnboarding) {
      _goTo(const OnboardingScreen());
      return;
    }

    _goTo(const LoginScreen());
  }

  void _goTo(Widget screen) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6A11CB),
              Color(0xFF2575FC),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔵 Animated Logo
              ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    height: 120.h,
                    width: 120.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 25,
                          offset: const Offset(0, 12),
                        )
                      ],
                    ),
                    child: Icon(
                      Icons.fastfood_rounded,
                      size: 60.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 25.h),

              // 🟣 Animated Title
              FadeTransition(
                opacity: _textAnimation,
                child: Text(
                  "Food Delivery",
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              SizedBox(height: 8.h),

              FadeTransition(
                opacity: _textAnimation,
                child: Text(
                  "Fresh food at your door",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white70,
                  ),
                ),
              ),

              SizedBox(height: 40.h),

              // 🔄 Loader (soft)
              FadeTransition(
                opacity: _fadeAnimation,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}