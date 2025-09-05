import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:speed_park_app/core/model/history/car_history_model.dart';
import 'package:speed_park_app/ui/super_user_views/create_report/report_generate/generate_report_from_filter_day/view.dart';
import '../../../../../core/services/database.dart';
import '../../../../lobby_controller_views/edit_option/logic.dart';
import '../../../../lobby_controller_views/register_car/upload_image.dart';
import '../../../create_location/logic.dart';

class CarEditOptionState {
  RxList<String> imagePaths = <String>[].obs;
}
class CarEditOptionLogic extends GetxController {

  final state = CarEditOptionState();

  // Function to add an image path to the state

  void addImage(String imagePath) {
    if (state.imagePaths.length < 6) {
      state.imagePaths.add(imagePath);
    } else {
      Get.snackbar('Max Reached', 'only 6 images');
    }
  }


  final TextEditingController carMadeController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController carTypeController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController ownerController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController plateNoController = TextEditingController();
  final TextEditingController parkingNoController = TextEditingController();
  final TextEditingController floorNoController = TextEditingController();
  final TextEditingController driverNameController = TextEditingController();
  final TextEditingController ticketNumberController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController registerDateController = TextEditingController();
  final TextEditingController registerTimeController = TextEditingController();
  final progressDialog = ProgressDialogSingleton.createProgressDialog(Get.context!);



  Future<void> updateCarInHistoryFirebase(String uid,CarHistoryModel? model) async {
    List noImage=[''];
    final storageRef =
    FirebaseStorage.instance.ref().child('car_registration_images');
    progressDialog.show();
    // ProgressDialogSingleton.getInstance(Get.context!).show();
    try {
      for (var pickedFile in state.imagePaths) {
        final imageName = DateTime.now().millisecondsSinceEpoch.toString();
        final imageRef = storageRef.child('$imageName.jpg');

        // Upload image to Firebase Storage
        await imageRef.putFile(File(pickedFile));

        // Get download URL
        final imageUrl = await imageRef.getDownloadURL();
        imageUrls.add(imageUrl);
      }
      CarHistoryModel registrationModelData = CarHistoryModel(
        images:imageUrls.isNotEmpty?imageUrls:noImage,
        carMade:carMadeController.text.isNotEmpty? carMadeController.text:model?.carMade,
        model:modelController.text.isNotEmpty? modelController.text:model?.model,
        carType:carTypeController.text.isNotEmpty? carTypeController.text:model?.carType,
        color:colorController.text.isNotEmpty? colorController.text:model?.color,
        owner:ownerController.text.isNotEmpty? ownerController.text:model?.owner,
        mobileNumber:mobileNumberController.text.isNotEmpty? mobileNumberController.text:model?.mobileNumber,
        platNumber:plateNoController.text.isNotEmpty? plateNoController.text:model?.platNumber,
        parkingNumber:parkingNoController.text.isNotEmpty? parkingNoController.text:model?.parkingNumber,
        floorNumber:floorNoController.text.isNotEmpty? floorNoController.text:model?.floorNumber,
        amountIncludeTax : amountController.text.isNotEmpty? amountController.text : model?.amountIncludeTax,
        registerDate: registerDateController.text.isNotEmpty? registerDateController.text : model?.registerDate,
        perHour: model?.perHour,
        recordDamage: model?.recordDamage,
        selectCharges: model?.selectCharges,
        taxCharge: model?.taxCharge,
        ticketNumber:ticketNumberController.text.isNotEmpty? ticketNumberController.text:model?.ticketNumber,
        registerTime: registerTimeController.text.isNotEmpty? registerTimeController.text : model?.registerTime,
        deliveredTime: model?.deliveredTime,
        uid: model?.uid,
        userLocation: model?.userLocation,
        validationRequestedBy: model?.validationRequestedBy,
        orderByTime: model?.orderByTime,
        driverName:driverNameController.text.isNotEmpty?driverNameController.text.toString().toLowerCase() :model?.driverName,
        deliveredDate: model?.deliveredDate,
        driverReceive: model?.driverReceive,
        isCarPaidOrValidated: model?.isCarPaidOrValidated,
        locationTypeCheck: model?.locationTypeCheck,
        taxInclude: model?.taxInclude,
        validatorName: model?.validatorName,

      );
      final res=await DataBaseServices().updateCarInHistory(uid, registrationModelData.toMap());
      if(res){

        progressDialog.dismiss();
        // ProgressDialogSingleton.getInstance(Get.context!).dismiss();
        Get.to(
                () =>  GenerateReportFromFilterPageDay());
        state.imagePaths.clear();
        imageUrls.clear();
        controller.carRemove(index: 1);

      }
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
    }
  }


  // Function to remove an image path from the state
  void removeImage(String imagePath) {
    state.imagePaths.remove(imagePath);
  }
}
