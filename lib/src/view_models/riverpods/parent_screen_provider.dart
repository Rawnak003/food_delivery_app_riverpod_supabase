import 'package:flutter_riverpod/flutter_riverpod.dart';

final parentScreenProvider = NotifierProvider<ParentScreenProvider, int>(ParentScreenProvider.new);

class ParentScreenProvider extends Notifier<int>{
  @override
  int build() {
    return 0;
  }

  void setPage(int index) {
    state = index;
  }
}