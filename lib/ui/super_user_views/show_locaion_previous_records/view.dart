import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speed_park_app/ui/super_user_views/show_locaion_previous_records/logic.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../../../core/model/location/location_model.dart';
import '../../../widgets/appBar.dart';
import '../../../widgets/elevated_button.dart';
import '../../../widgets/mytext.dart';
import '../create_location/view.dart';

final ShowPreviousRecordsLogic dataController =
    Get.put(ShowPreviousRecordsLogic());

class ShowPreviousRecordsPage extends GetView<ShowPreviousRecordsLogic> {
  final List<String> headers = [
    'Location',
    'Total Staff',
    'Location Type',
    'Action',
    'Delete'
  ];

  ShowPreviousRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(text: 'Previous Record'),
        body: GetBuilder<ShowPreviousRecordsLogic>(
            init: ShowPreviousRecordsLogic(),
            initState: (_) {},
            builder: (logic) {
              return Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Obx(
                          () {
                            final locationData = dataController.locationData;
                            if (dataController.locationData.isNotEmpty) {
                              return Table(
                                border: TableBorder.symmetric(
                                  inside: BorderSide(color: kGrey),),
                                defaultColumnWidth: FixedColumnWidth(
                                  Get.width / 4,
                                ),
                                children: [
                                  TableRow(
                                    decoration: const BoxDecoration(
                                      color: kPrimary,),
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
                                  for (var location in locationData)
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: MyText(
                                                text: location.code ?? ''),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: MyText(
                                                text: location.desc ?? ''),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: MyText(
                                                text: location.selectLocation ??
                                                    ''),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                Get.to(
                                                  () => AlertDialogWidget(
                                                    uid: location.uid,
                                                    //staff: location.staff,
                                                    location: location.code,
                                                    description: location.desc,
                                                    model: location,
                                                  ),
                                                );
                                              },
                                              child: const MyText(
                                                text: 'Edit',
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                logic.delete(
                                                    location.uid.toString());
                                              },
                                              child: const MyText(
                                                text: 'Delete',
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
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: black,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class AlertDialogWidget extends StatelessWidget {
  final logic = Get.put(ShowPreviousRecordsLogic());
  AlertDialogWidget({
    super.key,
    this.uid,
    this.description,
    this.location,
    this.model,
    // this.staff,
  });
  final String? uid;
  final String? description;
  final LocationModel? model;
  // String? staff;
  final String? location;
  @override
  Widget build(BuildContext context) {
    List hints = [description, location];

    // print('loc@@ $location and##### ${model?.selectLocation}');
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(text: 'Edit Locations'),
        body: GetBuilder<ShowPreviousRecordsLogic>(
            initState: (_) {},
            init: ShowPreviousRecordsLogic(),
            builder: (logic) {
              return SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.sp),
                      ...List.generate(
                        hints.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: TextFormField(
                            controller: index == 0
                                ? logic.descController
                                : logic.locationController,
                            decoration: InputDecoration(
                              hintText: hints[index],
                              labelText: hints[index],
                              hintStyle: kStyle,
                              labelStyle: kStyle,
                              fillColor: kPrimary.withOpacity(0.2),
                              filled: true,
                              border: kBorder,
                              focusedBorder: kBorder,
                              enabledBorder: kBorder,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DropDownWidget(
                        validator: (value) {
                          if (value == null) {
                            return 'Required*';
                          }
                          return null;
                        },
                        selectedValue: logic.selectedValue,
                        onChanged: (value) {
                          logic.updateField(value);
                          // Check if 'Location Type' is 'Normal'
                          if (value == 'Normal') {
                            logic.updateChargesField('');
                            //logic.updateAmountController('');
                            logic.updateTaxChargesField('');
                          }
                        },
                        dropList: logic.items,
                        hintText: 'Location Type',
                      ),
                      const SizedBox(height: 15),
                      model?.selectLocation == 'Paid'
                          ? GetBuilder<ShowPreviousRecordsLogic>(
                        builder: (showPreviousRecordsLogic) {
                          return
                              DropDownWidget(
                                  dropList: logic.charges,
                                  onChanged: (value) {
                                    logic.updateChargesField(value);
                                  },
                                  hintText: 'Select Charges',
                                );
                          },
                      ) : Container(),

                      model?.selectCharges == 'Per Services'
                          ? GetBuilder<ShowPreviousRecordsLogic>(
                              builder: (showPreviousRecordsLogic) {
                                return model?.selectCharges == 'Per Services'
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: TextFormField(
                                          controller: logic.amountController,
                                          decoration: InputDecoration(
                                            hintText: 'Amount',
                                            labelText: model?.amount,
                                            hintStyle: kStyle,
                                            labelStyle: kStyle,
                                            fillColor: kPrimary.withOpacity(0.2),
                                            filled: true,
                                            border: kBorder2,
                                            focusedBorder: kBorder2,
                                            enabledBorder: kBorder2,
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                          ),
                                        ),
                                      )
                                    : Container();
                              },
                            ) : Container(),
                      const SizedBox(
                        height: 10,
                      ),
                      model?.selectCharges != 'Per Services'
                          ? Container()
                          : GetBuilder<ShowPreviousRecordsLogic>(
                              builder: (showPreviousRecordsLogic) {
                                return  model?.selectCharges == 'Per Services'
                                    ? DropDownWidget(
                                        dropList: logic.taxCharges,
                                        onChanged: (value) {
                                          logic.updateTaxChargesField(value);
                                        },
                                        hintText: 'Select Tax',
                                      )
                                    : Container();
                              },
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      model?.selectCharges != 'Per Services'
                          ? Container()
                          : GetBuilder<ShowPreviousRecordsLogic>(
                              builder: (showPreviousRecordsLogic) {
                                return model?.selectCharges == 'Per Services'
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 15),
                                            child: TextFormField(
                                              controller: logic.totalAmountWithTaxController,
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                hintText: 'Total amount with Tax',
                                                labelText: model?.totalAmountWithTax,
                                                hintStyle: kStyle,
                                                labelStyle: kStyle,
                                                fillColor: kPrimary.withOpacity(0.2),
                                                filled: true,
                                                border: kBorder2,
                                                focusedBorder: kBorder2,
                                                enabledBorder: kBorder2,
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                              ),
                                            ),
                                          )
                                        : Container();
                              },
                            ),
                      /** Per Services Work End***/

                      /** Per Hour Work***/
                      model?.selectCharges != 'Per hour'
                          ? Container()
                          : GetBuilder<ShowPreviousRecordsLogic>(
                              builder: (showPreviousRecordsLogic) {
                                return model?.selectCharges == 'Per hour'
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: TextFormField(
                                          controller: logic.amountController,
                                          decoration: InputDecoration(
                                            hintText: 'per hour amount',
                                            labelText: model?.perHour,
                                            hintStyle: kStyle,
                                            labelStyle: kStyle,
                                            fillColor: kPrimary.withOpacity(0.2),
                                            filled: true,
                                            border: kBorder2,
                                            focusedBorder: kBorder2,
                                            enabledBorder: kBorder2,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10),
                                          ),
                                        ),
                                      )
                                    : Container();
                              },
                            ),
                      const SizedBox(
                        height: 15,
                      ),
                      model?.selectCharges != 'Per hour'
                          ? Container()
                          : GetBuilder<ShowPreviousRecordsLogic>(
                              builder: (showPreviousRecordsLogic) {
                                return model?.selectCharges == 'Per hour'
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: TextFormField(
                                          controller: logic.perHourController,
                                          decoration: InputDecoration(
                                            hintText: 'Additional per hour amount',
                                            labelText: model?.amount,
                                            hintStyle: kStyle,
                                            labelStyle: kStyle,
                                            fillColor: kPrimary.withOpacity(0.2),
                                            filled: true,
                                            border: kBorder2,
                                            focusedBorder: kBorder2,
                                            enabledBorder: kBorder2,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10),
                                          ),
                                        ),
                                      )
                                    : Container();
                              },
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      model?.selectCharges != 'Per hour'
                          ? Container()
                          : GetBuilder<ShowPreviousRecordsLogic>(
                              builder: (showPreviousRecordsLogic) {
                                return model?.selectCharges == 'Per hour'
                                    ? DropDownWidget(
                                        dropList: logic.taxCharges,
                                        onChanged: (value) {
                                          logic.updateTaxChargesField(value);},
                                        hintText: 'Select Tax',
                                      )
                                    : Container();
                              },
                            ),
                      const SizedBox(
                        height: 15,
                      ),
                      model?.selectCharges != 'Per hour'
                          ? Container()
                          : GetBuilder<ShowPreviousRecordsLogic>(
                              builder: (showPreviousRecordsLogic) {
                                return model?.selectCharges == 'Per hour'
                                    ? logic.selectTaxCharges != 'Tax Inclusive'
                                        ? Padding(
                                            padding: const EdgeInsets.only(top: 15),
                                            child: TextFormField(
                                              controller: logic.totalAmountWithTaxController,
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                hintText: 'Total amount with Tax',
                                                labelText: model?.totalAmountWithTax,
                                                hintStyle: kStyle,
                                                labelStyle: kStyle,
                                                fillColor: kPrimary.withOpacity(0.2),
                                                filled: true,
                                                border: kBorder2,
                                                focusedBorder: kBorder2,
                                                enabledBorder: kBorder2,
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 10)
                                              ),
                                            ),
                                          )
                                        : Container()
                                    : Container();
                              },
                            ),
                      /** Per Hour Work End***/
                      const SizedBox(height: 15),
                      AppButton(
                        textColor: kButton,
                        text: 'Update Location',
                        onPress: () {
                          logic.updateLocation(
                            uid: uid.toString(),
                            description: logic.descController.text.toString(),
                            location: logic.locationController.text.toString(),
                            context: context,
                            model: model!,
                          );
                        },
                        bgColor: Colors.transparent,
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
