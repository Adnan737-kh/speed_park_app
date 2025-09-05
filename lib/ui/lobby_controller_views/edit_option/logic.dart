import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:speed_park_app/core/services/database.dart';

import '../../../core/model/register_car/car_registration.dart';
import '../../super_user_views/create_location/logic.dart';
import '../car_in_parking/logic.dart';
import '../register_car/upload_image.dart';

final CarInParkingLogic controller = Get.put(CarInParkingLogic());
class EditOptionState {
  RxList<String> imagePaths = <String>[].obs;
}

class EditOptionLogic extends GetxController {


  final state = EditOptionState();

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
  final progressDialog = ProgressDialogSingleton.createProgressDialog(Get.context!);

// Show the progress dialog



  Future<void> uploadImagesToFirebase(String uid,CarRegistrationModel? model) async {
  List noImage=[''];
    final storageRef =
    FirebaseStorage.instance.ref().child('car_registration_images');
    progressDialog.dismiss();
  // ProgressDialogSingleton.getInstance(Get.context!).dismiss();
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
      CarRegistrationModel registrationModelData = CarRegistrationModel(
        images:imageUrls.isNotEmpty?imageUrls:noImage,
        carMade:carMadeController.text.isNotEmpty? carMadeController.text:model?.carMade,
        model:modelController.text.isNotEmpty? modelController.text:model?.model,
        carType:carTypeController.text.isNotEmpty? carTypeController.text:model?.carType,
        color:colorController.text.isNotEmpty? colorController.text:model?.color,
        owner:ownerController.text.isNotEmpty? ownerController.text:model?.owner,
        mobileNumber:mobileNumberController.text.isNotEmpty? mobileNumberController.text:model?.mobileNumber,
        plateNumber:plateNoController.text.isNotEmpty? plateNoController.text:model?.plateNumber,
        parkingNumber:parkingNoController.text.isNotEmpty? parkingNoController.text:model?.parkingNumber,
        floorNumber:floorNoController.text.isNotEmpty? floorNoController.text:model?.floorNumber,
        amount: model?.amount,
        date: model?.date,
        perHour: model?.perHour,
        recordDamage: model?.recordDamage,
        selectCharges: model?.selectCharges,
        selectLocation: model?.selectLocation,
        taxCharge: model?.taxCharge,
        ticket:ticketNumberController.text.isNotEmpty? ticketNumberController.text:model?.ticket,
        ticketValid: model?.ticketValid,
        time: model?.time,
        totalAmountPerHour: model?.totalAmountPerHour,
        totalAmountTax: model?.totalAmountTax,
        uid: model?.uid,
        userId: model?.userId,
        userLocation: model?.userLocation,
        validationUserName: model?.validationUserName,
        uniqueId: model?.uniqueId,
        validationRequestBy: model?.validationRequestBy,
        lobbyRequest: model?.lobbyRequest,
        request: model?.request,
        orderByTime: model?.orderByTime,
        driverName:driverNameController.text.isNotEmpty?driverNameController.text.toString().toLowerCase() :model?.driverName,
        paidUnPaid: false,);
      final res=await DataBaseServices().updateCarImages(uid, registrationModelData.toMap());
      if(res){
        progressDialog.dismiss();
        // ProgressDialogSingleton.getInstance(Get.context!).dismiss();
        Get.back();
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
