import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/colors.dart';
import '../../../widgets/mytext.dart';
import '../../lobby_controller_views/non_paid_location/view.dart';
import '../reporting_view/view.dart';
import '../request_car_behalf_customer/view.dart';
import '../ticket_validation/view.dart';
import 'logic.dart';

class ValidationMainMenuViewPage extends StatelessWidget {
  final logic = Get.put(Validation_main_menu_viewLogic());
  final state = Get.find<Validation_main_menu_viewLogic>().state;

   ValidationMainMenuViewPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          body: Column(
            children: [
              Container(
                // height: 80.h,
                margin: const EdgeInsets.only(top: 16),
                padding:const  EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: 'Validation Centre',
                      size: 18.sp,
                      weight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: white,
                    ),
                    Icon(
                      Icons.security,
                      size: 20.sp,
                      color: white,
                    ),
                  ],
                ),
              ),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                padding:const  EdgeInsets.all(20),
                children: [
                  _buildValidationOption(
                      context, 'Validate Ticket', Icons.confirmation_num),
                  _buildValidationOption(
                      context, 'Request Car', Icons.directions_car),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValidationOption(
      BuildContext context, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        if (title == 'Validate Ticket') {
          Get.to(() => TicketValidationPage());
        } else if (title == 'Request Car') {
          Get.to(() => RequestCarBehalfCustomerPage());
        } else if (title == 'Report Visits') {
          Get.to(() => ReportingViewPage());
        } else if (title == 'Non-Paid/Free Service Location') {
          Get.to(() => NonPaidLocationPage());
        }
        // Add more action logic here
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient:const  LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kPrimary2,
              kButton,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Icon(
                icon,
                size: 50,
                color: white,
              ),
              const  SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style:const  TextStyle(fontSize: 16, color: white),
              ),
              const Spacer(),
              Container(
                width: Get.width,
                padding:const  EdgeInsets.only(left: 25),
                decoration: BoxDecoration(
                  borderRadius:const  BorderRadius.only(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: 'Details',
                      color: white,
                      size: 14.sp,
                    ),
                    Container(
                      height: 40,
                      width: 65,
                      decoration:const  BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(45),
                          bottomRight: Radius.circular(45),
                        ),
                      ),
                      child:const  Icon(
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
    );
  }
}
