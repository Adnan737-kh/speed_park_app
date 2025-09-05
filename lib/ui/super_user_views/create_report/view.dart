import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speed_park_app/ui/super_user_views/create_report/report_generate/generate_report_from_filter/view.dart';
import 'package:speed_park_app/ui/super_user_views/create_report/report_generate/generate_report_from_filter_day/view.dart';
import 'package:speed_park_app/ui/super_user_views/create_report/report_generate/generate_report_from_filter_driver_monthly/view.dart';
import 'package:speed_park_app/ui/super_user_views/create_report/report_generate/generate_report_from_filter_driver_name/view.dart';

import '../../../core/constants/colors.dart';
import '../../../widgets/mytext.dart';
import '../../lobby_controller_views/register_car/view.dart';
import 'logic.dart';

class CreateReportPage extends StatelessWidget {
  final logic = Get.put(CreateReportLogic());
  final state = Get.find<CreateReportLogic>().state;
  var reportBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: kPrimary.withOpacity(0.5),
    ),
    borderRadius: BorderRadius.circular(15),
  );
  List<Map<String, dynamic>> btnNames = [
    {
      'text': 'Monthly Report',
      'image': 'assets/report.png',
      'pages': const CarRegistrationView(),
    },
    {
      'text': 'Day Report',
      'image': 'assets/report.png',
      'pages': const CarRegistrationView(),
    },
    {
      'text': 'Driver Report',
      'image': 'assets/report.png',
      'pages': const CarRegistrationView(),
    },
    {
      'text': 'Driver Monthly Report',
      'image': 'assets/report.png',
      'pages': const CarRegistrationView(),
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: Get.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 16.h),
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
                          (index) => GestureDetector(
                            onTap: () {
                              switch (index) {
                                case 0:
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return GenerateReportFromFilterPage();}));
                                  break;
                                case 1:
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return GenerateReportFromFilterPageDay();}));
                                  break;
                                case 2:
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Generate_report_from_filterPage_driver_name();}));
                                  break;
                                case 3:
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Generate_report_from_filterPage_driver_Monthly();}));
                                  break;
                                default:
                                  // Handle other cases if needed
                                  break;
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
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Center(
                                    child: MyText(
                                      text: btnNames[index]['text'],
                                      color: white,
                                      size: 12.sp,
                                    ),
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
                                              bottomRight: Radius.circular(45),
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
