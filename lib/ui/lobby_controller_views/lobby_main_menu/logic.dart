import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:speed_park_app/ui/lobby_controller_views/lobby_main_menu/state.dart';

import '../../../core/services/database.dart';

class LobbyMainMenuLogic extends GetxController {
  final LobbyMainMenuState state = LobbyMainMenuState();

  final RxInt getRequestLength = 0.obs;
  final RxInt getCarParkingLength = 0.obs;

  late StreamSubscription<QuerySnapshot> carRequestSubscription;

  @override
  void onInit() {
    super.onInit();

    carRequestSubscription = FirebaseFirestore.instance
        .collection('car_registration')
        .where('userlocation', isEqualTo: userLocation)
        .where('request',isEqualTo: true)
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      try {
        getRequestLength.value = querySnapshot.docs.length;
      } catch (error) {
        print('Error updating collection length: $error');
      }
    });

    carRequestSubscription = FirebaseFirestore.instance
        .collection('car_registration')
        .where('userlocation', isEqualTo: userLocation)
        .where('request', isEqualTo: false)
        .orderBy('ticket')
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      try {
        getCarParkingLength.value = querySnapshot.docs.length;
      } catch (error) {
        print('Error updating collection length: $error');
      }
    });
  }

  @override
  void onClose() {
    carRequestSubscription.cancel();
    super.onClose();
  }
}
