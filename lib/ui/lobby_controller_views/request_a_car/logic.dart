import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';

import '../../../core/model/history/car_history_model.dart';
import '../../../core/model/register_car/car_registration.dart';
import '../../../core/services/database.dart';
import '../car_in_parking/logic.dart';
import '../confirm_request/logic.dart';
import 'state.dart';

final logic = Get.put(CarInParkingLogic());
final state = Get.find<CarInParkingLogic>().state;
final confirm = Get.put(ConfirmRequestLogic());

class RequestACarLogic extends GetxController {
  final RequestACarState state = RequestACarState();
  TextEditingController carMade = TextEditingController();
  TextEditingController model = TextEditingController();
  TextEditingController carTypeController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController ownerController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController recordTheCarDamagesController = TextEditingController();
  TextEditingController floorController = TextEditingController();
  TextEditingController parkingController = TextEditingController();
  TextEditingController plateController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    carMade.dispose();
    model.dispose();
    carTypeController.dispose();
    colorController.dispose();
    ownerController.dispose();
    mobileNumberController.dispose();
    recordTheCarDamagesController.dispose();
    floorController.dispose();
    parkingController.dispose();
    plateController.dispose();
  }

  clearController() {
    carMade.clear();
    model.clear();
    carTypeController.clear();
    colorController.clear();
    ownerController.clear();
    mobileNumberController.clear();
    recordTheCarDamagesController.clear();
    floorController.clear();
    parkingController.clear();
    plateController.clear();
  }

  DateTime currentDateTime = DateTime.now();
  String? _date;
  String? get dateTime => _date;
  String? currentDate;
  String? currentTime;


  void checkHourTime({
    CarRegistrationModel? payment,
    required BuildContext context,
  }) {
    // Get the request time and register time
    String requestDate = DateFormat('MMM d, y').format(DateTime.now());
    String registerDate = payment?.date ?? '';

    // Clean the registration time to replace non-breaking space characters with regular spaces
    payment?.time = payment.time?.replaceAll('\u202f', ' ');

    // Parse the request and register times
    DateFormat('MMM d, y hh:mm a').parse('$requestDate ${payment!.time}');

    int hoursParked = 0; // Initialize to zero

    try {
      // Convert the payment time (String) to a DateTime
      DateTime paymentTime = DateFormat('MMM d, y hh:mm a')
          .parse('$registerDate ${payment.time}');

      // Get the current time
      DateTime currentTime = DateTime.now();

      // Calculate the time difference in hours
      hoursParked = currentTime.difference(paymentTime).inHours;
    } catch (e) {
      // Handle parsing errors if needed
      if (kDebugMode) {
        print('Error parsing time: $e');
      }
    }

    // Define the initial price per hour
    String? amountAsString = payment.amount;
    double initialPricePerHour =
        double.tryParse(amountAsString ?? '0.0') ?? 0.0;

    // Define the additional price per hour after the first hour
    String? amountAsStringPerHour = payment.perHour;
    double additionalPricePerHour =
        double.tryParse(amountAsStringPerHour ?? '0.0') ?? 0.0;

    // Calculate the total amount without tax
    double totalAmount =
        initialPricePerHour; // Initial charge for the first hour

    // Check if the request time exceeds the first hour
    if (hoursParked > 1) {
      totalAmount += additionalPricePerHour *
          (hoursParked - 1); // Add per hour charges for each additional hour
    }

    // Check for tax charges
    double taxRate = 0.05; // 5% tax rate
    if (payment.taxCharge != 'Tax Exclusive') {
      // Calculate the tax-inclusive total amount
      totalAmount *= (1.0 + taxRate); // Add 5% tax
    }

    showTotalAmountDialog(totalAmount, context, payment.date.toString(),
        payment.time.toString(), requestDate, hoursParked);

    if (kDebugMode) {
      print('Total Amount: $totalAmount AED');
    }
    update();
  }

  void showTotalAmountDialog(double totalAmount, BuildContext context,
      String date, String time, String reqtime, int hoursParked) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              'Total Amount $date and $time and the request time is $reqtime'),
          content: Text('Total Amount: $totalAmount AED hour $hoursParked'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  carRequestToConfirm({
    required BuildContext context,
    bool? response,
    String? uid,
    int? index,
    String? platNumber,
    String? registerCarDate,
    String? registerCarTime,
    String? locationTypeCheck,
    String? selectCharges,
    String? taxInclude,
    String? amountIncludeTax,
    String? perHour,
    String? taxCharge,
    String? userLocation,
    String? carMade,
    String? carModel,
    String? carType,
    String? color,
    String? owner,
    String? mobileNumber,
    String? recordDamage,
    String? floorNumber,
    String? parkingNumber,
    String? driverName,
    CarRegistrationModel? payment,
    List? images,
  }) async {
    String formattedDate = DateFormat.yMMMd().format(DateTime.now());
    String formattedTime = DateFormat.jm().format(DateTime.now());
    _date = '$formattedDate  $formattedTime';
    currentDate = formattedDate.toString();
    currentTime = formattedTime.toString();
      if (kDebugMode) {
        print('my current time$currentTime');
      }
    ProgressDialog progressDialog = ProgressDialog(
      Get.context!,
      blur: 10,
      title: Text(response == true ? "Request Car" : "Confirm Request"),
      message: const Text("Please Wait"),
      onDismiss: () {
        if (kDebugMode) {
          debugPrint("Do something onDismiss");
        }
      },
    );

    if (payment?.selectLocation == "Paid" &&
        payment?.selectCharges == 'Per Services') {
      String totalAmount =
          '${(payment?.taxCharge != 'Tax Inclusive')
          ? (double.tryParse(payment?.amount?.toString() ?? '0.0') ?? 0.0) * 1.05
          : (double.tryParse(payment?.amount?.toString() ?? '0.0') ?? 0.0)}';
      showPaymentDialog(
          context: context,
          message:
              'Total amount:$totalAmount AED ', //and Tax:${payment!.taxCharge.toString()}'
          onCancel: () {

            Navigator.of(context).pop();
          },
          onPress: () async {
            if (kDebugMode) {
              print('uid of update is ${uid.toString()}');
            }
            progressDialog.show();
            final resp = await DataBaseServices()
                .updateCarInParkingRequest(uid.toString(), totalAmount);
            if (resp) {
              logic.carRemove(index: index);
              progressDialog.dismiss();
              Get.back();
            }
          },
          onUnpaidPress: () async {
            if (kDebugMode) {
              print('uid of update is ${uid.toString()}');
            }
            progressDialog.show();
            final resp = await DataBaseServices()
                .updateCarInParkingRequest(uid.toString(), totalAmount);

            if (resp) {
              logic.carRemove(index: index);
              progressDialog.dismiss();
              Get.back();
            }
          });
    }
    if (payment?.selectLocation == "Paid" &&
        payment?.selectCharges == 'Per hour') {
      // Get the current date and time
      DateTime currentTime = DateTime.now();

      // Get the registration date and time from Firebase
      String registerDate = payment?.date ?? '';
      String registerTime = payment?.time ?? '';

      // Clean the registration time to replace non-breaking space characters with regular spaces
      registerTime = registerTime.replaceAll('\u202f', ' ');

      // Parse the registration time string to obtain a DateTime object
      DateTime registrationDateTime = DateFormat('MMM d, y hh:mm a')
          .parse('$registerDate $registerTime');

      // Calculate the time difference
      Duration timeDifference = currentTime.difference(registrationDateTime);
      int minutesParked = timeDifference.inMinutes;

      // Set a fixed value for (60 minutes)
      int interval = 60;

      // Define the initial price per interval
      String? amountAsString = payment?.amount;
      double initialPricePerInterval =
          double.tryParse(amountAsString ?? '0.0') ?? 0.0;

      // Calculate the total amount without tax
      double totalAmountWithoutTax = 0.0;

      // Calculate the number of intervals (every 60 minutes)
      int numberOfIntervals = (minutesParked / interval).floor() + 1;

      // Add the initial fee
      totalAmountWithoutTax += initialPricePerInterval;

      // Add additional charges for each hour
      for (int i = 1; i < numberOfIntervals; i++) {
        totalAmountWithoutTax += 5.0; // Additional 5 AED for each interval
      }

      // Calculate tax separately for display on the dialog
      double taxRate = 0.05; // 5% tax rate
      double taxAmount = totalAmountWithoutTax * taxRate;

      // Calculate the total amount with tax for display on the dialog
      double totalAmountWithTax = totalAmountWithoutTax + taxAmount;

      // Debug prints for troubleshooting
      if (kDebugMode) {
        print('Current Time: $currentTime');
        print('Registration Time: $registrationDateTime');
        print('Total Parked Time (minutes): $minutesParked');
        print('Initial Price Per Interval: $initialPricePerInterval');
        print('Total Amount Without Tax: $totalAmountWithoutTax AED');
        print('Tax Amount: $taxAmount AED');
      }

      // Show payment dialog with the calculated total amount including tax
      showPaymentDialog(
        context: context,
        message: 'Total amount: $totalAmountWithTax AED',
        onCancel: () {
          Navigator.of(context).pop();
        },
        onPress: () async {
          if (kDebugMode) {
            print('uid of update is ${uid.toString()}');
          }

          progressDialog.show();
          // Save only the amount without tax to Firestore
          final resp = await DataBaseServices().updateCarInParkingRequest(
              uid.toString(), totalAmountWithoutTax.toString());
          if (resp) {
            logic.carRemove(index: index);
            progressDialog.dismiss();
            Get.back();
          }
        },
        onUnpaidPress: () async {
          if (kDebugMode) {
            print('uid of update is ${uid.toString()}');
          }

          Get.back();
          progressDialog.show();
          // Save only the amount without tax to Firestore
          final resp = await DataBaseServices().updateCarInParkingRequest(
              uid.toString(), totalAmountWithoutTax.toString());
                  if (resp) {
            logic.carRemove(index: index);
            progressDialog.dismiss();
            Get.back();

          }
        },
      );
    } else {
      progressDialog.show();
      if (kDebugMode) {
        print('uid of update is ${uid.toString()}');
      }
      final resp = await DataBaseServices()
          .updateCarInParkingRequest(uid.toString(), '');
      if (resp) {
          logic.carRemove(index: index);
        progressDialog.dismiss();
        Get.back();
      }
    }
    update();
  }

  static void showPaymentDialog(
      {required BuildContext context,
      String? message,
      VoidCallback? onPress,
      VoidCallback? onUnpaidPress,
      VoidCallback? onCancel}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Payment Confirmation"),
          content: Text(
            "$message",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: onUnpaidPress,
              child: const Text("UnPaid"),
            ),
            TextButton(
              onPressed: onPress,
              child: const Text("Paid"),
            ),
            TextButton(
              onPressed: onCancel,
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  carRequestToConfirmHistory({
    required BuildContext context,
    bool? response,
    String? uid,
    int? index,
    String? platNumber,
    String? registerDate,
    String? registerTime,
    String? locationTypeCheck,
    String? selectCharges,
    String? taxInclude,
    String? amountIncludeTax,
    String? perHour,
    String? taxCharge,
    String? userLocation,
    String? ticketNumber,
    String? carMade,
    String? carModel,
    String? carType,
    String? color,
    String? owner,
    String? mobileNumber,
    String? recordDamage,
    String? floorNumber,
    String? parkingNumber,
    String? driveName,
    List? images,
    String? driverRecieve,
    String? validatorName,
    bool? validationRequestBy,
    String? isCarPaidOrValidated,
  }) async {
    print('called carRequestToConfirmHistory');

    String formattedDate = DateFormat.yMMMd().format(DateTime.now());
    String formattedTime = DateFormat.jm().format(DateTime.now());
    _date = '$formattedDate  $formattedTime';
    currentDate = formattedDate.toString();
    currentTime = formattedTime.toString();
    if (kDebugMode) {
      print('car hist dateANdTime $currentTime');
    }

    CarHistoryModel model = CarHistoryModel(
      platNumber: platNumber,
      registerDate: registerDate,
      deliveredDate: currentDate,
      deliveredTime: currentTime,
      registerTime: registerTime,
      locationTypeCheck: locationTypeCheck,
      selectCharges: selectCharges,
      taxInclude: taxInclude,
      amountIncludeTax: amountIncludeTax,
      perHour: perHour,
      taxCharge: taxCharge,
      userLocation: userLocation,
      carMade: carMade,
      model: carModel,
      carType: carType,
      color: color,
      owner: owner,
      mobileNumber: mobileNumber,
      recordDamage: recordDamage,
      floorNumber: floorNumber,
      parkingNumber: parkingNumber,
      images: images,
      ticketNumber: ticketNumber,
      driverName: driveName,
      driverReceive: driverRecieve,
      validatorName: validatorName,
      validationRequestedBy: validationRequestBy,
      isCarPaidOrValidated: isCarPaidOrValidated,
      orderByTime: DateTime.now().millisecondsSinceEpoch,
    );

    ProgressDialog progressDialog = ProgressDialog(
      Get.context!,
      blur: 10,
      title: Text(response == true ? "Request Car" : "Confirm Request"),
      message: const Text("Please Wait"),
      onDismiss: () {
        if (kDebugMode) {
          debugPrint("Do something onDismiss");
        }
      },
    );
    progressDialog.show();

    try {
      final res = await DataBaseServices().carHistory(model.toMap());

      if (!res) {
        debugPrint("Failed to add car to history.");
        Get.snackbar("Error", "Failed to move car to history.");
        return;
      }

      final resp = await DataBaseServices()
          .deleteRequestFromCarRegistration(uid.toString());

      if (!resp) {
        debugPrint("Failed to delete request.");
        Get.snackbar("Error", "Failed to delete car request.");
      }
    } catch (e, st) {
      debugPrint("Exception in carRequestToConfirmHistory: $e");
      debugPrintStack(stackTrace: st);
      Get.snackbar("Exception", "Something went wrong: $e");
    } finally {
      progressDialog.dismiss();
    }
  }

  deliveredRequest(String uid, String amount) async {
    print('called deliveredRequest');
    ProgressDialog progressDialog = ProgressDialog(
      Get.context!,
      blur: 10,
      title: const Text("Confirm Request"),
      message: const Text("Please Wait"),
      onDismiss: () {
        if (kDebugMode) {
          debugPrint("Do something onDismiss");
        }
      },
    );
    progressDialog.show();

    try {
      print('called updateCarInParkingRequest');
      final resp = await DataBaseServices()
          .updateCarInParkingRequest(uid.toString(), amount);

      if (resp) {
        progressDialog.dismiss();
        confirm.carRemoveFromConfirm(index: 1);
      } else {
        throw Exception('Failed to update car in parking request');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error while updating car in parking request: $e');
      }
      progressDialog
          .dismiss();
    }

    update();
  }


  deleteCar(String uid) async {
    bool confirmed = await showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this car?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Return false if user cancels
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Return true if user confirms
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ProgressDialog progressDialog = ProgressDialog(
        Get.context!,
        blur: 10,
        title: const Text("Car Deleting"),
        message: const Text("Please Wait"),
        onDismiss: () {
          if (kDebugMode) {
            debugPrint("Do something onDismiss");
          }
        },
      );
      progressDialog.show();

      try {
        final resp = await DataBaseServices().deleteCarFromHistory(uid.toString());

        if (resp) {
          progressDialog.dismiss();
          confirm.carRemoveFromConfirm(index: 1);
          update(); // Update UI after successful deletion
        } else {
          throw Exception('Failed to Delete a car in parking request');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error while updating car in parking request: $e');
        }
        progressDialog.dismiss();
      }
    }
  }

}
