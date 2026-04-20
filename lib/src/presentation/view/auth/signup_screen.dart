import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_supabase_riverpod/src/core/utils/validators.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_style.dart';
import '../../../core/utils/app_toast.dart';
import '../../../view_models/riverpods/sign_up_provider.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextStyle.auto(context);

    final state = ref.watch(signUpProvider);
    final notifier = ref.read(signUpProvider.notifier);

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
                  isObscure: state.isPasswordObscure,
                  prefixIconPath: "assets/icon/lock.svg",
                  suffixIconPath: state.isPasswordObscure
                      ? "assets/icon/eye.svg"
                      : "assets/icon/eye-slash.svg",
                  suffixIconOnTap: notifier.togglePassword,
                  validator: (value) => Validators.passwordValidator(value),
                ),
                SizedBox(height: 36.h),
                state.isLoading
                    ? AppLoader.wave()
                    : PrimaryButton(
                        onTap: () async {
                          String email = _emailController.text.trim();
                          String password = _passwordController.text.trim();

                          if (email.isEmpty || password.isEmpty) {
                            AppToast.showToast(
                              "Email and password are required",
                            );
                            return;
                          }

                          final String? errorMessage = await notifier.signUp(
                            email: email,
                            password: password,
                          );

                          if (errorMessage != null) {
                            AppToast.showToast(errorMessage);
                          } else {
                            AppToast.showToast("Sign up successful");
                            Navigator.pop(context);
                          }
                        },
                        buttonTitle: "Sign Up",
                      ),
                SizedBox(height: 24.h),
                RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
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
