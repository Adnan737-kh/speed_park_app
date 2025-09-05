import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speed_park_app/ui/lobby_controller_views/edit_option/view.dart';

import '../../../core/constants/colors.dart';
import '../../../widgets/mytext.dart';
import '../request_a_car/view.dart';
import 'component/car_parking_app_bar.dart';
import 'logic.dart';

class CarInParkingPage extends StatelessWidget {
  final CarInParkingLogic controller = Get.put(CarInParkingLogic());

  CarInParkingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size(Get.width, 65),
              child: MyAppBar(),
            ),
            body: Column(
              children: [
                if (controller.isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else if (controller.car.isEmpty)
                  const Center(
                    child: Text('No Car in Parking'),
                  )
                else
                  GetBuilder<CarInParkingLogic>(builder: (logic) {
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.car.length,
                        itemBuilder: (context, index) {
                          var data = controller.car[index];
                          return Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(
                                top: 15, right: 15, left: 15),
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                  color: kPrimary,
                                  blurRadius: 10,
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    ...List.generate(
                                      5,
                                      (index) => Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color: black.withOpacity(0.2),
                                              blurRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: MyText(
                                          text: index == 0
                                              ? data.plateNumber != null
                                                  ? 'Plate No:${data.plateNumber?.toUpperCase()}'
                                                  : 'Plate No: N/A'
                                              : index == 1
                                                  ? data.ticket != null
                                                      ? 'Ticket :${data.ticket?.toUpperCase()}'
                                                      : 'Ticket : N/A'
                                                  : index == 2
                                                      ? data.time != null
                                                          ? 'Register: ${data.date} ${data.time}'
                                                          : 'Time In: N/A'
                                                      : index == 3
                                                          ? data.parkingNumber !=
                                                                  null
                                                              ? 'Parking NO:${data.parkingNumber}'
                                                              : 'Parking NO: N/A'
                                                          : index == 4
                                                              ? data.floorNumber !=
                                                                      null
                                                                  ? 'Floor NO: ${data.floorNumber}'
                                                                  : 'Floor NO: N/A'
                                                              : '',
                                          size: 14.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => RequestACarPage(
                                          model: controller.car[index],
                                          index: index,
                                        ));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                    child: const Center(
                                      child: MyText(
                                        text: 'Request',
                                        color: white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => EditOptionPage(
                                        model: controller.car[index],
                                        uid: controller.car[index].uid
                                            .toString(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: kButton2,
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                    child: const Center(
                                      child: MyText(
                                        text: 'Edit Option',
                                        color: white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }),
              ],
            )),
      );
    });
  }
}
