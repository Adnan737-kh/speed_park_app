import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';

import '../../../core/model/history/car_history_model.dart';
import '../../../core/services/database.dart';
import 'state.dart';

class ReceiveACarLogic extends GetxController {
  final ReceiveACarState state = ReceiveACarState();

  final Rx<List<CarHistoryModel>> _car = Rx<List<CarHistoryModel>>([]);
  List<CarHistoryModel> get car => _car.value;

  @override
  void onReady() {
    super.onReady();
    // fetchCarRegistrationData();
  }

  final DataBaseServices _repository = DataBaseServices();
  @override
  void onInit() {
    super.onInit();
    _car.bindStream(_repository.getCarHistory());
  }

  deleteHistory({String? uid})async{
    ProgressDialog PD = ProgressDialog(
      Get.context!,
      blur: 10,
      title: const Text('Delete History'),
      message: const Text("Please Wait..."),
      onDismiss: () {
        if (kDebugMode) {
          debugPrint("Do something onDismiss");
        }
      },
    );
    PD.show();

    // final res=await DataBaseServices().update_car_Request(uid);
    final response = await DataBaseServices()
        .deleteCarFromHistory(uid!);
    if (response) {

     // logic.carRemove(index: index);
      PD.dismiss();

      //response == true ? Get.back() : '';
    }
  }

}
