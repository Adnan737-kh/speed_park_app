import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speed_park_app/widgets/elevated_button.dart';
import 'package:speed_park_app/widgets/mytext.dart';
import 'package:speed_park_app/widgets/textformfield.dart';

import '../../../core/constants/colors.dart';

import '../Gest_sign_up/view.dart';
import 'logic.dart';

class GestLoginPage extends StatelessWidget {
  final logic = Get.put(GestLoginLogic());
  final state = Get.find<GestLoginLogic>().state;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 45),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/carImage.png',
                    height: 45,
                    color: kPrimary,
                  ),
                  const  SizedBox(width: 10),
                  MyText(
                    // align: TextAlign.center,
                    text: 'Valet Parking\nManagement System',
                    size: 16.sp,
                    color: kPrimary,
                    weight: FontWeight.bold,
                  ),
                ],
              ),
              const SizedBox(height: 100),
              FormWidget(
                controller: logic.emailController,
                hintText1: 'Your email address',
                hintText2: 'Email',
              ),
              const SizedBox(height: 15),
              GetBuilder<GestLoginLogic>(
                builder: (logic) {
                  return FormWidget(
                    visible: logic.visible,
                    controller: logic.passwordController,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        logic.updateVisibility();
                      },
                      child: Icon(
                        logic.visible?Icons.visibility_off:Icons.visibility,
                        color: black.withOpacity(0.3),
                      ),
                    ),
                    hintText1: 'Enter your password',
                    hintText2: 'password',
                  );
                },
              ),
              const SizedBox(height: 25),
              AppButton(
                textColor: white,
                bdColor: Colors.transparent,
                text: 'Login',
                onPress: () {
                 logic.signUp(context);
                },
              ),
              // const SizedBox(height: 10),
              // GestureDetector(
              //   onTap: () {
              //     Get.to(() => GestSignUpPage());
              //   },
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       MyText(
              //         text: 'Don\'t Have account? ',
              //         size: 12.sp,
              //         weight: FontWeight.w400,
              //         color: kblack,
              //       ),
              //       MyText(
              //         text: 'Sign Up',
              //         size: 12.sp,
              //         weight: FontWeight.w600,
              //         color: kprimary,
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class FormWidget extends StatelessWidget {
  const FormWidget(
      {super.key,
      this.controller,
      this.visible = false,
      required this.hintText1,
      required this.hintText2,
      this.suffixIcon});

  final controller;
  final visible;
  final suffixIcon;
  final String hintText1;
  final String hintText2;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: hintText1,
          size: 12.sp,
          weight: FontWeight.w500,
          color: black,
        ),
        SizedBox(height: 5),
        GetBuilder<GestLoginLogic>(builder: (logic) {
          return MyField(
            visibile: visible,
            suffixIcon: suffixIcon,
            controller: controller,
            hintText: hintText2,
          );
        }),
      ],
    );
  }
}
