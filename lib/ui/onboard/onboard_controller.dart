import 'package:get/get.dart';

class OnBoardController extends GetxController {
  List<OnBoardModel> onBoardList = [
    OnBoardModel(
      title: 'Welcome to Valet Parking',
      image: 'assets/onboardImages/onBoard0.jpg',
      text:
          'Experience the convenience of valet car parking with our user-friendly app.',
    ),
    OnBoardModel(
      title: 'Leave Your Car to the Experts',
      image: 'assets/onboardImages/onBoard1.jpg',
      text:
          'Our trained professionals will take care of your vehicle while you focus on what matters to you.',
    ),
    OnBoardModel(
      title: 'Effortless Parking Solution',
      image: 'assets/onboardImages/onBoard2.jpg',
      text:
          'No more driving around looking for parking spots. Our app ensures a stress-free parking experience.',
    ),
    OnBoardModel(
      title: 'Convenient Payment and Pick-Up',
      image: 'assets/onboardImages/onBoard3.jpg',
      text:
          'Pay securely through the app and have your car ready for pick-up when you need it.',
    ),
  ];

  var currentIndex = 0;

  void updatePageView(index) {
    currentIndex = index;
    update();
  }
}

class OnBoardModel {
  final String image;
  final String text;
  final String title;
  OnBoardModel({
    required this.title,
    required this.image,
    required this.text,
  });
}
