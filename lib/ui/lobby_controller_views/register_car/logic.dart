import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:speed_park_app/core/model/register_car/car_registration.dart';
import 'package:speed_park_app/core/services/database.dart';
import 'package:speed_park_app/core/utils/progress_dailog.dart';
import 'package:speed_park_app/ui/lobby_controller_views/register_car/upload_image.dart';

import '../../../core/constants/colors.dart';
import '../../super_user_views/create_location/logic.dart';
import '../car_in_parking/logic.dart';
import '../lobby_login/logic.dart';
import 'state.dart';
final CarInParkingLogic carInParkingLogic = Get.find<CarInParkingLogic>();
class RegisterCarLogic extends GetxController {
  final Register_carState state = Register_carState();
  final logic = Get.put(LobbyLoginLogic());

  String? selectedValue;
  String? selectedColorValue;
  String? selectedCardTypeValue;

  String? selectedCarDamage;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  GlobalKey<FormState> get formKey => _formKey;

  final RxBool isDialogOpen = false.obs;
  final RxString scannedValue = ''.obs;

  void openDialog() {
    isDialogOpen.value = true;
  }

  void closeDialog() {
    isDialogOpen.value = false;
  }

  void updateScannedValue(String value) {
    scannedValue.value = value;
    update();
  }

  // Define a property to determine whether to show images or not
  var showImages = false.obs;
  String _buttonMessage='Share QR Code as PDF';// Your QR code message
  String get buttonMessage=>_buttonMessage;

  updateMessage(){
    _buttonMessage='hello';
    update();
  }

  // Method to toggle the showImages property
  void toggleShowImages(bool value) {
    showImages.value = value;
  }

  void updateField(value) {
    selectedValue = value;
    update();
  }

  void updateColorField(value) {
    selectedColorValue = value;
    update();
  }

  void updateCarTypeField(value) {
    selectedCardTypeValue = value;
    update();
  }

  void updateDamage(value) {
    selectedCarDamage = value;
    update();
  }

  var damage = [
    'Upload Images',
    'Type Manually',
  ];
  var colorList = [
    'Other',
    'Red',
    'Black',
    'White',
    'Blue',
    'Silver',
    'Green',
    'Gray',
    'Orange',
    'Yellow',
    'Brown',
    'Beige',
    'Purple',
    'Baby Blue',
    'Black Gold',
    'Metallic Blue',
    'Mojave Metallic'
  ];
  var carMadeList = [
    'Other',
    'Audi',
    'Bmw',
    'Dodge',
    'Honda',
    'Mercedez',
    'Nissan',
    'Toyota',
    'Ford',
    'Buggati',
    'Bentley',
    'Chevrolet',
    'Gmc',
    'Hyundai',
    'Lamborghini',
    'Mitsubishi',
    'Lexus',
    'Land Rover',
    'Range Rover',
    'Maserati',
    'Mazda',
    'Mclacren',
    'Peugeot',
    'Porche',

  ];
  Map<String, List<String>> carTypeList = {
    'Audi':['A5', 'A6', 'A7''Q3','Q5','Q7','R8'],
  };

  // CarType(title: 'Bmw', models: ['3 Series', '5 Series', '5 Series''X3','X5','X6','X7']),
  // CarType(title: 'Dodge', models: ['Charger', 'Challenger', 'Durango''Ram 1500']),
  // CarType(title: 'Honda', models: ['Accord', 'Civic', 'Durango''Ram 1500']),

  TextEditingController uidController = TextEditingController();
  TextEditingController ticketController = TextEditingController();
  TextEditingController driverNameController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController carMadeController =
      TextEditingController(text: 'Toyota');
  TextEditingController modelController = TextEditingController();
  TextEditingController carTypeController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController ownerController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController recordDamageController = TextEditingController();
  TextEditingController floorNumberController = TextEditingController();
  TextEditingController parkingNumberController = TextEditingController();
  TextEditingController plateNumberController = TextEditingController();
  TextEditingController userIdController = TextEditingController();


  DateTime currentDateTime = DateTime.now();
  String? _date;
  String? get dateTime => _date;
  String? currentDate;
  String? currentTime;
  int randomId = generateRandomId();


