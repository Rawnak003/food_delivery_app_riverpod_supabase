import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../route/route_name.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signUp(email: email, password: password);

      if (response.user != null) {
        return null;
      }

      return "An unknown error occurred";
    }
    on AuthException catch (e) {
      return e.message;
    }
    catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signInWithPassword(email: email, password: password);

      if (response.user != null) {
        return null;
      }

      return "An unknown error occurred";
    }
    on AuthException catch (e) {
      return e.message;
    }
    catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await supabase.auth.signOut();
      if (!context.mounted) return;
      Navigator.pushNamed(context, RouteNames.loginScreen);
    } catch (e) {
      debugPrint("\n\n{e.toString()}\n\n");
    }
  }
}
