import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'state.dart';

class NonPaidLocationLogic extends GetxController {
  final NonPaidLocationState state = NonPaidLocationState();

  List customerVisits = [];

  TextEditingController rNameController = TextEditingController();

  void updateList() {
    {
      customerVisits.add(rNameController.text);
      rNameController.clear();
      update();
    }
  }
}
