import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speed_park_app/core/constants/colors.dart';
import 'package:speed_park_app/core/utils/utils.dart';
import 'package:speed_park_app/widgets/mytext.dart';

import '../../../core/constants/styles.dart';
import '../../../core/model/history/car_history_model.dart';
import '../../../widgets/appBar.dart';
import 'logic.dart';

class CarInfo {
  final String plateNo;
  final String registrationDate;
  final String deliveryDate;

  CarInfo({
    required this.plateNo,
    required this.registrationDate,
    required this.deliveryDate,
  });
}

class ReceiveACarPage extends StatelessWidget {
  final logic = Get.put(ReceiveACarLogic());
  final state = Get.find<ReceiveACarLogic>().state;

  List<CarInfo> carList = [
    CarInfo(
      plateNo: 'ABC123',
      registrationDate: '2023-08-29',
      deliveryDate: '2023-08-30',
    ),
    // Add more car information here
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: appBarWidget(text: 'History'),
          body: Obx(() {
            return logic.car.isEmpty
                ? Center(
                    child: Text(
                      'No Car History',
                      style: normalTextStyle,
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20.h),
                        Expanded(
                            child: ListView.builder(
                          itemCount: logic.car.length,
                          itemBuilder: (context, index) {
                            return CarInfoCard(
                              carInfo: logic.car[index],
                            );
                          },
                        )),
                      ],
                    ),
                  );
          })),
    );
  }
}

class CarInfoCard extends StatelessWidget {
  final logic = Get.put(ReceiveACarLogic());
  final CarHistoryModel carInfo;

  CarInfoCard({required this.carInfo});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Utils.showCarHistoryDetails(context, carInfo);
      },
      child: Container(
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
        margin:const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Padding(
          padding:const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    text: 'Plate No: ${carInfo.platNumber}',
                    size: 16.sp,
                    weight: FontWeight.bold,
                    color: white,
                  ),
                  GestureDetector(
                    onTap: (){
                     logic.deleteHistory(uid: carInfo.uid.toString());
                    },
                    child:const Icon(Icons.delete,color: Colors.red,),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              MyText(
                text: 'Registered: ${carInfo.registerDate} ${carInfo.registerTime}',
                size: 14.sp,
                color: white,
              ),
              const  SizedBox(height: 5),
              MyText(
                text: 'Delivered: ${carInfo.deliveredDate} ${carInfo.deliveredTime}',
                size: 14.sp,
                color: white,
              ),
              const SizedBox(height: 5),
               MyText(
                text: 'Location Type: ${carInfo.locationTypeCheck=='Paid'?carInfo.locationTypeCheck:'Normal'}',
                size: 14.sp,
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
                      size: 14.sp,
                      color: white,
                    ),
                    // SizedBox(height: 5),
                    // MyText(
                    //   text: 'Amount: ${carInfo.amount_include_tax} AED',
                    //   size: 14.sp,
                    //   color: kwhite,
                    // ),
                    // SizedBox(height: 5),
                    // carInfo.select_charges == 'Per hour'
                    //     ? MyText(
                    //   text: 'Additional Hour Charges: ${carInfo.perhour} AED',
                    //   size: 14.sp,
                    //   color: kwhite,
                    // )
                    //     : Container(),
                    // SizedBox(height: 5),
                    // carInfo.taxCharge != 'Tax Inclusive'
                    //     ? MyText(
                    //   text: 'Tax: 5%',
                    //   size: 14.sp,
                    //   color: kwhite,
                    // )
                    //     : MyText(
                    //   text: 'Tax: Tax Exclusive',
                    //   size: 14.sp,
                    //   color: kwhite,
                    // ),
                    const SizedBox(height: 5),
                    MyText(
                      text: 'Total Charges: ${carInfo.amountIncludeTax} AED',
                      size: 14.sp,
                      color: white,
                    ),
                  ],
                ),
              )


            ],
          ),
        ),
      ),
    );
  }
}
