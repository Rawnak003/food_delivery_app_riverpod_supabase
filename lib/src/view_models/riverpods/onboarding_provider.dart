import 'package:flutter_riverpod/flutter_riverpod.dart';

final onboardingProvider = NotifierProvider<OnboardingProvider, int>(OnboardingProvider.new);

class OnboardingProvider extends Notifier<int>{
  @override
  int build() {
    return 0;
  }

  void next(int totalPages) {
    if (state < totalPages - 1) {
      state++;
    }
  }

  void setPage(int index) {
    state = index;
  }
}