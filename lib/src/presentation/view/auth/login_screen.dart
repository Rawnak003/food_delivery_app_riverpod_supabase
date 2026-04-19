import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_supabase_riverpod/src/core/utils/validators.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/route/route_name.dart';
import '../../../core/services/auth/auth_service.dart';
import '../../../core/theme/app_text_style.dart';
import '../../../core/utils/app_toast.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool isPasswordObscure = true;
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      AppToast.showToast("Email and password are required");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final String? errorMessage = await _authService.login(email: email, password: password);

    if (errorMessage != null) {
      AppToast.showToast(errorMessage);
    } else {
      AppToast.showToast("Logged in successfully", backgroundColor: Colors.green);
      Navigator.pushNamedAndRemoveUntil(context, RouteNames.parentScreen, (predicate) => false);
    }

    setState(() {
      isLoading = false;
    });
  }

  void togglePassword() {
    setState(() {
      isPasswordObscure = !isPasswordObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextStyle.auto(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/login.jpg',
                  height: 400,
                  width: double.maxFinite,
                ),
                Text(
                  'Account Login',
                  style: AppTextStyle.auto(
                    context,
                  ).headlineSmall(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 24.h),
                CustomTextField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  action: TextInputAction.next,
                  prefixIconPath: 'assets/icon/envelope.svg',
                  validator: (value) => Validators.emailValidator(value),
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  label: 'Password',
                  controller: _passwordController,
                  action: TextInputAction.done,
                  isObscure: isPasswordObscure,
                  prefixIconPath: "assets/icon/lock.svg",
                  suffixIconPath: isPasswordObscure
                      ? "assets/icon/eye.svg"
                      : "assets/icon/eye-slash.svg",
                  suffixIconOnTap: togglePassword,
                  validator: (value) => Validators.passwordValidator(value),
                ),
                SizedBox(height: 12.h,),
            
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 36.h),
                isLoading ? AppLoader.wave() : PrimaryButton(onTap: login, buttonTitle: "Login"),
                SizedBox(height: 24.h,),
                RichText(
                  text: TextSpan(
                    text:
                    'Don\'t have an account? ',
                    style: textTheme.bodySmall(),
                    children: [
                      TextSpan(
                        text: 'Sign Up',
                        style: textTheme.bodySmall(
                          fontWeight: FontWeight.bold,
                          overrideColor: AppColors.primary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, RouteNames.signUpScreen);
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