  @override
  void dispose() {
    uidController.dispose();
    timeController.dispose();
    carMadeController.dispose();
    modelController.dispose();
    carTypeController.dispose();
    colorController.dispose();
    ownerController.dispose();
    mobileNumberController.dispose();
    recordDamageController.dispose();
    floorNumberController.dispose();
    parkingNumberController.dispose();
    plateNumberController.dispose();
    userIdController.dispose();
    ticketController.dispose();
    super.dispose();
  }

  void clearController() {
    uidController.clear();
    timeController.clear();
    carMadeController.clear();
    modelController.clear();
    carTypeController.clear();
    colorController.clear();
    ownerController.clear();
    mobileNumberController.clear();
    recordDamageController.clear();
    floorNumberController.clear();
    parkingNumberController.clear();
    plateNumberController.clear();
    userIdController.clear();
    ticketController.clear();
  }

  setCurrentDate() {
    DateTime currentDateTime = DateTime.now();
    String formattedDate = DateFormat.yMMMd().format(currentDateTime);
    String formattedTime = DateFormat.jm().format(currentDateTime);
    _date = formattedDate.toString() + '  ' + formattedTime.toString();
    currentDate = formattedDate.toString();
    currentTime = formattedTime.toString();
    update();
  }

  static int generateRandomId() {
    Random random = Random();
    return random.nextInt(90000) +
        10000; // Generates a random number between 10000 and 99999
  }

  Future<void> registerCaR() async {
    try {
      // progressDialog.show();
      ProgressDialogNew.show(title: 'Car Registration',
        message: "Please Wait...",);
      // ProgressDialogSingleton.getInstance(Get.context!).show();
      bool findLocation = await DataBaseServices()
          .fetchDataForSelectedLocation(userLocation.toString());
      DateTime currentDateTimes = DateTime.now();
      String formattedDate = DateFormat.yMMMd().format(currentDateTimes);
      String formattedTime = DateFormat.jm().format(currentDateTimes);
      _date = '$formattedDate  $formattedTime';
      currentDate = formattedDate.toString();
      currentTime = formattedTime.toString();

      if (findLocation) {
        print('the location is ${logic.userData}');
        CarRegistrationModel model = CarRegistrationModel(
          uniqueId: randomId.toString(),
          carMade: selectedValue!.isNotEmpty
              ? selectedValue.toString() : 'N/A',
          model: modelController.text.isNotEmpty
              ? modelController.text : 'N/A',
          carType: selectedCardTypeValue.toString().isNotEmpty
              ? carTypeController.text : 'N/A',
          color: selectedColorValue.toString().isNotEmpty
              ? selectedColorValue.toString() : 'N/A',
          owner: ownerController.text.toLowerCase().isNotEmpty
              ? ownerController.text.toLowerCase() : 'N/A',
          mobileNumber: mobileNumberController.text.isNotEmpty
              ? mobileNumberController.text : 'N/A',
          recordDamage: recordDamageController.text.isNotEmpty
              ? recordDamageController.text : 'N/A',
          floorNumber: floorNumberController.text.isNotEmpty
              ? floorNumberController.text : 'N/A',
          parkingNumber: parkingNumberController.text.isNotEmpty
              ? parkingNumberController.text : 'N/A',
          plateNumber: plateNumberController.text.toUpperCase().isNotEmpty
              ? plateNumberController.text.toUpperCase() : 'N/A',
          time: currentTime.toString().isNotEmpty
              ? currentTime.toString() : 'N/A',
          date: currentDate.toString().isNotEmpty
              ? currentDate.toString() : 'N/A',
          // Add similar checks for other fields
          images: imageUrls.isNotEmpty ? imageUrls : [''],
          userLocation: userLocation,
          validationUserName: logic.userData['location'].toString(),
          ticket: ticketController.text.toUpperCase(),
          request: false,
          userId: 'none',
          ticketValid: false,
          selectLocation: selectLocation ?? 'N/A',
          totalAmountPerHour: totalAmountPerHour ?? 'N/A',
          selectCharges: selectChargesPaid ?? 'N/A',
          totalAmountTax: totalAmountTax ?? 'N/A',
          amount: amount ?? 'N/A',
          perHour: perHour??'N/A',
          taxCharge: taxCharge??'N/A',
          validationRequestBy: false,
            lobbyRequest:false,
          orderByTime: DateTime.now().millisecondsSinceEpoch,
          driverName: driverNameController.text.isNotEmpty
              ?driverNameController.text.toString().toLowerCase():'N/A',
          paidUnPaid: false,

        );

        // ProgressDialogSingleton.getInstance(Get.context!).show();
        ProgressDialogNew.show(title: 'Car Registration',
          message: "Please Wait...",);
        final response = await DataBaseServices().carRegistration(model.toMap());
        if (response == true) {
          clearController();
          imageUrls.clear();
          // ProgressDialogSingleton.getInstance(Get.context!).dismiss();
          ProgressDialogNew.dismiss();



          Get.snackbar(
            'Car',
            "Car Register Successfully",
            colorText: Colors.black,
            backgroundColor: kPrimary2,
            icon: const Icon(Icons.add_alert),
          );
        }else{

          Get.snackbar(
            'Car',
            "Car with ticket number is already registered",
            colorText: Colors.black,
            backgroundColor: kPrimary2,
            icon: const Icon(Icons.add_alert),
          );
        }
      }
    } catch (e) {
      GetSnackBar(
        title: 'Error',
        message: e.toString(),
      );
      // ProgressDialogSingleton.getInstance(Get.context!).dismiss();
      ProgressDialogNew.dismiss();


    } finally{
      // ProgressDialogSingleton.getInstance(Get.context!).dismiss();
      ProgressDialogNew.dismiss();


    }
  }

