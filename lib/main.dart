import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_supabase_riverpod/src/core/services/local/shared_pref_service.dart';
import 'package:food_delivery_supabase_riverpod/src/presentation/view/home/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/core/route/route_configs.dart';
import 'src/presentation/view/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPrefService.init();

  await Supabase.initialize(
    url: 'https://vaxjcxktzcqoduzokkln.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZheGpjeGt0emNxb2R1em9ra2xuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY1MjM3NDAsImV4cCI6MjA5MjA5OTc0MH0.lfeShvNJiDqMGoPR0Rh2WWVggo4nLb4flkMqN-OpIPY',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Food Delivery App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: AppRoutes.initialRoute,
          onGenerateRoute: AppRoutes.onGenerateRoute,
        );
      },
    );
  }
}
