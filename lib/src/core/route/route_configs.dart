import 'package:flutter/material.dart';
import 'package:food_delivery_supabase_riverpod/src/presentation/view/home/screens/all_product_screen.dart';
import 'package:food_delivery_supabase_riverpod/src/presentation/view/home/screens/home_screen.dart';
import 'package:food_delivery_supabase_riverpod/src/presentation/view/home/screens/product_details_screen.dart';
import 'package:food_delivery_supabase_riverpod/src/presentation/view/onboarding/onboarding_screen.dart';
import 'package:food_delivery_supabase_riverpod/src/presentation/view/onboarding/splash_screen.dart';
import 'package:food_delivery_supabase_riverpod/src/presentation/view/parent/parent_screen.dart';
import '../../models/product_model.dart';
import '../../presentation/view/auth/login_screen.dart';
import '../../presentation/view/auth/signup_screen.dart';
import 'route_name.dart';

class AppRoutes {
  static String initialRoute = RouteNames.splashScreen;

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splashScreen:
        return _buildRoute(const SplashScreen());
      case RouteNames.onboardingScreen:
        return _buildRoute(const OnboardingScreen());
      case RouteNames.loginScreen:
        return _buildRoute(const LoginScreen());
      case RouteNames.signUpScreen:
        return _buildRoute(const SignupScreen());
      case RouteNames.parentScreen:
        return _buildRoute(const ParentScreen());
      case RouteNames.allProductScreen:
        return _buildRoute(const AllProductScreen());
      case RouteNames.productDetailsScreen:
        final product = settings.arguments as FoodModel;
        return _buildRoute(ProductDetailsScreen(product: product));

      default:
        return null;
    }
  }

  static PageRouteBuilder _buildRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,

      transitionDuration: const Duration(milliseconds: 350),

      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );

        return FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }
}
