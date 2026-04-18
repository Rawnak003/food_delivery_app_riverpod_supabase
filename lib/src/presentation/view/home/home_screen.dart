import 'package:flutter/material.dart';
import 'package:food_delivery_supabase_riverpod/src/core/route/route_name.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          final supabase = Supabase.instance.client;
          supabase.auth.signOut();
          Navigator.pushNamedAndRemoveUntil(context, RouteNames.loginScreen, (predicate) => false);
        },
        child: const Center(
          child: Text('Logout'),
        ),
      ),
    );
  }
}
