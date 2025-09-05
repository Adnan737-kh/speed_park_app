import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speed_park_app/core/constants/colors.dart';
import 'package:speed_park_app/core/model/history/car_history_model.dart';
import '../../../../../widgets/elevated_button.dart';
import 'edit_car_logic.dart';

class CarEditOptionHistory extends StatelessWidget {

  final logic = Get.put(CarEditOptionLogic());
  final state = Get.find<CarEditOptionLogic>().state;
  final String? uid;
  final CarHistoryModel? model;
  final int index;

  CarEditOptionHistory({super.key, required this.uid, this.model,required this.index}) {
    // Initialize the dummy_data list here
    dummyData = [
      '${model?.carMade?.toUpperCase()}',
      '${model?.model?.toUpperCase()}',
      '${model?.carType?.toUpperCase()}',
      '${model?.color?.toUpperCase()}',
      '${model?.owner?.toUpperCase()}',
      '${model?.mobileNumber}',
      '${model?.platNumber?.toUpperCase()}',
      '${model?.parkingNumber?.toUpperCase()}',
      '${model?.floorNumber?.toUpperCase()}',
      '${model?.ticketNumber?.toUpperCase()}',
    ];
  }

  List requestCarList = [
    'Location Type',
    'Car Made',
    'Model',
    'Car Type',
    'Color',
    'Owner',
    'Mobile Number',
    'Plate No.',
    'Parking NO.',
    'Floor NO.',
  ];

