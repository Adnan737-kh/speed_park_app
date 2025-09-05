import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed_park_app/widgets/appBar.dart';
import 'package:speed_park_app/widgets/elevated_button.dart';

import 'logic.dart';

class ReportingViewPage extends StatefulWidget {
  @override
  State<ReportingViewPage> createState() => _ReportingViewPageState();
}

class _ReportingViewPageState extends State<ReportingViewPage> {
  final logic = Get.put(ReportingViewLogic());

  final state = Get.find<ReportingViewLogic>().state;

  String generatedReport = '';

  void generateReport() {
    // You can implement your report generation logic here
    // For demonstration purposes, a sample report is shown
    String report = '''
    Report: Validation Records
    
    Validated Tickets:
    - Ticket #123 validated by Validation Center A
    - Ticket #456 validated by Validation Center B
    
    Guest Visits:
    - John Doe visited Restaurant X
    - Jane Smith visited Restaurant Y
    ''';

    setState(() {
      generatedReport = report;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(text: 'Reporting'),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppButton(
                text: 'Generate Report',
                onPress: generateReport,
              ),
              SizedBox(height: 20),
              Text(
                generatedReport,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
