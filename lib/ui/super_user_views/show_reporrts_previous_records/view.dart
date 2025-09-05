import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed_park_app/ui/super_user_views/show_reporrts_previous_records/logic.dart';
import 'package:speed_park_app/widgets/elevated_button.dart';

import '../../../core/constants/colors.dart';
import '../../../widgets/appBar.dart';
import '../../../widgets/mytext.dart';

ShowReportsPreviousRecordsLogic logic =
    Get.put(ShowReportsPreviousRecordsLogic());

class ShowPreviousReportsRecordsPage extends StatelessWidget {
  // final state = Get.find<ShowReportsPreviousRecordsLogic>().state;

  List<String> headers = ['Time', 'Description', 'Action'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(text: 'Previous Records'),
        body: GetBuilder<ShowReportsPreviousRecordsLogic>(
            init: ShowReportsPreviousRecordsLogic(),
            initState: (_) {
              // logic.fetchData();
            },
            builder: (logic) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Expanded(
                      child: Obx(
                        () {
                          final reportData = logic.reportData;

                          if (reportData.isNotEmpty) {
                            return Table(
                              border: TableBorder.symmetric(
                                inside: BorderSide(color: kGrey),
                              ),
                              defaultColumnWidth: FixedColumnWidth(
                                Get.width / 3,
                              ),
                              children: [
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: kPrimary,
                                  ),
                                  children: [
                                    ...List.generate(
                                      headers.length,
                                      (index) => TableCell(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: MyText(
                                          text: headers[index],
                                          color: white,
                                        ),
                                      )),
                                    )
                                  ],
                                ),
                                for (var report in reportData)
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child:
                                              MyText(text: report.time ?? ''),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: MyText(
                                              text: report.description ?? ''),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.off(() => AlertDialogWidget(
                                                    uid: report.uid.toString(),
                                                    description: report
                                                        .description
                                                        .toString(),
                                                  ));
                                              // showDialog(
                                              //   context: context,
                                              //   builder:
                                              //       (BuildContext context) {
                                              //     return AlertDialogWidget(
                                              //       uid: report.uid.toString(),
                                              //       description: report
                                              //           .description
                                              //           .toString(),
                                              //     );
                                              //   },
                                              // );
                                            },
                                            child: MyText(
                                              text: 'Edit',
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                color: kPrimary,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

class AlertDialogWidget extends StatelessWidget {
  AlertDialogWidget({this.index, this.uid, this.description}) {}
  String? description;
  int? index;
  String? uid;

  @override
  Widget build(BuildContext context) {
    var reportBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: kPrimary.withOpacity(0.5),
      ),
      borderRadius: BorderRadius.circular(15),
    );
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(text: 'Edit Reports'),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                maxLines: 6,
                controller: logic.descController,
                decoration: InputDecoration(
                  border: reportBorder,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimary),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: reportBorder,
                  hintText: '$description',
                ),
              ),
              SizedBox(height: 16),
              AppButton(
                text: 'Update Report',
                onPress: () {
                  logic.updateReport(uid.toString(),
                      logic.descController.text.toString(), context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
