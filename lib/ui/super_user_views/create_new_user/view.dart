import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speed_park_app/ui/super_user_views/create_location/view.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../../../widgets/elevated_button.dart';
import '../show_previous_users/view.dart';
import 'logic.dart';

final logic = Get.put(CreateNewUserLogic());
final state = Get.find<CreateNewUserLogic>().state;

class CreateNewUserPage extends StatelessWidget {
  const CreateNewUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => CreateNewUserLogic());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: GetBuilder<CreateNewUserLogic>(
                initState: (_) {
                  if (logic.locations.isEmpty) {
                    logic.fetchData();
                  }
                },
                builder: (logic) {
                  // Show a loading indicator if locations are not loaded
                  if (logic.locations.isEmpty) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 250),
                        child: Column(
                          children: [
                            const CircularProgressIndicator(),
                            SizedBox(height: 20.h),
                            const Text(
                              "Locations Loading, please wait...",
                              style: TextStyle(fontSize: 20,),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      SizedBox(height: 15.h),
                      DropDownWidget(
                        dropList: logic.userType,
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
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      DropDownWidget(
                        dropList: logic.locations,
                        onChanged: (value) {
                          logic.updateChargesField(value);
                        },
                        hintText: 'Location Select',
                      ),
                      SizedBox(height: Get.height / 3.1),
                      AppButton(
                        textColor: kButton,
                        text: 'Save User',
                        onPress: () {
                          logic.saveNewUser(context);
                        },
                        bgColor: Colors.transparent,
                      ),
                      SizedBox(height: 15.h),
                      AppButton(
                        text: 'Show Previous Records',
                        onPress: () {
                          Get.to(() => ShowPreviousUsersPage());
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
