import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:speed_park_app/ui/super_user_views/create_report/report_generate/generate_report_from_filter/pdfprint.dart';

import '../../../../../widgets/appBar.dart';
import '../../../create_location/view.dart';
import '../../logic.dart';
import 'logic.dart';

class GenerateReportFromFilterPage extends StatelessWidget {
  GenerateReportFromFilterPage({Key? key}) : super(key: key);

  final homescreen = Get.put(CreateReportLogic());
  final logic = Get.put(Generate_report_from_filterLogic());
  final state = Get
      .find<Generate_report_from_filterLogic>()
      .state;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(text: 'Filter Report'),
        body: GetBuilder<Generate_report_from_filterLogic>(
          assignId: true,
          builder: (logic) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Dropdown
                  DropDownWidget(
                    dropList: homescreen.locations,
                    onChanged: (value) {
                      homescreen.updateSelectLocationField(value);
                    },
                    hintText: 'Location Select',
                  ),

                  const SizedBox(height: 20),
                  DropDownWidget(
                    dropList: logic.locationType,
                    onChanged: (value) {
                      logic.updatelocationType(value);
                    },
                    hintText: 'Location Select',
                  ),

                  // Location Type Dropdown (Paid/Normal)


                  const SizedBox(height: 20),

                  // Date Range Picker
                  Row(
                    children: [
                      const Text('Start Date:'),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () {
                          logic.selectStartDate(context);
                        },
                        child: Text(
                          DateFormat('yyyy-MM-dd').format(logic.startDate),
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Text('End Date:'),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () {
                          logic.selectEndDate(context);
                        },
                        child: Text(
                          DateFormat('yyyy-MM-dd').format(logic.endDate),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // // Driver Name TextField
                  // TextField(
                  //   controller: logic.driverNameController,
                  //
                  //   decoration: InputDecoration(
                  //     labelText: 'Driver Name',
                  //
                  //     border: OutlineInputBorder(
                  //         borderSide: BorderSide(color: kprimary.withOpacity(
                  //             0.2))),
                  //   ),
                  // ),

                  const SizedBox(height: 20),

                  // Apply Filter Button
                  ElevatedButton(
                    onPressed: () async {
                      // Show circular progress indicator while fetching data
                      await logic.filterData();

                      // Check if data is fetched
                      if (logic.filteredCarList.isEmpty) {
                        // No data found, show a message
                        Get.snackbar('No Result', 'Sorry, no result found.');
                      } else {
                        Get.snackbar('Result', 'Result found');
                        // Navigator.push(context, MaterialPageRoute(builder: (context){
                        //   return PdfGenerator(logic.filteredCarList);
                        // }));

                        // Data found, show it in PDF format using your PDF viewer widget
                        await Get.to(() => ListViewPage(dataSet:logic.filteredCarList,));
                      }
                    },
                    child: const Text('Apply Filter'),
                  ),

                  // Show circular progress indicator while fetching data
                  logic.car.isEmpty
                      ? const CircularProgressIndicator()
                      : const SizedBox.shrink(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
