import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../core/constants/colors.dart';
import 'mytext.dart';

AppBar appBarWidget({var text, double appBarHeight = 60.0}) {
  return AppBar(
    forceMaterialTransparency: true,
    elevation: 0,
    backgroundColor: Colors.transparent,
    flexibleSpace: Container(
      height: appBarHeight,
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
      text: text,
      color: white,
      size: 16.sp,
      weight: FontWeight.bold,
    ),
    leading: GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.arrow_back_ios,
          color: Colors.grey,
          size: 15,
        ),
      ),
    ),
  );
}
