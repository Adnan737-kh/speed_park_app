import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../../../core/constants/colors.dart';
import '../create_location/view.dart';
import '../create_new_user/view.dart';
import '../create_report/view.dart';
import '../create_super_user/create_super_user_view.dart';
import 'logic.dart';

class MainMenuPage extends StatelessWidget {
  final logic = Get.put(MainMenuLogic());
  final state = Get.find<MainMenuLogic>().state;

  final PageStorageBucket _bucket = PageStorageBucket(); // Add a PageStorageBucket

  final List<Map<String, dynamic>> menuList = [
    {'Image': 'assets/locationIcon.png', 'text': 'Location'},
    {'Image': 'assets/report.png', 'text': 'Report'},
    {'Image': 'assets/group.png', 'text': 'New User'},
    {'Image': 'assets/group.png', 'text': 'New Super User'},
  ];

  MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: menuList.length,
        child: Scaffold(
          body: PageStorage(
            bucket: _bucket, // Pass the bucket here
            child: GetBuilder<MainMenuLogic>(builder: (logic) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [kPrimary, kPrimary2],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    child: TabBar(
                      indicatorColor: Colors.transparent,
                      onTap: (index) {
                        logic.changeTab(index);
                      },
                      labelStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
                      labelColor: white,
                      unselectedLabelColor: black.withOpacity(0.5),
                      tabs: menuList.map((item) {
                        int index = menuList.indexOf(item);
                        return Tab(
                          icon: Image.asset(
                            item['Image'],
                            height: 20,
                            color: logic.changeTab == index
                                ? white
                                : black.withOpacity(0.5),
                          ),
                          text: item['text'],
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        const CreateLocationPage(),
                        CreateReportPage(),
                        const CreateNewUserPage(),
                        CreateSuperUserView(),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
