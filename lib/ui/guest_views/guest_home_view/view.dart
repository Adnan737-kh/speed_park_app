import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speed_park_app/widgets/elevated_button.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../../../widgets/mytext.dart';
import 'logic.dart';

class GuestHomeViewPage extends StatelessWidget {
  final logic = Get.put(GuestHomeViewLogic());
  final state = Get.find<GuestHomeViewLogic>().state;

  String carPlateNumber = "";
  String carTicketNumber = "";

  GuestHomeViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0xffD28CF9),
                  Color(0xffE6AEE8),
                ],
              ),
            ),
          ),
          centerTitle: true,
          title: MyText(
            text: 'Car Request',
            color: white,
            size: 16.sp,
            weight: FontWeight.bold,
          ),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/carImage.png',
                    height: 75,
                    color: kPrimary,
                  ),
                  const SizedBox(width: 10),
                  MyText(
                    // align: TextAlign.center,
                    text: 'Valet Parking\nManagement System',
                    size: 18.sp,
                    color: kPrimary,
                    weight: FontWeight.bold,
                  ),
                ],
              ),
              const SizedBox(height: 50),
              TextField(
                controller: logic.searchController,
                onChanged: (value) {
                  carPlateNumber = value;
                  logic.isTextFieldEmpty = value.isEmpty;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: kPrimary.withOpacity(0.2),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  focusedBorder: kBorder,
                  enabledBorder: kBorder,
                  border: kBorder,
                  hintText: 'Enter car plat number',
                  hintStyle: kLightGreyStyle,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: logic.ticketNumberController,
                onChanged: (value) {
                  carTicketNumber = value;
                  logic.isTicketNumberEmpty = value.isEmpty;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: kPrimary.withOpacity(0.2),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  focusedBorder: kBorder,
                  enabledBorder: kBorder,
                  border: kBorder,
                  hintText: 'Enter car Ticket number',
                  hintStyle: kLightGreyStyle,
                ),
              ),
              const SizedBox(height: 20),
              AppButton(
                  text: 'Continue',
                  onPress: () {
                    if (logic.searchController.text.isNotEmpty) {
                      logic.checkPlatNumber(
                          context, logic.searchController.text.toUpperCase(),
                          logic.ticketNumberController.text.toUpperCase());
                    } else {}
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
