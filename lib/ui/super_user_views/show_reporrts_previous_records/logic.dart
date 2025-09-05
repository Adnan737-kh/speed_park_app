import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed_park_app/core/services/database.dart';
import 'package:speed_park_app/ui/super_user_views/show_reporrts_previous_records/view.dart';

import '../../../core/constants/colors.dart';
import '../../../core/model/report_model/report_model.dart';
import '../create_location/logic.dart';
import 'state.dart';

class ShowReportsPreviousRecordsLogic extends GetxController {
  final ShowEmployeePreviousRecordsState state =
      ShowEmployeePreviousRecordsState();

  TextEditingController descController = TextEditingController();

  List<ReportModel> reportData = <ReportModel>[].obs;
  final progressDialog = ProgressDialogSingleton.createProgressDialog(Get.context!);


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    descController.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    fetchData(); // Fetch data when the controller is initialized
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data = await DataBaseServices().fetchData();
      reportData.assignAll(data);
      update();
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  /** call this function **/
  updateReport(String uid, String description, BuildContext context) async {
    try {
      if (descController.text.isNotEmpty) {
        progressDialog.show();
        // ProgressDialogSingleton.getInstance(Get.context!).show();
        final response =
            await DataBaseServices().updateReport(uid, description);
        if (response) {
          progressDialog.dismiss();
          // ProgressDialogSingleton.getInstance(Get.context!).dismiss();

          Get.snackbar(
            'Done',
            "Report Update Successfully",
            colorText: Colors.black,
            backgroundColor: kPrimary2,
            icon: const Icon(Icons.add_alert),
          );
          descController.clear();
          update();
          Get.to(() => ShowPreviousReportsRecordsPage());
        }

        update();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('please enter report'),
          ),
        );
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}
