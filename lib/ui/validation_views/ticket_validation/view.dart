import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed_park_app/widgets/appBar.dart';
import 'package:speed_park_app/widgets/elevated_button.dart';
import 'package:speed_park_app/widgets/textformfield.dart';

import '../../../core/services/database.dart';
import 'logic.dart';

class TicketValidationPage extends StatelessWidget {
  final _logic = Get.put(TicketValidationLogic());
  final state = Get.find<TicketValidationLogic>().state;

   TicketValidationPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(text: 'Validate Ticket'),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyColorField(
                controller: _logic.ticketNumberController,
                hintText: 'Ticket Number',
                onPress:(){
                  _showDialogPlateNumber(context,'Ticket Number');
                    },

              ),
              const SizedBox(height: 10),
              MyColorField(
                controller:_logic.validationCenterController,
                readyOnly: true,
                hintText: '$usernames',
              ),
              const SizedBox(height: 20),
              AppButton(
                text: 'Validated Ticket',
                onPress: () {
                  _logic.checkTicketNumber(context);
                },
              ),
            ],
          ),
        ),
      ),
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
                  _logic.barCodeCall();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Image'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the dialog
                  // Replace with your function for Plat Number image handling
                  _logic.scanTicketNumber(context);

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
