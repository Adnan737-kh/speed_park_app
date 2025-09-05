import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndialog/ndialog.dart';

import '../../../core/constants/colors.dart';
import '../../../core/services/database.dart';
import '../../../widgets/mytext.dart';
import '../../guest_views/guest_home_view/logic.dart';
import '../validation_login/logic.dart';
import 'state.dart';

ProgressDialog progressDailog = ProgressDialog(
  Get.context!,
  blur: 10,
  title: const Text("Ticket Validation"),
  message: const Text("Please Wait"),
  onDismiss: () {
    if (kDebugMode) {
      debugPrint("Do something onDismiss");
    }
  },
);

class TicketValidationLogic extends GetxController {
  final TicketValidationState state = TicketValidationState();
  TextEditingController ticketNumberController = TextEditingController();
  TextEditingController validationCenterController = TextEditingController();
  final logic = Get.put(ValidationLoginLogic());

  TextEditingController searchController = TextEditingController();
  bool isTextFieldEmpty = true;

  final DataBaseServices _repository = DataBaseServices();

  barCodeCall() async {
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




  // checkTicketNumber(
  //   BuildContext context,
  // ) async {
  //   try {
  //     if (ticketNumberController.text.isNotEmpty) {
  //       progressDailog.show();
  //
  //       final response = await _repository
  //           .ticketValidRequest(ticketNumberController.text.toString(),
  //           logic.validationUserData['location']);
  //       if (response) {
  //         progressDailog.dismiss();
  //
  //         showDialogBox(true, context, ticketNumberController.text.toString());
  //       } else {
  //         progressDailog.dismiss();
  //         showDialogBox(false, context,
  //             ticketNumberController.text.toString());
  //       }
  //     } else {
  //       Get.snackbar('Error', 'Ticket number are required');
  //     }
  //   } catch (e) {
  //     GetSnackBar(
  //       title: 'Error',
  //       message: e.toString(),
  //     );
  //     pd.dismiss();
  //   }
  //   update();
  // }

  checkTicketNumber(BuildContext context) async {
    try {
      if (ticketNumberController.text.isNotEmpty) {
        progressDailog.show();

        final isValid = await _repository.ticketValidRequest(
          ticketNumberController.text.trim(),
          logic.validationUserData['location'],
        );

        progressDailog.dismiss();

        showDialogBox(isValid, context, ticketNumberController.text.trim());
      } else {
        Get.snackbar('Error', 'Ticket number is required');
      }
    } catch (e) {
      progressDailog.dismiss();
      Get.snackbar('Error', e.toString());
    }
  }



  checkPlatNumber(BuildContext context, String ticket) async {
    try {
      pd.show();
      final response = await _repository.validationRequest(ticket, 'no');
      if (response) {
        pd.dismiss();
        showDialogBoxSecond(
            'Request Confirmation', 'Your car with $ticket ''number  has been requested.', context);
      } else {
        final request =
            await _repository.againValidationRequest(ticket, 'no');
        if (request) {
          pd.dismiss();

          showDialogBoxSecond(
            'Car ', 'The Car with this Ticket number $ticket has already Requested', context,
          );
        } else {
          pd.dismiss();
          showDialogBoxSecond(
              'Sorry', 'Your car with Ticket number $ticket ''has not registered.', context);
        }
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

  showDialogBoxSecond(
    String title,
    String desc,
    BuildContext context,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                ticketNumberController.clear();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // showDialogBox(bool response, BuildContext context, String carPlatNumber) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //         title: MyText(
  //           text: response == true ? 'Ticket' : 'Sorry',
  //           color: kprimary,
  //           size: 18.sp,
  //         ),
  //         content: Text(response == true
  //             ? 'Ticket $carPlatNumber Validation Successfully Done'
  //             : 'This $carPlatNumber is Invalid Please Enter Valid Ticket '),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('OK'),
  //             onPressed: () {
  //               pd.dismiss();
  //               ticketNumberController.clear();
  //               Navigator.of(context).pop();
  //
  //               // Clear the car plate number field after requesting
  //               carPlatNumber = "";
  //             },
  //           ),
  //           response == true
  //               ? TextButton(
  //                   child: const Text('Request Car'),
  //                   onPressed: () {
  //                     pd.dismiss();
  //
  //                     // Clear the car plate number field after requesting
  //                     carPlatNumber = "";
  //                     checkPlatNumber(context, ticketNumberController.text);
  //                   },
  //                 )
  //               : Container(),
  //         ],
  //       );
  //     },
  //   );
  // }

  showDialogBox(bool isValid, BuildContext context, String carPlatNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: MyText(
            text: isValid ? 'Ticket' : 'Sorry',
            color: kPrimary,
            size: 18.sp,
          ),
          content: Text(
            isValid
                ? 'Ticket $carPlatNumber validation successful.'
                : 'Ticket $carPlatNumber is invalid. Please enter a valid ticket.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                ticketNumberController.clear();
                Navigator.of(context).pop();
              },
            ),
            if (isValid)
              TextButton(
                child: const Text('Request Car'),
                onPressed: () {
                  Navigator.of(context).pop(); // close dialog
                  checkPlatNumber(context, carPlatNumber); // send car request
                },
              ),
          ],
        );
      },
    );
  }

}
