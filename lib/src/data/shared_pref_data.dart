import 'package:food_delivery_supabase_riverpod/src/core/constants/app_keys.dart';

import '../core/services/local/shared_pref_service.dart';

class SharedPreferenceData {
  SharedPreferenceData._();

  static bool hasSeenOnboarding() {
    return SharedPrefService.getBool(AppKeys.onboarding) ?? false;
  }
  static Future<void> setOnboardingSeen() async {
    await SharedPrefService.setBool(AppKeys.onboarding, true);
  }
}