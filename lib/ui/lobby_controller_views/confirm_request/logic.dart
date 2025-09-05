import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/model/register_car/car_registration.dart';
import '../../../core/services/database.dart';
import '../lobby_login/logic.dart';
import 'state.dart';

class ConfirmRequestLogic extends GetxController {
  final TextEditingController controllerDriver = TextEditingController();
  final ConfirmRequestState state = ConfirmRequestState();
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  final logic = Get.put(LobbyLoginLogic());

  setLoading(bool value) {
    _isLoading = value;
    update();
  }

  final Rx<List<CarRegistrationModel>> _car = Rx<List<CarRegistrationModel>>([]);
  List<CarRegistrationModel> get car => _car.value;

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      print('location name ${logic.userData['userLocation']}');
    }

    _car.value.clear();
    _car.bindStream(_repository.getCarRequests());

  }

  final DataBaseServices _repository = DataBaseServices();

  carRemoveFromConfirm({int? index}) {
    _car.value.clear();
    setLoading(true);

    if (_car.value.isEmpty) {
      _car.bindStream(_repository.getCarRequests());
    }
    update();
  }

  // Method to show the add driver dialog
  void showAddDriverDialog(BuildContext context, VoidCallback? onDialogComplete) {
    showDialog(
      context: context,
      builder: (context) => _buildAddDriverDialog(context),
    ).then((_) {
      // This callback will be called when the dialog is closed
      if (onDialogComplete != null) {
        onDialogComplete();
      }
    });
  }


  // Method to build the add driver dialog
  Widget _buildAddDriverDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Driver'),
      content: TextField(
        controller: controllerDriver,
        decoration: const InputDecoration(labelText: 'Driver Name'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            String driverName = controllerDriver.text.trim();
            if (driverName.isNotEmpty) {
              if (kDebugMode) {
                print('Driver Name: $driverName');
              }
              Navigator.of(context).pop(driverName);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a driver name')),
              );
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
