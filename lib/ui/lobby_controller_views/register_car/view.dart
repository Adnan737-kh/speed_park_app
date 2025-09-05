import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speed_park_app/ui/lobby_controller_views/register_car/upload_image.dart';
import 'package:speed_park_app/ui/super_user_views/create_location/view.dart';
import 'package:speed_park_app/widgets/mytext.dart';
import 'package:speed_park_app/widgets/textformfield.dart';

import '../../../core/constants/colors.dart';
import '../../../widgets/appBar.dart';
import '../../../widgets/elevated_button.dart';
import 'logic.dart';

RegisterCarLogic _logic = Get.put(RegisterCarLogic());
ImageController _image = Get.put(ImageController());

class CarRegistrationView extends StatelessWidget {
  const CarRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    List<TextEditingController> myTControllers = [
      _logic.ticketController,
      _logic.plateNumberController, // Moved Plate Number to the top
      _logic.driverNameController,
      _logic.modelController,
      _logic.mobileNumberController,
      _logic.floorNumberController,
      _logic.parkingNumberController,
    ];

    List registerCar = [
      'Ticket Number',
      'Plate Number',
      'Driver Name',
      'Model',
    ];

    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(text: 'Car Registration'),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: _logic.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  ...List.generate(
                    2,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: MyColorField(
                        validator: registerCar[index] != null
                            ? (value) {
                          if (value!.isEmpty) {
                            return 'This field is required*';
                          }
                          return null;
                        }
                            : null,
                        controller: myTControllers[index],
                        hintText: registerCar[index],
                        onPress: index == 1
                            ? () {
                          _showDialogPlateNumber(context, 'Ticket Number');

                        }
                            : index == 0
                            ? () {
                          _showDialogTicketNumber(context, 'Plat Number');
                        }
                            : null,
                      ),

                    ),
                  ),
                  SizedBox(height: 16.h),
                  DropDownWidget(
                    validator: (value) {
                      if (value == null) {
                        return 'Please select car.';
                      }
                      return null;
                    },
                    selectedValue: _logic.selectedValue,
                    onChanged: (value) {
                      _logic.updateField(value);
                    },
                    dropList: _logic.carMadeList,
                    hintText: 'Car Made',
                  ),
                  GetBuilder<RegisterCarLogic>(
                    init: RegisterCarLogic(),
                    builder: (registerCarLogic) {
                      return _logic.selectedValue == 'Other'
                          ? Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: MyColorField(
                                hintText: 'Enter Manually',
                              ),
                            )
                          : Container();
                    },
                  ),
                  SizedBox(height: 16.h),
                  DropDownWidget(
                    validator: (value) {
                      if (value == null) {
                        return 'Please select Color.';
                      }
                      return null;
                    },
                    selectedValue: _logic.selectedColorValue,
                    onChanged: (value) {
                      _logic.updateColorField(value);
                    },
                    dropList: _logic.colorList,
                    hintText: 'Color',
                  ),
                  SizedBox(height: 16.h),
                  ...List.generate(
                    2,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: MyColorField(
                        validator: () {
                          if (index + 2 == 4 || index + 2 == 4) {
                            return (value) {
                              if (value!.isEmpty) {
                                return 'This field is required*';
                              }
                              return null;
                            };
                          }
                          return null;
                        }(),
                        controller: myTControllers[index + 2],
                        hintText: registerCar[index + 2],
                      ),
                    ),
                  ),
                  MyColorField(
                    controller: _logic.ownerController,
                    hintText: 'Owner',
                    inpuText: _logic.ownerController,
                  ),
                  SizedBox(height: 16.h),
                  MyColorField(
                    controller: _logic.mobileNumberController,
                    hintText: 'Mobile',
                    inpuText: _logic.mobileNumberController,
                  ),
                  SizedBox(height: 16.h),
                  MyColorField(
                    controller: _logic.floorNumberController,
                    hintText: 'Floor No',
                    inpuText: _logic.floorNumberController,
                  ),
                  SizedBox(height: 16.h),
                  MyColorField(
                    controller: _logic.parkingNumberController,
                    hintText: 'Parking Number',
                    inpuText: _logic.parkingNumberController,
                  ),
                  SizedBox(height: 16.h),
                  DropDownWidget(
                    validator: (value) {
                      if (value == null) {
                        return 'Required*';
                      }
                      return null;
                    },
                    selectedValue: _logic.selectedCarDamage,
                    onChanged: (value) {
                      _logic.updateDamage(value);
                    },
                    dropList: _logic.damage,
                    hintText: 'Select Option',
                  ),
                  SizedBox(height: 16.h),
                  GetBuilder<RegisterCarLogic>(
                    builder: (registerCarLogic) {
                      return _logic.selectedCarDamage == 'Type Manually'
                          ? MyColorField(
                              controller: _logic.recordDamageController,
                              hintText: 'Car Damages',
                            )
                          : _logic.selectedCarDamage == 'Upload Images'
                              ? const ImageContainer()
                              : Container();
                    },
                  ),
                  SizedBox(height: Get.height * 0.1),
                  AppButton(
                    text: 'Register Car',
                    onPress: () async {
                      // print('my text ${parkingNumberController.text}');
                      if (_logic.formKey.currentState!.validate()) {
                        if (_image.selectedImages.isNotEmpty) {
                          await Get.find<ImageController>()
                              .uploadImagesToFirebase();
                          _logic.registerCaR();
                        } else {
                          _logic.registerCaR();
                        }
                      } else {
                        const SnackBar(
                          content: MyText(text: 'Please Enter Required Fields'),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _showDialogTicketNumber(BuildContext context, String title) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Choose Option for $title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.qr_code_scanner),
              title: const Text('Scan with Barcode'),
              onTap: () {
                Navigator.of(context).pop(); // Close the dialog
                _logic.platBarCodeCall();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Image'),
              onTap: () {
                Navigator.of(context).pop(); // Close the dialog
                  // Replace with your function for Plat Number image handling
                  _logic.scanPlatNumber(context);

              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}

void _showDialogPlateNumber(BuildContext context, String title) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Choose Option for $title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.qr_code_scanner),
              title: const Text('Scan with Barcode'),
              onTap: () {
                Navigator.of(context).pop(); // Close the dialog
                _logic.barCodeCall();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Image'),
              onTap: () {
                Navigator.of(context).pop(); // Close the dialog
                // Replace with your function for Plat Number image handling
                _logic.scanTicketNumber(context);

              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}



class MyContainer extends StatelessWidget {
  final Color color;
  final Color textClr;
  final String text;
  final double? width;

  MyContainer({super.key,
    this.width,
    required this.color,
    required this.text,
    this.textClr = black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: black.withOpacity(0.4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Center(
        child: MyText(
          text: text,
          color: textClr,
        ),
      ),
    );
  }
}
