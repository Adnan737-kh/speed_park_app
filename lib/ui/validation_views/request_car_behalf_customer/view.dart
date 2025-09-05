import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speed_park_app/widgets/appBar.dart';
import 'package:speed_park_app/widgets/elevated_button.dart';
import 'package:speed_park_app/widgets/textformfield.dart';

import 'logic.dart';

class RequestCarBehalfCustomerPage extends StatelessWidget {



  final _logic = Get.put(RequestCarBehalfCustomerLogic());

  final state = Get.find<RequestCarBehalfCustomerLogic>().state;

   RequestCarBehalfCustomerPage({super.key});


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(text: 'Request Car'),
        body: Padding(
          padding:const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyColorField(
                controller: _logic.ticketNumberController,
                hintText: 'Ticket No',
                onPress: () {
                  _showDialogTicketNumber(context, 'Plat Number');

                },
              ),
              SizedBox(height: 16.h),
              MyColorField(
                controller: _logic.plateNumberController,
                hintText: 'Plate No',
                onPress: () {
                  _showDialogPlateNumber(context, 'Ticket Number');
                },
              ),
              SizedBox(height: 16.h),
              AppButton(
                text: 'Request Car',
                onPress: (){
                  _logic.checkPlatNumber(context);
                },
              ),

            ],
          ),
        ),
      ),
    );
  }


  void _showDialogTicketNumber(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Choose Option for $title'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.qr_code_scanner),
                title: const Text('Scan with Barcode'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _logic.ticketBarCodeScan();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Image'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the dialog
                  // Replace with your function for Plat Number image handling
                  _logic.takeImageTicketNumber(context);

                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showDialogPlateNumber(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Choose Option for $title'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.qr_code_scanner),
                title: const Text('Scan with Barcode'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _logic.plateBarCodeScan();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Image'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the dialog
                  // Replace with your function for Plat Number image handling
                  _logic.takeImagePlatNumber(context);

                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

}