  Future<void> scanTicketNumber(BuildContext context) async {
    debugPrint('scanTicketNumber called');
    final ImagePicker imagePicker = ImagePicker();
    try {
      debugPrint('Opening camera...');
      final XFile? image = await imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );

      if (image == null) {
        debugPrint('No image selected.');
        return;
      }

      debugPrint('Image selected: ${image.path}');
      final inputImage = InputImage.fromFilePath(image.path);
      final textRecognizer = TextRecognizer();

      debugPrint('Processing image...');
      final recognizedText = await textRecognizer.processImage(inputImage);

      String numericText = recognizedText.text.replaceAll(RegExp(r'[^0-9]'), '');
      debugPrint('Recognized text: $numericText');

      if (numericText.isNotEmpty) {
        ticketController.text = numericText;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Scanned number: $numericText')),
        );
      } else {
        debugPrint('No numeric text found.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No numeric text found.')),
        );
      }

      debugPrint('Closing text recognizer...');
      await textRecognizer.close();
    } catch (e, stackTrace) {
      debugPrint('Error: $e');
      debugPrint('StackTrace: $stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error scanning text: $e')),
      );
    }
  }

  Future<void> scanPlatNumber(BuildContext context) async {
    final ImagePicker imagePicker = ImagePicker();
    try {
      // Pick an image from the camera
      final XFile? image = await imagePicker.pickImage(source: ImageSource.camera);
      if (image == null) return;

      // Load the text recognition model
      final inputImage = InputImage.fromFilePath(image.path);
      final textRecognizer = TextRecognizer();

      // Process the image
      final recognizedText = await textRecognizer.processImage(inputImage);

      // Extract numeric text
      String numericText = recognizedText.text
          .replaceAll(RegExp(r'[^0-9]'), ''); // Remove non-numeric characters

      // Display the numeric text in the text field
      if (numericText.isNotEmpty) {
        plateNumberController.text = numericText;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Scanned number: $numericText')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No numeric text found.')),
        );
      }

      // Release resources
      textRecognizer.close();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error scanning text: $e')),
      );
    }
  }

  barCodeCall()async{
    String result=await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color for the scan button
      'Cancel', // Text for the cancel button
      true, // Enable continuous scan
      ScanMode.DEFAULT, // Specify the type of code to scan
    );
    if (result.isNotEmpty) {
      plateNumberController.text = result;
    }
    update();
  }
  platBarCodeCall()async{
    String result=await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color for the scan button
      'Cancel', // Text for the cancel button
      true, // Enable continuous scan
      ScanMode.DEFAULT, // Specify the type of code to scan
    );
    if (result.isNotEmpty) {
      ticketController.text = result;

    }
    update();
  }


}





