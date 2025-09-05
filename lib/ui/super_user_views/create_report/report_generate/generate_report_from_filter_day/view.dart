import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:speed_park_app/ui/super_user_views/create_report/report_generate/generate_report_from_filter_day/pdfprint.dart';

import '../../../../../widgets/appBar.dart';
import '../../../create_location/view.dart';
import '../../logic.dart';
import 'logic.dart';

class GenerateReportFromFilterPageDay extends StatelessWidget {
  GenerateReportFromFilterPageDay({Key? key}) : super(key: key);

  final homeScreen = Get.put(CreateReportLogic());
  final logic = Get.put(GenerateReportFromFilterLogicDay());
  final state = Get
      .find<GenerateReportFromFilterLogicDay>()
      .state;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(text: 'Filter Report'),
        body: GetBuilder<GenerateReportFromFilterLogicDay>(
          assignId: true,
          builder: (logic) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Dropdown
                  DropDownWidget(
                    dropList: homeScreen.locations,
                    onChanged: (value) {
                      homeScreen.updateSelectLocationField(value);
                    },
                    hintText: 'Location Select',
                  ),

                  const SizedBox(height: 20),
                  DropDownWidget(
                    dropList: logic.locationType,
                    onChanged: (value) {
                      logic.updateLocationType(value);
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
                    ],
                  ),

                  const SizedBox(height: 40),

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
                        await Get.to(() => ListViewPageOfDay(dataSet:logic.filteredCarList,));
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
