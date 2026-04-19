class SignUpState {
  final bool isLoading;
  final bool isPasswordObscure;

  const SignUpState({required this.isLoading, required this.isPasswordObscure});

  SignUpState copyWith({bool? isLoading, bool? isPasswordObscure}) {
    return SignUpState(
      isLoading: isLoading ?? this.isLoading,
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
    );
  }
}
