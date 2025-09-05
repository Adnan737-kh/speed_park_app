import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/colors.dart';
import '../../../widgets/mytext.dart';
import 'logic.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  final logic = Get.put(SplashLogic());

  final state = Get.find<SplashLogic>().state;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GetBuilder<SplashLogic>(builder: (logic) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/13aSd9B2fv.json',
                repeat: false,
              ),
              SizedBox(height: 15.h),
              FadeTransition(
                opacity: _animation,
                child: MyText(
                  text: 'WELCOME TO SPEED PARK',
                  size: 20.sp,
                  weight: FontWeight.bold,
                  color: kButton,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
