import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_supabase_riverpod/src/core/utils/validators.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/auth/auth_service.dart';
import '../../../core/theme/app_text_style.dart';
import '../../../core/utils/app_toast.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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

  void signUp() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      AppToast.showToast("Email and password are required");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final String? errorMessage = await _authService.signUp(email: email, password: password);

    if (errorMessage != null) {
      AppToast.showToast(errorMessage);
    } else {
      AppToast.showToast("Sign up successful");
      Navigator.pop(context);
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
                  'assets/6343825.jpg',
                  height: 400,
                  width: double.maxFinite,
                ),
                Text(
                  'Create an account',
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
                SizedBox(height: 36.h),
                isLoading ? AppLoader.wave() : PrimaryButton(onTap: signUp, buttonTitle: "Sign Up"),
                SizedBox(height: 24.h,),
                RichText(
                  text: TextSpan(
                    text:
                    'Already have an account? ',
                    style: textTheme.bodySmall(),
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: textTheme.bodySmall(
                          fontWeight: FontWeight.bold,
                          overrideColor: AppColors.primary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pop(context);
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
