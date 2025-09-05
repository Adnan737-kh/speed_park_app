import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/model/register_car/car_registration.dart';
import '../../../core/services/database.dart';
import 'state.dart';

class CarInParkingLogic extends GetxController {
  final CarInParkingState state = CarInParkingState();
  TextEditingController searchController = TextEditingController();

  final Rx<List<CarRegistrationModel>> _car =
      Rx<List<CarRegistrationModel>>([]);
  List<CarRegistrationModel> get car => _car.value;
  final Rx<List<CarRegistrationModel>> _carBackUp =
      Rx<List<CarRegistrationModel>>([]);
  List<CarRegistrationModel> get carBackUp => _carBackUp.value;
  final DataBaseServices _repository = DataBaseServices();
  bool searched = false;
  String placeName = '';
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  bool isSearching = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  void updateSearching() {
    isSearching = !isSearching;
    update();
  }

  setLoading(bool value) {
    _isLoading = value;
    update();
  }

  void getSearchPlateNo(val) {
    placeName = val;
    update();
  }

  searchResult(String data) {
    data = data.toLowerCase();

    // Create a list to store the matching items
    List<CarRegistrationModel> matchingItems = [];

    _carBackUp.value.forEach((value) {
      if (value.plateNumber!.toLowerCase().contains(data.toString().trim()) ||
          value.ticket!.toLowerCase().contains(data.toString().trim())) {
        debugPrint("Data found");
        matchingItems.add(value); // Add the matching item to the list
      }
    });
    _car.value.clear();
    _car.value.addAll(matchingItems);

    searched = true;
    update();
  }

  resetFields() {
    _car.value.clear();
    searchController.text = "";
    _car.value.addAll(_carBackUp.value);
    // patientDataBackup.clear();
    searched = false;
    update();
  }

  void clearCarList() {
    _car.value.clear();
  }

  Stream<List<CarRegistrationModel>> getCarRegistrations() {
    try {
      return _repository
          .getCarRegistrations(); // Assuming _repository.getCarRegistrations() returns a Stream
    } catch (e) {
      // Handle any errors or exceptions
      rethrow;
    }
  }

  @override
  void onInit() {
    super.onInit();
    log('user location is $userLocation');
    _car.value.clear();
    _carBackUp.value.clear();
    setLoading(true); // Set loading to true initially

    if (_car.value.isEmpty) {
      _car.bindStream(_repository.getCarRegistrations());
    }

    // Listen to changes in _car
    ever(_car, (List<CarRegistrationModel>? carData) {
      if (carData != null) {
        // Clear car-backup and assign data when changes occur
        _carBackUp.value = List.from(carData);
        setLoading(false); // Set loading to false when data is received
      }
    });
  }

  carRemove({int? index}) {
    _car.value.clear();
    _carBackUp.value.clear();
    setLoading(true); // Set loading to true initially
    if (_car.value.isEmpty) {
      _car.bindStream(_repository.getCarRegistrations());
    }
    update();
  }
}
