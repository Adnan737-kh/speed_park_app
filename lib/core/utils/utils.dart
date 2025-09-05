import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../ui/lobby_controller_views/register_car/logic.dart';
import '../../widgets/mytext.dart';
import '../constants/colors.dart';
import '../model/history/car_history_model.dart';

final _carLogic = Get.put(RegisterCarLogic());

abstract class Utils {
  static Future<ImageSource?> imagePickOptions(BuildContext context) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: const Text('Select Image Source'),
          cancelButton: CupertinoActionSheetAction(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.pop(context); // Close the bottom sheet
            },
          ),
          actions: [
            CupertinoActionSheetAction(
              child: const Text('Camera'),
              onPressed: () {
                // _controller.pickImageFromGallery();
                // debugPrint('Hello camera request');
                // final ImagePicker picker = ImagePicker();
                // Navigator.pop(
                //   context,
                //   picker.pickImage(source: ImageSource.camera),
                // );
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Gallery'),
              onPressed: () {
                // _controller.takeImageWithCamera();
                // final ImagePicker picker = ImagePicker();
                // Navigator.pop(
                //   context,
                //   picker.pickImage(source: ImageSource.gallery),
                // );
              },
            ),
          ],
        );
      },
    );
  }

  static showCarRegisterDetails(BuildContext context, int length,
      {String? title, String? desc}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$title'),
          content: Text('$desc $length'), // Replace with your actual data
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static showCarHistoryDetails(BuildContext context, CarHistoryModel carInfo) {
    return showDialog(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: kPrimary,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: kPrimary.withOpacity(0.4),
                blurRadius: 10,
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        text: 'Car Details',
                        size: 20.sp,
                        weight: FontWeight.bold,
                        color: white,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  MyText(
                    text: 'Plate No: ${carInfo.platNumber}',
                    size: 16.sp,
                    weight: FontWeight.bold,
                    color: white,
                  ),
                  const   SizedBox(height: 5),
                  MyText(
                    text: 'Car Made: ${carInfo.carMade}',
                    size: 16.sp,
                    weight: FontWeight.bold,
                    color: white,
                  ),
                  const SizedBox(height: 5),
                  MyText(
                    text: 'Car Type: ${carInfo.carType}',
                    size: 16.sp,
                    weight: FontWeight.bold,
                    color: white,
                  ),
                  const  SizedBox(height: 5),
                  MyText(
                    text: 'Color: ${carInfo.color}',
                    size: 16.sp,
                    weight: FontWeight.bold,
                    color: white,
                  ),
                  const SizedBox(height: 5),
                  MyText(
                    text: 'Model: ${carInfo.model}',
                    size: 16.sp,
                    weight: FontWeight.bold,
                    color: white,
                  ),
                  const SizedBox(height: 5),
                  MyText(
                    text: 'Floor Number: ${carInfo.floorNumber}',
                    size: 16.sp,
                    weight: FontWeight.bold,
                    color: white,
                  ),
                  const SizedBox(height: 5),
                  MyText(
                    text: 'Parking Number: ${carInfo.parkingNumber}',
                    size: 16.sp,
                    weight: FontWeight.bold,
                    color: white,
                  ),
                  const SizedBox(height: 5),
                  MyText(
                    text: 'Mobile Number: ${carInfo.mobileNumber}',
                    size: 16.sp,
                    weight: FontWeight.bold,
                    color: white,
                  ),
                  const  SizedBox(height: 10),
                  MyText(
                    text: 'Owner: ${carInfo.owner}',
                    size: 16.sp,
                    weight: FontWeight.bold,
                    color: white,
                  ),
                  const SizedBox(height: 5),
                  MyText(
                    text:
                        'Registered: ${carInfo.registerDate} ${carInfo.registerTime}',
                    size: 16.sp,
                    weight: FontWeight.bold,
                    color: white,
                  ),
                  const SizedBox(height: 5),
                  MyText(
                    text:
                        'Delivered: ${carInfo.deliveredDate} ${carInfo.deliveredTime}',
                    size: 16.sp,
                    weight: FontWeight.bold,
                    color: white,
                  ),
                  const SizedBox(height: 5),
                  MyText(
                    text:
                        'Location Type: ${carInfo.locationTypeCheck == 'Paid' ? carInfo.locationTypeCheck : 'Normal'}',
                    size: 16.sp,
                    weight: FontWeight.bold,
                    color: white,
                  ),
                  Visibility(
                    visible: carInfo.locationTypeCheck == 'Paid',
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        MyText(
                          text: 'Select Charges: ${carInfo.selectCharges}',
                          size: 16.sp,
                          weight: FontWeight.bold,
                          color: white,
                        ),
                        const  SizedBox(height: 5),
                        MyText(
                          text: 'Amount: ${carInfo.amountIncludeTax} AED',
                          size: 16.sp,
                          weight: FontWeight.bold,
                          color: white,
                        ),
                        const SizedBox(height: 5),
                        carInfo.selectCharges == 'Per hour'
                            ? MyText(
                                text:
                                    'Additional Hour Charges: ${carInfo.perHour} AED',
                                size: 16.sp,
                                weight: FontWeight.bold,
                                color: white,
                              )
                            : Container(),
                        const SizedBox(height: 5),
                        carInfo.taxCharge == 'Tax Inclusive'
                            ? MyText(
                                text: 'Tax: 5%',
                                size: 16.sp,
                                weight: FontWeight.bold,
                                color: white,
                              )
                            : MyText(
                                text: 'Tax: N/A',
                                size: 16.sp,
                                weight: FontWeight.bold,
                                color: white,
                              ),
                        const SizedBox(height: 5),
                        MyText(
                          text: 'Total Charges: ${carInfo.taxInclude} AED',
                          size: 16.sp,
                          weight: FontWeight.bold,
                          color: white,
                        ),
                        const SizedBox(height: 5),
                        MyText(
                          text: 'Images:',
                          size: 16.sp,
                          weight: FontWeight.bold,
                          color: white,
                        ),
                        const SizedBox(height: 5),
                        carInfo.images!.isEmpty
                            ? const Center(
                                child: Text('No Images'),
                              )
                            : SizedBox(
                                height:
                                    Get.height * carInfo.images!.length / 15,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: carInfo.images!.length +
                                      1, // Add 1 for the loading indicator
                                  itemBuilder: (context, index) {
                                    if (index < carInfo.images!.length) {
                                      // Display the image using CachedNetworkImage
                                      return Wrap(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    carInfo.images![index],
                                                height: Get.height * 0.133,
                                                width: Get.height * 0.13,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) {
                                                  if (kDebugMode) {
                                                    print(url);
                                                  }
                                                  if (kDebugMode) {
                                                    print(error);
                                                  }
                                                  return const Icon(Icons.error);
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      // Display an empty container as a placeholder for the loading indicator
                                      return Container(
                                        width:
                                            100, // Adjust the width as needed
                                      );
                                    }
                                  },
                                ),
                              ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static showQRCodeAndBarcodeScannerDialog(BuildContext context) {
    String result = '';

    Future<void> scanAndShowDialog() async {
      result = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Color for the scan button
        'Cancel', // Text for the cancel button
        true, // Enable continuous scan
        ScanMode.DEFAULT, // Specify the type of code to scan
      );

      // Update scannedValue here
      _carLogic.updateScannedValue(result);

      // Show the dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Scan QR Code or Barcode'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_carLogic.scannedValue != null &&
                    _carLogic.scannedValue.value.isNotEmpty)
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(
                        text: _carLogic.scannedValue.value),
                    decoration:
                        const InputDecoration(labelText: 'Scanned Value'),
                  )
                else
                  const Text('No find'),
                const SizedBox(height: 10),
                GetBuilder<RegisterCarLogic>(
                  assignId: true,
                  builder: (logic) {
                    if (kDebugMode) {
                      print("Scanned Value: ${_carLogic.scannedValue.value}");
                    }
                    return ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop(); // Close the current dialog
                        scanAndShowDialog(); // Open a new dialog for the next scan
                      },
                      child: const Text('Scan QR Code or Barcode'),
                    );
                  },
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Implement your save logic here if needed
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
              TextButton(
                onPressed: () {
                  result = '';
                  _carLogic.updateScannedValue('');
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    }

    // Initially, trigger the scan and show dialog
    scanAndShowDialog();
  }
}
