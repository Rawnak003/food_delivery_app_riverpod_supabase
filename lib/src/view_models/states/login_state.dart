class LoginState {
  final bool isLoading;
  final bool isPasswordObscure;

  const LoginState({required this.isLoading, required this.isPasswordObscure});

  LoginState copyWith({bool? isLoading, bool? isPasswordObscure}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
    );
  }
}
