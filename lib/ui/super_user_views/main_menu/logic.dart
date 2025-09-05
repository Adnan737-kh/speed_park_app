import 'package:get/get.dart';

import 'state.dart';

class MainMenuLogic extends GetxController {
  final MainMenuState state = MainMenuState();

  RxInt  currentTab = 0.obs;

  void changeTab(int index) {
    currentTab.value = index;
  }
}