  // Inside EditOptionPage, update dummy_data like this:
  List dummyData = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: white,
            ),
          ),
          centerTitle: true,
          title: const Text(
            'Edit Options',
            style: TextStyle(color: white),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: logic.carMadeController,
                          decoration: InputDecoration(
                            labelText: 'Car Made: ${model!.carMade}',
                            border:
                            const OutlineInputBorder(), // Customize the border
                            contentPadding: const EdgeInsets.all(16.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: logic.modelController,
                          decoration: InputDecoration(
                            labelText: 'Model: ${model!.model}',
                            border:
                            const OutlineInputBorder(), // Customize the border
                            contentPadding: const EdgeInsets.all(16.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: logic.carTypeController,
                          decoration: InputDecoration(
                            labelText: 'Car Type: ${model!.carType}',
                            border:
                            const OutlineInputBorder(), // Customize the border
                            contentPadding: const EdgeInsets.all(16.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: logic.colorController,
                          decoration: InputDecoration(
                            labelText: 'Color: ${model!.color}',
                            border:
                            const OutlineInputBorder(), // Customize the border
                            contentPadding: const EdgeInsets.all(16.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: logic.ownerController,
                          decoration: InputDecoration(
                            labelText: 'Owner: ${model!.owner}',
                            border:
                            const OutlineInputBorder(), // Customize the border
                            contentPadding: const EdgeInsets.all(16.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: logic.mobileNumberController,
                          decoration: InputDecoration(
                            labelText: 'Mobile Number: ${model!.mobileNumber}',
                            border:
                            const OutlineInputBorder(), // Customize the border
                            contentPadding: const EdgeInsets.all(16.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: logic.driverNameController,
                          decoration: InputDecoration(
                            labelText: 'Driver Name: ${model!.driverName}',
                            border:
                            const OutlineInputBorder(), // Customize the border
                            contentPadding: const EdgeInsets.all(16.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: logic.plateNoController,
                          decoration: InputDecoration(
                            labelText: 'Plate No: ${model!.platNumber}',
                            border:
                            const OutlineInputBorder(), // Customize the border
                            contentPadding:const EdgeInsets.all(16.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: logic.parkingNoController,
                          decoration: InputDecoration(
                            labelText: 'Parking No: ${model!.parkingNumber}',
                            border:
                            const OutlineInputBorder(), // Customize the border
                            contentPadding: const EdgeInsets.all(16.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: logic.floorNoController,
                          decoration: InputDecoration(
                            labelText: 'Floor No: ${model!.floorNumber}',
                            border:
                            const OutlineInputBorder(), // Customize the border
                            contentPadding: const EdgeInsets.all(16.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: logic.ticketNumberController,
                          decoration: InputDecoration(
                            labelText: 'Ticket No: ${model!.ticketNumber}',
                            border:
                            const OutlineInputBorder(), // Customize the border
                            contentPadding: const EdgeInsets.all(16.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: logic.amountController,
                          decoration: InputDecoration(
                            labelText: 'Amount No: ${model!.amountIncludeTax}',
                            border:
                            const OutlineInputBorder(), // Customize the border
                            contentPadding: const EdgeInsets.all(16.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: logic.registerDateController,
                          decoration: InputDecoration(
                            labelText: 'Reg Date : ${model!.registerDate}',
                            border:
                            const OutlineInputBorder(), // Customize the border
                            contentPadding: const EdgeInsets.all(16.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: logic.registerTimeController,
                          decoration: InputDecoration(
                            labelText: 'Reg Time : ${model!.registerTime}',
                            border:
                            const OutlineInputBorder(), // Customize the border
                            contentPadding: const EdgeInsets.all(16.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // GestureDetector(
              //   onTap: () {
              //     _openImageSourceBottomSheet(context);
              //   },
              //   child: Container(
              //     width: double.infinity,
              //     padding: const EdgeInsets.all(16.0),
              //     margin: const EdgeInsets.all(20),
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(15),
              //       color: kprimary,
              //     ),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         const Icon(
              //           Icons.cloud_upload,
              //           size: 20.0,
              //           color: kwhite,
              //         ),
              //         const SizedBox(height: 8.0),
              //         Text(
              //           'Upload Images',
              //           style: TextStyle(
              //             fontSize: 16.sp,
              //             color: kwhite,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Obx(() => state.imagePaths.isEmpty
              //     ? const SizedBox()
              //     : Container(
              //   padding: const EdgeInsets.all(15),
              //   height: 200,
              //   width: double.maxFinite,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(15),
              //     color: kprimary,
              //   ),
              //   // padding: EdgeInsets.all(15),
              //   child: Wrap(
              //     runSpacing: 10.0,
              //     spacing: 10.0,
              //     children: [
              //       for (String imagePath in state.imagePaths)
              //         Builder(builder: (context) {
              //           return GestureDetector(
              //             onTap: () {
              //               showDialog(
              //                 context: context,
              //                 builder: (BuildContext context) {
              //                   return AlertDialog(
              //                     shape: RoundedRectangleBorder(
              //                       borderRadius:
              //                       BorderRadius.circular(15),
              //                     ),
              //                     title: const Text('Confirm to delete'),
              //                     actions: [
              //                       TextButton(
              //                         onPressed: () {
              //                           Navigator.pop(context);
              //                         },
              //                         child: const Text('cancel'),
              //                       ),
              //                       TextButton(
              //                         onPressed: () {
              //                           logic.removeImage(imagePath);
              //                           Navigator.pop(context);
              //                         },
              //                         child: const Text(
              //                           'Confirm',
              //                           style:
              //                           TextStyle(color: Colors.red),
              //                         ),
              //                       ),
              //                     ],
              //                   );
              //                 },
              //               );
              //             },
              //             child: Image.file(
              //               File(imagePath),
              //               width: 50.h,
              //               height: 50.h,
              //               fit: BoxFit.cover,
              //             ),
              //           );
              //         }),
              //     ],
              //   ),
              // )),
              SizedBox(height: Get.height / 9),
              AppButton(
                text: 'Update',
                onPress: () async {
                  await logic.updateCarInHistoryFirebase(uid.toString(), model);
                },
              ),
              SizedBox(height: 16.h),
              AppButton(
                bgColor: white,
                bdColor: kPrimary,
                textColor: kPrimary,
                text: 'Back',
                onPress: () {
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to open the bottom sheet for image source selection
  void _openImageSourceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Take a photo'),
              onTap: () async {
                Get.back(); // Close the bottom sheet
                final image =
                await ImagePicker().pickImage(source: ImageSource.camera);
                if (image != null) {
                  logic.addImage(image.path);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Choose from gallery'),
              onTap: () async {
                Get.back(); // Close the bottom sheet
                final image = await ImagePicker()
                    .pickImage(source: ImageSource.gallery);
                if (image != null) {
                  logic.addImage(image.path);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
