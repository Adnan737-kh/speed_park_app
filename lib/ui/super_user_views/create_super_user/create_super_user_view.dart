import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../../../widgets/elevated_button.dart';
import '../create_location/view.dart';
import '../show_previous_users/view.dart';
import 'create_super_user_logic.dart';

final logic = Get.put(CreateSuperUserLogic());
final state = Get.find<CreateSuperUserLogic>().state;
class CreateSuperUserView extends StatelessWidget {



   CreateSuperUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15.h),
            DropDownWidget(
              dropList: logic.usertype,
              onChanged: (value) {
                logic.updateUserTypeField(value);
              },
              hintText: 'User Type Select',
            ),
            SizedBox(height: 5.h),
            ...List.generate(
              3,
                  (index) => Padding(
                padding: const EdgeInsets.only(top: 15),
                child: TextFormField(
                  controller: index == 0
                      ? logic.userController
                      : index == 1
                      ? logic.emailController
                      : logic.passwordController,
                  decoration: InputDecoration(
                    hintText: logic.userText[index],
                    labelText: logic.userText[index],
                    hintStyle: kStyle,
                    labelStyle: kStyle,
                    fillColor: kPrimary.withOpacity(0.2),
                    filled: true,
                    border: kBorder,
                    focusedBorder: kBorder,
                    enabledBorder: kBorder,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.h),
            SizedBox(height: Get.height/3.1),
            AppButton(
              textColor: kButton,
              text: 'Create Super User',
              onPress: () {
                logic.createSuperUser(context);
              },
              bgColor: Colors.transparent,
            ),
            const SizedBox(height: 15),
            AppButton(
              text: 'Show Previous Records',
              onPress: () {
                Get.to(() => ShowPreviousUsersPage());
              },
            )
          ],
        ),
      ),
    );
  }
}
