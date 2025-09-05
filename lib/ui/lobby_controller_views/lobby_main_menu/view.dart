import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speed_park_app/widgets/mytext.dart';

import '../../../core/constants/colors.dart';
import '../../../role_selection_view.dart';
import '../../super_user_views/create_report/report_generate/generate_report_from_filter_day/logic.dart';
import '../car_in_parking/view.dart';
import '../confirm_request/view.dart';
import '../create_card/CreateCard.dart';
import '../delivery_report/view.dart';
import '../receive_a_car/view.dart';
import '../register_car/view.dart';
import '../sales_report/filtrt_report.dart';
import '../sales_report/sales_report.dart';
import 'logic.dart';

class LobbyMainMenuPage extends StatelessWidget {

  final GenerateReportFromFilterLogicDay dataList = GenerateReportFromFilterLogicDay();
  final logic = Get.put(LobbyMainMenuLogic());
  final state = Get.find<LobbyMainMenuLogic>().state;

  final List<Map<String, dynamic>> btnNames = [
    {
      'text': 'Register A Car',
      'image': 'assets/requestACar.png',
      'pages': const CarRegistrationView(),
    },
    {
      'text': 'Car in Parking',
      'image': 'assets/parking.png',
      'pages': CarInParkingPage(),
    },
    {
      'text': 'History',
      'image': 'assets/car.png',
      'pages': ReceiveACarPage(),
    },
    {
      'text': 'Confirm Request',
      'image': 'assets/checked.png',
      'pages': ConfirmRequestPage(),
    },
    {
      'text': 'Delivery Report',
      'image': 'assets/checklist.png',
      'pages': DeliveryReportPage(),
    },

    {
      'text': 'Sales Report',
      'image': 'assets/checklist.png',
      'pages': GenerateSalesReport(),
    },

    {
      'text': 'Create Card',
      'image': 'assets/checklist.png',
      'pages':  PVCGenerator(),
    },
    {
      'text': 'Log Out',
      'image': 'assets/logout.png',
      'pages': RoleSelectionView(),
    },

  ];

  LobbyMainMenuPage({super.key});



  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(logic.getRequestLength);
      print(logic.getCarParkingLength);
    }
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kButton2,
              black,
            ],
          ),
          image: DecorationImage(
            opacity: 0.2,
            fit: BoxFit.cover,
            image: AssetImage('assets/peakpx (2).jpg'),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          text: 'Lobby Controller',
                          size: 18.sp,
                          weight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: white,
                        ),
                        Icon(
                          Icons.dashboard,
                          size: 20.sp,
                          color: white,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: Get.height / Get.width / 2.5,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      children: [
                        ...List.generate(
                          btnNames.length,
                              (index) =>
                              GestureDetector(
                                onTap: () {
                                  if (index == 7) {
                                    Get.off(() => RoleSelectionView());
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return btnNames[index]['pages'];
                                        },
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 16),
                                  height: Get.height * 0.45,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),

                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        kPrimary2,
                                        kButton,
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Spacer(),
                                      Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Image.asset(
                                            btnNames[index]['image'],
                                            color: white,
                                            height: Get.height / 20,
                                          ),
                                          index == 3 ? Obx(() {
                                            return Positioned(
                                              right: -5,
                                              top: -5,
                                              child: CircleAvatar(
                                                radius: 10,
                                                backgroundColor: Colors.red,
                                                child: MyText(text: '${logic.getRequestLength}',
                                                  size: 10,
                                                  color: white,
                                                ),
                                              ),
                                            );
                                          })
                                              : const SizedBox(
                                            height: 0,
                                            width: 0,
                                          ),

                                          index == 1
                                              ? Obx(() {
                                            return Positioned(
                                              right: -5,
                                              top: -5,
                                              child: CircleAvatar(
                                                radius: 10,
                                                backgroundColor: Colors.red,
                                                child: MyText(
                                                  text:
                                                  '${logic.getCarParkingLength}',
                                                  size: 10,
                                                  color: white,
                                                ),
                                              ),
                                            );
                                          })
                                              : const SizedBox(
                                            height: 0,
                                            width: 0,
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 10.h),
                                      MyText(
                                        text: btnNames[index]['text'],
                                        color: white,
                                        size: 16.sp,
                                      ),
                                      const Spacer(),
                                      Container(
                                        width: Get.width,
                                        padding: const EdgeInsets.only(left: 25),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            // topLeft: Radius.circular(45),
                                            bottomRight: Radius.circular(45),
                                            bottomLeft: Radius.circular(45),
                                          ),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black.withOpacity(0.4),
                                              black,
                                            ],
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            MyText(
                                              text: 'Details',
                                              color: white,
                                              size: 14.sp,
                                            ),
                                            Container(
                                              height: 40,
                                              width: 65,
                                              decoration: const BoxDecoration(
                                                color: white,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(45),
                                                  bottomRight: Radius.circular(
                                                      45),
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.arrow_forward_outlined,
                                                color: kButton2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
