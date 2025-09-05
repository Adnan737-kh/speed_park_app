import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speed_park_app/ui/lobby_controller_views/car_in_parking/logic.dart';

import '../../../../core/constants/colors.dart';
import '../../../../widgets/mytext.dart';

class MyAppBar extends StatelessWidget {
  var border = OutlineInputBorder(
    borderSide: BorderSide(color: white),
    borderRadius: BorderRadius.circular(15),
  );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CarInParkingLogic>(
      builder: (logic) {
        return AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            height: 65,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    margin: EdgeInsets.only(left: 15, right: 15),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.grey,
                        size: 15,
                      ),
                    ),
                  ),
                ),
                logic.isSearching
                    ? SizedBox()
                    : MyText(
                        text: 'Car In Parking',
                        color: white,
                        size: 16,
                        weight: FontWeight.bold,
                      ),
                logic.isSearching
                    ? Container(
                        margin: EdgeInsets.only(right: Get.width * 0.03),
                        width: Get.width * 0.75,
                        child: TextField(
                          controller: logic.searchController,
                          onChanged: (value) {
                            if (value.toString().trim().isEmpty) {
                              logic.resetFields();
                            }
                          },
                          style: TextStyle(color: black, fontSize: 14.sp),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            fillColor: white,
                            hintStyle: TextStyle(
                                color: Colors.grey[500], fontSize: 14.sp),
                            filled: true,
                            enabledBorder: border,
                            hintText: 'Enter platnumber or ticket',
                            contentPadding: EdgeInsets.only(left: 10),
                            border: border,
                            focusedBorder: border,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  if (logic.searched == true) {
                                    logic.resetFields();
                                    return;
                                  }
                                  logic.searchResult(
                                      logic.searchController.text);
                                },
                                icon: logic.searched == false
                                    ? Icon(Icons.search)
                                    : Icon(Icons.close),
                                color: Theme.of(context).primaryColor),
                          ),
                          onSubmitted: (value) {
                            logic.searchResult(value);
                          },
                        ),
                      )
                    : SizedBox(
                        child: GestureDetector(
                          onTap: () {
                            logic.updateSearching();
                          },
                          child: Container(
                            key: UniqueKey(),
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.search,
                                size: 20,
                                color: kPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
