import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed_park_app/widgets/appBar.dart';


import '../../../core/constants/colors.dart';
import '../../../widgets/mytext.dart';
import 'detail_report_view.dart';
import 'logic.dart';

class DeliveryReportPage extends StatelessWidget {
  final logic = Get.put(DeliveryReportLogic());
  final state = Get.find<DeliveryReportLogic>().state;

  List<Map<String, String>> supervisorReports = [
    {
      'Title': 'Maintenance Request',
      'Description': 'Please fix the broken light in the lobby.',
      'Supervisor': 'John Doe',
    },
    {
      'Title': 'Security Alert',
      'Description': 'There was a security breach at the main entrance.',
      'Supervisor': 'Jane Smith',
    },
    {
      'Title': 'Cleaning Request',
      'Description': 'The lobby needs to be cleaned thoroughly.',
      'Supervisor': 'Robert Johnson',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(text: 'Supervisor Reports'),
        body: ListView.builder(
          itemCount: supervisorReports.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kPrimary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: ListTile(
                title: Text(
                  'Title: ${supervisorReports[index]['Title']}',
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description: ${supervisorReports[index]['Description']}',
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Supervisor: ${supervisorReports[index]['Supervisor']}',
                    ),
                  ],
                ),
                trailing: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      kPrimary,
                    ),
                  ),
                  onPressed: () {
                    Get.to(
                      () => ReportDetailScreen(
                        report: supervisorReports[index],
                      ),
                    );
                  },
                  child: const MyText(
                    text: 'View Report',
                    color: white,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
