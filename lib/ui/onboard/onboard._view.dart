// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:speed_park_app/role_selection_view.dart';
//
// import '../../core/constants/colors.dart';
// import '../../widgets/elevated_button.dart';
// import '../../widgets/mytext.dart';
// import '../lobby_controller_views/lobby_login/logic.dart';
// import '../lobby_controller_views/lobby_login/view.dart';
// import '../super_user_views/login/view.dart';
// import '../validation_views/validation_login/view.dart';
// import 'onboard_controller.dart';
//
// OnBoardController controller = Get.put(OnBoardController());
//
// class OnBoardView extends GetView<OnBoardController> {
//   const OnBoardView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<OnBoardController>(
//         init: OnBoardController(),
//         builder: (context) {
//           return SafeArea(
//             child: Scaffold(
//               body: SizedBox(
//                 height: Get.height,
//                 width: Get.width,
//                 child: Stack(
//                   children: [
//                     PageView(
//                       onPageChanged: (index) {
//                         controller.updatePageView(index);
//                       },
//                       controller: PageController(viewportFraction: 1),
//                       children: [
//                         ...List.generate(
//                           controller.onBoardList.length,
//                           (index) => Stack(
//                             children: [
//                               Container(
//                                 height: Get.height,
//                                 width: Get.width,
//                                 decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                     fit: BoxFit.fill,
//                                     image: AssetImage(
//                                         controller.onBoardList[index].image),
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 height: Get.height,
//                                 width: Get.width,
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     begin: Alignment.topCenter,
//                                     end: Alignment.bottomCenter,
//                                     colors: [
//                                       const Color(0xff000000).withOpacity(0.2),
//                                       const Color(0xff000000),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 top: Get.height / 5,
//                                 left: 30,
//                                 right: 40,
//                                 bottom: 5,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const MyText(
//                                       text: 'Speed Parks',
//                                       fontFamily: 'Montserrat',
//                                       color: kwhite,
//                                       size: 24,
//                                       weight: FontWeight.bold,
//                                     ),
//                                     const SizedBox(height: 15),
//                                     MyText(
//                                       fontFamily: 'Montserrat',
//                                       text: controller.onBoardList[index].title,
//                                       color: kwhite,
//                                       size: 44,
//                                       weight: FontWeight.bold,
//                                     ),
//                                     const SizedBox(height: 23),
//                                     MyText(
//                                       fontFamily: 'Montserrat',
//                                       text: controller.onBoardList[index].text,
//                                       color: kwhite,
//                                       size: 16,
//                                       weight: FontWeight.normal,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     Positioned(
//                       top: Get.height / 1.5,
//                       left: 30,
//                       right: 40,
//                       bottom: 5,
//                       child: Column(
//                         children: [
//                           Expanded(
//                             child: Row(
//                               children: [
//                                 ...List.generate(
//                                   controller.onBoardList.length,
//                                   (index) => Expanded(
//                                     child: Container(
//                                       margin: const EdgeInsets.only(right: 15),
//                                       height: 2,
//                                       decoration: BoxDecoration(
//                                         color: controller.currentIndex == index
//                                             ? kwhite
//                                             : const Color.fromARGB(
//                                                 130,
//                                                 217,
//                                                 217,
//                                                 224,
//                                               ),
//                                         borderRadius: BorderRadius.circular(2),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Expanded(
//                             child: Column(
//                               children: [
//                                 MyButton(
//                                   onPress: () {
//                                     Get.offAll(() => RoleSelectionView());
//                                   },
//                                   text: 'Continue',
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed_park_app/role_selection_view.dart';

class OnBoardView extends StatefulWidget {
  const OnBoardView({super.key});

  @override
  State<OnBoardView> createState() => _OnBoardViewState();
}

class _OnBoardViewState extends State<OnBoardView> {
  @override
  void initState() {
    super.initState();

    // Navigate to RoleSelectionView after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAll(() => RoleSelectionView());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: Get.height,
          width: Get.width,
          child: const Stack(
            children: [
              Center(
                child: Image(
                  image: AssetImage('assets/logo.png'), // Replace with your logo
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

