import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_supabase_riverpod/src/view_models/states/sign_up_state.dart';
import '../../core/services/auth/auth_service.dart';

final signUpProvider = NotifierProvider<SignUpNotifier, SignUpState>(
  SignUpNotifier.new,
);

class SignUpNotifier extends Notifier<SignUpState> {
  final AuthService _authService = AuthService();

  @override
  SignUpState build() =>
      const SignUpState(isLoading: false, isPasswordObscure: true);

  void togglePassword() {
    state = state.copyWith(isPasswordObscure: !state.isPasswordObscure);
  }

  Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true);

    final result = await _authService.signUp(email: email, password: password);

    state = state.copyWith(isLoading: false);

    return result;
  }
}
