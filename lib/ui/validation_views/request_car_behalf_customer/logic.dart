import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/colors.dart';
import '../../../core/services/database.dart';
import '../../../widgets/mytext.dart';
import '../../guest_views/guest_home_view/logic.dart';
import 'state.dart';

class RequestCarBehalfCustomerLogic extends GetxController {
  final RequestCarBehalfCustomerState state = RequestCarBehalfCustomerState();
  TextEditingController ticketNumberController = TextEditingController();
  TextEditingController plateNumberController = TextEditingController();
  String requestResult = '';

  final DataBaseServices _repository = DataBaseServices();

  checkPlatNumber(BuildContext context) async {
    try {
      if (plateNumberController.text.isNotEmpty ||
          ticketNumberController.text.isNotEmpty) {
        pd.show();
        final response = await _repository.validationRequest(
            ticketNumberController.text.isNotEmpty
                ? ticketNumberController.text.toString()
                : 'no',
            plateNumberController.text.isNotEmpty
                ? plateNumberController.text.toString().toUpperCase()
                : 'no');
        if (response) {
          pd.dismiss();
          showDialogBox(
              'Request Confirmation',
              'Your car with'
                  ' ${ticketNumberController.text.isNotEmpty ? 'Ticket' : 'Plate'} number '
                  ' ${plateNumberController.text.isNotEmpty
                  ? plateNumberController.text.toString()
                  : ticketNumberController.text.toString()} has been requested.', context);
          plateNumberController.text.isNotEmpty
              ? plateNumberController.clear()
              : null;
          ticketNumberController.text.isNotEmpty
              ? ticketNumberController.clear()
              : null;
        } else {
          final request = await _repository.againValidationRequest(
              ticketNumberController.text.isNotEmpty
                  ? ticketNumberController.text.toString()
                  : 'no',
              plateNumberController.text.isNotEmpty
                  ? plateNumberController.text.toString().toUpperCase()
                  : 'no');
          if (request) {
            pd.dismiss();

            showDialogBox(
              'Car ',
              'The Car with this ${plateNumberController.text.isNotEmpty
                  ? plateNumberController.text.toString()
                  : ticketNumberController.text.toString()} number has already Requested', context);
            plateNumberController.text.isNotEmpty
                ? plateNumberController.clear()
                : null;
            ticketNumberController.text.isNotEmpty
                ? ticketNumberController.clear()
                : null;
          } else {
            pd.dismiss();
            showDialogBox(
                'Sorry',
                'Your car with ${ticketNumberController.text.isNotEmpty
                    ? 'Ticket' : 'Plate'} number ${plateNumberController.text.isNotEmpty
                    ? plateNumberController.text.toString()
                    : ticketNumberController.text.toString()} has not registered.', context);
            plateNumberController.text.isNotEmpty
                ? plateNumberController.clear()
                : null;
            ticketNumberController.text.isNotEmpty
                ? ticketNumberController.clear()
                : null;
          }
        }
      } else {
        Get.snackbar('Error', 'All Field are required');
      }
    } catch (e) {
      GetSnackBar(
        title: 'Error',
        message: e.toString(),
      );
      pd.dismiss();
    }
    update();
  }

  showDialogBox(
    String title,
    String desc,
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: MyText(
            text: title,
            color: kPrimary,
            size: 18.sp,
          ),
          content: Text(desc),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                pd.dismiss();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> takeImageTicketNumber(BuildContext context) async {
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

      String numericText =
          recognizedText.text.replaceAll(RegExp(r'[^0-9]'), '');
      debugPrint('Recognized text: $numericText');

      if (numericText.isNotEmpty) {
        ticketNumberController.text = numericText;
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

  Future<void> takeImagePlatNumber(BuildContext context) async {
    final ImagePicker imagePicker = ImagePicker();
    try {
      // Pick an image from the camera
      final XFile? image =
          await imagePicker.pickImage(source: ImageSource.camera);
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

  plateBarCodeScan() async {
    String result = await FlutterBarcodeScanner.scanBarcode(
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

  ticketBarCodeScan() async {
    String result = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color for the scan button
      'Cancel', // Text for the cancel button
      true, // Enable continuous scan
      ScanMode.DEFAULT, // Specify the type of code to scan
    );
    if (result.isNotEmpty) {
      ticketNumberController.text = result;
    }
    update();
  }
}
