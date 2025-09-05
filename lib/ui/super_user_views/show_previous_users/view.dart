import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speed_park_app/ui/super_user_views/show_previous_users/logic.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../../../widgets/appBar.dart';
import '../../../widgets/elevated_button.dart';
import '../../../widgets/mytext.dart';
import '../create_location/view.dart';

ShowPreviousUsersLogic _controller = Get.put(ShowPreviousUsersLogic());

class ShowPreviousUsersPage extends StatelessWidget {
  final List<String> headers = [
    'User',
    'Email',
    'Password',
    'Action',
    'Delete'
  ];

  ShowPreviousUsersPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(text: 'Previous Records'),
        body: SingleChildScrollView(
          child: GetBuilder<ShowPreviousUsersLogic>(
              init: ShowPreviousUsersLogic(),
              initState: (_) {},
              builder: (logic) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Obx(
                          () {
                            final newUserGet = logic.newUserData;
                            if (logic.newUserData.isNotEmpty) {
                              return Table(
                                border: TableBorder.symmetric(
                                  inside: BorderSide(color: kGrey),
                                ),
                                defaultColumnWidth: FixedColumnWidth(
                                  Get.width / 4,
                                ),
                                children: [
                                  TableRow(
                                    decoration: const BoxDecoration(
                                      color: kPrimary,
                                    ),
                                    children: [
                                      ...List.generate(
                                        headers.length,
                                        (index) => TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: MyText(
                                              text: headers[index],
                                              color: white,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  for (var newUser in newUserGet)
                                    TableRow(
                                      // Set width for column 3

                                      children: [
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: MyText(
                                                text: newUser.username ?? ''),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: MyText(
                                                text: newUser.email ?? ''),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: MyText(
                                                text: newUser.password ?? ''),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                Get.to(
                                                  () => AlertDialogWidget(
                                                    uid: newUser.uid,
                                                    user: newUser.username,
                                                    location: newUser.email,
                                                    project: newUser.password,
                                                    userLocation:
                                                        newUser.location,
                                                    userType: newUser.userTyoe,
                                                  ),
                                                );
                                              },
                                              child: const MyText(
                                                text: 'Edit',
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                _controller.delete(
                                                    newUser.uid.toString());
                                              },
                                              child: const MyText(
                                                text: 'Delete',
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: black,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),

        // Text('data'),
      ),
    );
  }
}

class AlertDialogWidget extends StatelessWidget {
  const AlertDialogWidget({
    this.uid,
    super.key,
    this.location,
    this.project,
    this.user,
    this.userType,
    this.userLocation,
  });
  final String? user;
  final String? location;
  final String? project;
  final String? uid;
  final String? userLocation;
  final String? userType;
  @override
  Widget build(BuildContext context) {
    List hints = [user, location, project];
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(text: 'Edit User'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...List.generate(
                hints.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: TextFormField(
                    controller: index == 0
                        ? _controller.userController
                        : index == 1
                            ? _controller.locationController
                            : index == 2
                                ? _controller.projectController
                                : _controller.userLocation,
                    decoration: InputDecoration(
                      hintText: hints[index],
                      labelText: hints[index],
                      hintStyle: kStyle,
                      labelStyle: kStyle,
                      fillColor: kPrimary.withOpacity(0.2),
                      filled: true,
                      border: kBorder,
                      focusedBorder: kBorder,
                      enabledBorder: kBorder,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              DropDownWidget(
                dropList: _controller.usertype,
                onChanged: (value) {
                  _controller.updateUserTypeField(value);
                },
                hintText: '$userType Select',
              ),
              SizedBox(height: 16.h),
              DropDownWidget(
                dropList: _controller.locations,
                onChanged: (value) {
                  _controller.updateUserLocation(value);
                },
                hintText: 'Location Select',
              ),
              SizedBox(height: 16.h),
              AppButton(
                textColor: kButton,
                text: 'Updates User',
                onPress: () {
                  _controller.updateUser(
                      uid: uid.toString(),
                      context: context,
                      usernames: user,
                      email: location,
                      password: project,
                      userTypes: userType,
                      userLocations: userLocation);
                },
                bgColor: Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
