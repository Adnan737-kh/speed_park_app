import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed_park_app/ui/guest_views/guest_home_view/view.dart';
import 'package:speed_park_app/ui/lobby_controller_views/lobby_login/view.dart';
import 'package:speed_park_app/ui/super_user_views/login/view.dart';
import 'package:speed_park_app/ui/validation_views/validation_login/view.dart';
import 'package:speed_park_app/widgets/mytext.dart';

import 'core/constants/colors.dart';

class RoleSelectionView extends StatelessWidget {
  final List btnNames = [
    'Super User',
    'Lobby Controller',
    'Validation',
    'Guest',
  ];

  RoleSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: kprimary,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                color: kButton2,
                height: 150,
              ),
              const SizedBox(
                height: 40,
              ),
              ...List.generate(
                btnNames.length,
                (index) => GestureDetector(
                  onTap: () => index == 0
                      ? Get.to(() => LoginPage())
                      : index == 1
                          ? Get.to(() => LobbyLoginPage())
                          : index == 2
                              ? Get.to(() => ValidationLoginPage())
                              : Get.to(() => GuestHomeViewPage()),
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: kButton,
                      gradient: const LinearGradient(
                        colors: [
                          kButton,
                          kButton2,
                        ], // Define your gradient colors here
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: MyText(
                        text: btnNames[index],
                        color: white,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
