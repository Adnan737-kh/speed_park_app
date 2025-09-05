import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndialog/ndialog.dart';

import '../../../core/model/location/location_model.dart';
import '../../../core/services/database.dart';
import 'state.dart';

final GlobalKey<State> progressDialogKey = GlobalKey<State>();
class ProgressDialogSingleton {

  static ProgressDialog createProgressDialog(BuildContext context) {
    return ProgressDialog(
      context,
      blur: 10,
      title: const Text("Uploading Data"),
      message: const Text("Please Wait"),
      onDismiss: () {
        if (kDebugMode) {
          debugPrint("Progress dialog dismissed.");
        }
      },
    );
  }
}



class ProgressDialogSingletonTwo {
  static ProgressDialog? _progressDialog;


  static ProgressDialog createOrGetProgressDialog(BuildContext context) {
    // Check if we need to recreate the dialog due to context changes
    if (_progressDialog == null || _progressDialog!.context != context) {
      _progressDialog = ProgressDialog(
        context,
        blur: 10,
        title: const Text("Uploading Data"),
        message: const Text("Please Wait"),
        onDismiss: () {
          if (kDebugMode) {
            debugPrint("Progress dialog dismissed.");
          }
        },
      );
    }

    return _progressDialog!;
  }
}




class CreateLocationLogic extends GetxController {
  final CreateLocationState state = CreateLocationState();
  TextEditingController codeController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController staffController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  final progressDialog = ProgressDialogSingleton.createProgressDialog(Get.context!);

  String? fromTiming;
  String? toTiming;
  List images = <File>[];
  var items = ['Normal', "Paid"];
  String? _selectedValue;
  String? get selectedValue=>_selectedValue;

  void updateField(value) {
    _selectedValue = value;
    update();
  }
  var charges = ["Per Services","Per hour"];
  String? selectCharges;
  void updateChargesField(value) {
    selectCharges = value;
    update();
  }


  List<String> timings = [
    '00:00',
    '01:00',
    '02:00',
    '03:00',
    '04:00',
    '05:00',
    '06:00',
    '07:00',
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00',
    '19:00',
    '20:00',
    '21:00',
    '22:00',
    '23:00'
  ];
  List text = [
    // 'Code',
    'Location',
    'No. Of Staff',
    'Office Type',
    'Timing Start',
    'Timings End',
    'Location Type',
    'Filter',
  ];
  changeDrop(String value) {
    fromTiming = value;
    update();
  }

  changeDroptoTiming(String value) {
    toTiming = value;
    update();
  }

  // Function to save data to Firestore
   saveData(BuildContext context) async {

      LocationModel locationModel = LocationModel(
        code: codeController.text,
        desc: descController.text,
        staff: staffController.text,
        location: locationController.text,
        selectLocation: selectedValue.toString(),
        selectCharges:selectCharges.toString(),
        taxCharge:selectTaxCharges.toString(),
        perHour:perHourController.text.toString(),
        totalAmountPerHour: amountController.text.toString()??'',
        totalAmountWithTax: totalAmountWithTaxController.text.toString(),
        amount: amountController.text.toString()??'',);

      progressDialog.show();
      // ProgressDialogSingleton.getInstance(Get.context!).show();
      final response =
      await DataBaseServices().addLocation(locationModel.toMap());
      if(response){
        clearController();
        if (kDebugMode) {
          print('Data saved to Firestore');
        }
        progressDialog.dismiss();
        // ProgressDialogSingleton.getInstance(Get.context!).dismiss();

        updateField('Select Location');
        updateChargesField('Select Charges');

      }else{
        //clearController();
        progressDialog.dismiss();
        // ProgressDialogSingleton.getInstance(Get.context!).show();
        if (kDebugMode) {
          print('Data not saved to Firestore');
        }

      }
      if (kDebugMode) {
        print('Data saved to Firestore');
      }
    update();
  }



  @override
  void onInit() {
    super.onInit();

    // Add a listener to the amountController
    amountController.addListener(() {
      // Calculate the total amount with tax when the amount changes
      calculateTotalAmountWithTax();
    });
    perHourController.addListener(() {
      // Calculate the total amount with tax when the amount changes
      calculateTotalAmountWithTax();
    });

    // ... Other initialization code ...
  }
  Future<void> uploadImagesToFirebaseStorage(List images) async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      final Reference storageRef = storage.ref().child('locationImages');

      for (int i = 0; i < images.length; i++) {
        File imageFile = images[i];
        String fileName =
            'image_$i.jpg'; // You can modify the naming convention
        Reference fileRef = storageRef.child(fileName);

        // Upload the image
        UploadTask uploadTask = fileRef.putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask;

        if (taskSnapshot.state == TaskState.success) {
          // Image uploaded successfully, you can get the download URL here
          String downloadURL = await fileRef.getDownloadURL();

          if (kDebugMode) {
            debugPrint('Image $i uploaded. Download URL: $downloadURL');
          }
          // You can store the downloadURL in a database if needed
        }
      }

      if (kDebugMode) {
        debugPrint('All images uploaded to Firebase Storage');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error uploading images: $e');
      }
    }
  }

  var locationData = <LocationModel>[].obs;

  // Method to add a new image
  void addImage(File image) {
    images.add(image);
    update();
  }

  // Method to remove an image
  void removeImage(int index) {
    images.removeAt(index);
    update();
  }

  final ImagePicker picker = ImagePicker();

  // Modify _pickFromGallery method
  Future<void> pickFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && images.length < 6) {
      // Use the addImage method to add the new image
      addImage(File(pickedFile.path));
      update();
    } else {
      // Show a snackbar message if the maximum number of images has been reached
      Get.snackbar(
        'Error',
        'You can only pick up to 6 images.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    Get.back();
  }

  Future<void> takePhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null && images.length < 6) {
      addImage(File(pickedFile.path));
      update();
    }
    Get.back();
  }

  clearController() {
    codeController.clear();
    descController.clear();
    staffController.clear();
    toTiming = '';
    fromTiming = '';
    locationController.clear();
    images.clear();
    update();
  }


  /** Per Services work**/
  TextEditingController amountController = TextEditingController();
  TextEditingController taxController = TextEditingController();
  TextEditingController totalAmountWithTaxController = TextEditingController();
  TextEditingController perHourController = TextEditingController();
  var taxCharges = ["Tax Inclusive","Tax Exclusive"];
  String? selectTaxCharges;
  void updateTaxChargesField(value) {
    selectTaxCharges = value;
    update();
  }
  String? _selectedPerServicesValue;
  String? get selectedPerServicesValue=>_selectedPerServicesValue;
  void updatePerServiceField(value) {
    _selectedPerServicesValue = value;
    update();
  }

  void calculateTotalAmountWithTax() {
    final double amount = double.tryParse(amountController.text) ?? 0.0;
    final double perHourAmount = double.tryParse(perHourController.text) ?? 0.0;
    const double taxPercentage = 5.0;

    // Calculate the total amount before tax
    final double totalAmount = amount + perHourAmount;

    // Calculate the tax amount on the total amount
    final double totalTaxAmount = (totalAmount * taxPercentage) / 100;

    // Calculate the total amount with tax
    final double totalAmountWithTax = totalAmount + totalTaxAmount;

    // Update the respective text controllers
    taxController.text = totalTaxAmount.toStringAsFixed(2); // Format total tax amount with two decimal places
    totalAmountWithTaxController.text = totalAmountWithTax.toStringAsFixed(2); // Format total amount with tax
  }


/** Per Services work End**/
}
