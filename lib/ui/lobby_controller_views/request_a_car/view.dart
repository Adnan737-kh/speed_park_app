import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speed_park_app/widgets/appBar.dart';
import 'package:speed_park_app/widgets/elevated_button.dart';
import 'package:speed_park_app/widgets/mytext.dart';

import '../../../core/constants/colors.dart';
import '../../../core/model/register_car/car_registration.dart';
import 'logic.dart';

class RequestACarPage extends StatelessWidget {
  RequestACarPage({super.key, this.model, this.index});
  final logic = Get.put(RequestACarLogic());
  final state = Get.find<RequestACarLogic>().state;

  final CarRegistrationModel? model;
  final int? index;
  @override
  Widget build(BuildContext context) {
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
      'Date',
      'Time',
      'REQ BY:',
    ];
    List dummyData = [
      '${model!.selectLocation?.toUpperCase()}',
      '${model!.carMade?.toUpperCase()}',
      '${model!.model?.toUpperCase()}',
      '${model!.carType?.toUpperCase()}',
      '${model!.color?.toUpperCase()}',
      '${model!.owner?.toUpperCase()}',
      '${model!.mobileNumber}',
      '${model!.plateNumber?.toUpperCase()}',
      '${model!.parkingNumber?.toUpperCase()}',
      '${model!.floorNumber?.toUpperCase()}',
      '${model!.date?.toUpperCase()}',
      '${model!.time?.toUpperCase()}',
      '',
    ];
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(text: 'Request A Car'),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...List.generate(
                          requestCarList.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: MyText(
                              text: requestCarList[index],
                              size: 14.sp,
                              weight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ...List.generate(
                          dummyData.length,
                          (index) => index == dummyData.length - 1
                              ? const SizedBox(width: 150, child: TextField())
                              : Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: MyText(
                                    text: dummyData[index],
                                    size: 14.sp,
                                    weight: FontWeight.bold,
                                    color: kPrimary,
                                  ),
                                ),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                model!.images!.isEmpty
                    ? const Center(
                        child: Text('No Images'),
                      )
                    : SizedBox(
                        height: Get.height * model!.images!.length / 15,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: model!.images!.length +
                              1, // Add 1 for the loading indicator
                          itemBuilder: (context, index) {
                            if (index < model!.images!.length) {
                              // Display the image using CachedNetworkImage
                              return Wrap(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: model!.images![index],
                                        height: Get.height * 0.133,
                                        width: Get.height * 0.13,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) {
                                          if (kDebugMode) {
                                            print(url);
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
                                width: 100, // Adjust the width as needed
                              );
                            }
                          },
                        ),
                      ),
                SizedBox(height: Get.height * 0.095),
                AppButton(
                  text: 'Request A Car',
                  onPress: () async {
                    await logic.carRequestToConfirm(
                      context: context,
                      response: true,
                      uid: model!.uid.toString(),
                      index: index,
                      platNumber: model!.plateNumber,
                      registerCarTime: model!.time,
                      registerCarDate: model!.date,
                      locationTypeCheck: model!.selectLocation,
                      selectCharges: model?.selectCharges,
                      taxInclude: model?.totalAmountTax,
                      amountIncludeTax: model?.amount,
                      perHour: model?.perHour,
                      taxCharge:model?.taxCharge,
                      userLocation: model?.userLocation,
                      carMade: model?.carMade,
                      carModel: model?.model,
                      carType: model?.carType,
                      color: model?.color,
                      owner: model?.owner,
                      mobileNumber: model?.mobileNumber,
                      recordDamage: model?.recordDamage,
                      floorNumber: model?.floorNumber,
                      parkingNumber: model?.parkingNumber,
                      images: model?.images,
                      payment: model,
                      driverName: model?.driverName,
                    );
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
      ),
    );
  }

  final OutlineInputBorder tBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(
      color: Colors.transparent,
    ),
  );
}
