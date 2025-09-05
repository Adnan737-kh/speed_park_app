import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speed_park_app/widgets/appBar.dart';
import 'package:speed_park_app/widgets/mytext.dart';

class ReportDetailScreen extends StatelessWidget {
  final Map<String, String> report;

  ReportDetailScreen({required this.report});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(text: 'Report Detail'),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: 'Title: ${report['Title']}',
                size: 24.sp,
                weight: FontWeight.bold,
                color: Colors.black,
              ),
              const SizedBox(height: 20),
              MyText(
                text: 'Description:',
                size: 18.sp,
                weight: FontWeight.bold,
              ),
              const SizedBox(height: 10),
              MyText(
                text: 'Description: ${report['Description']}',
                size: 16.sp,
              ),
              const SizedBox(height: 20),
              MyText(
                text: 'Supervisor:',
                size: 18.sp,
                weight: FontWeight.bold,
              ),
              const SizedBox(height: 10),
              MyText(
                text: 'Supervisor: ${report['Supervisor']}',
                size: 16.sp,
                color: Colors.grey[800],
              ),
              // You can add more details here if needed
            ],
          ),
        ),
      ),
    );
  }
}
