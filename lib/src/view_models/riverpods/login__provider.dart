import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/auth/auth_service.dart';
import '../states/login_state.dart';

final loginProvider = NotifierProvider<LoginNotifier, LoginState>(
  LoginNotifier.new,
);

class LoginNotifier extends Notifier<LoginState> {
  final AuthService _authService = AuthService();

  @override
  LoginState build() =>
      const LoginState(isLoading: false, isPasswordObscure: true);

  void togglePassword() {
    state = state.copyWith(isPasswordObscure: !state.isPasswordObscure);
  }

  Future<String?> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true);

    final result = await _authService.login(email: email, password: password);

    state = state.copyWith(isLoading: false);

    return result;
  }
}
