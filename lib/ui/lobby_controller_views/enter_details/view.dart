import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/colors.dart';
import '../../../widgets/appBar.dart';
import '../../../widgets/elevated_button.dart';
import '../../../widgets/textformfield.dart';
import '../lobby_main_menu/view.dart';
import '../register_car/view.dart';
import 'logic.dart';

class EnterDetailsPage extends StatelessWidget {
  final logic = Get.put(EnterDetailsLogic());
  final state = Get.find<EnterDetailsLogic>().state;

  @override
  Widget build(BuildContext context) {
    List enterDetailsText = [
      'Car Made',
      'Model',
      'Car Type',
      'Color',
      'Owner',
      'Mobile Number',
      'Record The Car Damages',
    ];
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(text: 'Enter Car Details'),
        body: Container(
          // margin: EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                MyContainer(
                  color: white,
                  text: 'Ticket #486',
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      ...List.generate(
                        enterDetailsText.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: MyColorField(
                            hintText: enterDetailsText[index],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      AppButton(
                        text: 'Update & Next',
                        onPress: () {},
                      ),
                      SizedBox(height: 16),
                      AppButton(
                        text: 'Print',
                        onPress: () {},
                      ),
                      SizedBox(height: 16),
                      AppButton(
                        text: 'Main Menu',
                        textColor: kPrimary,
                        bdColor: kPrimary,
                        bgColor: white,
                        onPress: () {
                          Get.off(() => LobbyMainMenuPage());
                        },
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
