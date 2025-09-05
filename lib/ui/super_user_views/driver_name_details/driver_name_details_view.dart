import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart'; // Import the printing package
import 'package:speed_park_app/ui/super_user_views/driver_name_details/printing_of_driver.dart';
import '../../../widgets/appBar.dart';
import 'driver_name_details_logic.dart';
import 'driver_name_details_state.dart';
import 'package:pdf/widgets.dart' as pw;

class driver_name_detailsView extends StatelessWidget {
  final driver_name_detailsLogic logic = Get.put(driver_name_detailsLogic());
  final driver_name_detailsState state = Get.find<driver_name_detailsLogic>().state;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:  appBarWidget(text: 'Search by Driver Name',),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: logic.driveNameController,
                decoration: InputDecoration(labelText: 'Enter Drive Name'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  logic.searchCar();
                },
                child: Text('Search Car'),
              ),
              SizedBox(height: 16.0),
              Obx(() => Text(
                logic.searchResult.value,
                style: TextStyle(fontSize: 16.0),
              )),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (logic.searchResult.value.isNotEmpty) {
                    Get.to(Selected_Printing(logic.searchResult.value.toString(), logic.driveNameController.text.toUpperCase()));
                  } else {
                    // Handle the case when search result is empty, if needed
                  }
                },
                child: Text('Print Data'),
              )

            ],
          ),
        ),
      ),
    );
  }

  Future<void> _printData(String data) async {
    final pdf = pw.Document();

    // Add content to the PDF
    pdf.addPage(pw.Page(build: (context) => pw.Center(child: pw.Text(data))));

    // Convert the PDF to bytes
    final pdfBytes = await pdf.save();

    // Print the PDF
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfBytes);
  }
}
