import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainViewModel extends Notifier<int> {
  @override
  int build() => 0;

  void changeTab(int index) {
    state = index;
  }
}

final mainViewModelProvider = NotifierProvider<MainViewModel, int>(
  () => MainViewModel(),
);
