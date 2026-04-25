
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authStateProvider = StreamProvider((ref) {
  final sb = Supabase.instance.client;
  return sb.auth.onAuthStateChange;
});