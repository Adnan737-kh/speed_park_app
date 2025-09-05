import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speed_park_app/widgets/elevated_button.dart';
import 'package:speed_park_app/widgets/mytext.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../show_locaion_previous_records/view.dart';
import 'logic.dart';

final logic = Get.put(CreateLocationLogic());
final state = Get.find<CreateLocationLogic>().state;

class CreateLocationPage extends StatelessWidget {
  const CreateLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => CreateLocationLogic());

    return Scaffold(
      body: SizedBox(
        height: Get.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.sp),
                ...List.generate(
                  2,
                  (index) => Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: TextFormField(
                      controller: index == 0
                          ? logic.codeController
                          : logic.descController,

                      decoration: InputDecoration(
                        hintText: logic.text[index],
                        labelText: logic.text[index],
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
                  ),
                ),
                const SizedBox(height: 15),
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
                      // Hide other dropdowns and fields by setting their values to null or empty
                      logic.updateChargesField('');
                      //logic.updateAmountController('');
                      logic.updateTaxChargesField('');
                      //logic.updateTaxController('');
                    }
                  },
                  dropList: logic.items,
                  hintText: 'Location Type',
                ),

                const SizedBox(height: 15),

                GetBuilder<CreateLocationLogic>(
                  builder: (createLocationLogic) {
                    return logic.selectedValue == 'Paid'
                        ? DropDownWidget(
                            dropList: logic.charges,
                            onChanged: (value) {
                              logic.updateChargesField(value);
                            },
                            hintText: 'Select Charges',
                          )
                        : Container();
                  },
                ),
                /** Per Services Work***/
                logic.selectedValue == 'Normal'?Container(): GetBuilder<CreateLocationLogic>(
                  builder: (createLocationLogic) {
                    return logic.selectCharges == 'Per Services'
                        ? Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: TextFormField(
                        controller: logic.amountController,
                        decoration: InputDecoration(
                          hintText: 'Amount',
                          labelText: 'Amount',
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
                const SizedBox(height: 10,),
                logic.selectedValue == 'Normal'?Container():GetBuilder<CreateLocationLogic>(
                  builder: (createLocationLogic) {
                    return logic.selectCharges == 'Per Services'
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
                const SizedBox(height: 10,),
                logic.selectedValue == 'Normal'?Container(): GetBuilder<CreateLocationLogic>(
                  builder: (createLocationLogic) {
                    return logic.selectCharges == 'Per Services'?logic.selectTaxCharges != 'Tax Inclusive'
                        ? Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: TextFormField(
                        controller: logic.totalAmountWithTaxController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Total amount with Tax',
                          labelText: 'Total amount with Tax',
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
                        : Container():Container();
                  },
                ),
                /** Per Services Work End***/



                /** Per Hour Work***/
                logic.selectedValue == 'Normal'?Container(): GetBuilder<CreateLocationLogic>(
                  builder: (createLocationLogic) {
                    return logic.selectCharges == 'Per hour'
                        ? Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: TextFormField(
                        controller: logic.amountController,

                        decoration: InputDecoration(
                          hintText: 'per hour amount',
                          labelText: 'per hour amount',
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
                const SizedBox(height: 15,),
                logic.selectedValue == 'Normal'?Container(): GetBuilder<CreateLocationLogic>(
                  builder: (createLocationLogic) {
                    return logic.selectCharges == 'Per hour'
                        ? Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: TextFormField(
                        controller: logic.perHourController,

                        decoration: InputDecoration(
                          hintText: 'Additional per hour amount',
                          labelText: 'Additional per hour amount',
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
                const SizedBox(height: 20,),
                logic.selectedValue == 'Normal'?Container():GetBuilder<CreateLocationLogic>(
                  builder: (createLocationLogic) {
                    return logic.selectCharges == 'Per hour'
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
                const SizedBox(height: 15,),
                logic.selectedValue == 'Normal'?Container(): GetBuilder<CreateLocationLogic>(
                  builder: (createLocationLogic) {
                    return logic.selectCharges == 'Per hour'?logic.selectTaxCharges != 'Tax Inclusive'
                        ? Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: TextFormField(
                        controller: logic.totalAmountWithTaxController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Total amount with Tax',
                          labelText: 'Total amount with Tax',
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
                        : Container():Container();
                  },
                ),
                /** Per Hour Work End***/

                SizedBox(height: Get.height * 0.1),
                AppButton(
                  textColor: kButton,
                  text: 'Save Location',
                  onPress: () async {
                    await logic.saveData(context);
                    // logic.checkFunction(context);
                  },
                  bgColor: Colors.transparent,
                ),
                const SizedBox(height: 15),
                AppButton(
                  text: 'Show Previous Records',
                  onPress: () {
                    Get.to(() => ShowPreviousRecordsPage());
                  },
                ),
                SizedBox(height: 16.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

CreateLocationLogic imageController = Get.put(CreateLocationLogic());

class UploadImageWidget extends StatelessWidget {
  const UploadImageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateLocationLogic>(
        initState: (_) {},
        init: CreateLocationLogic(),
        builder: (_) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            width: double.infinity,
            height: 150.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.blue,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  kPrimary.withOpacity(0.7),
                  kPrimary,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: imageController.images.isEmpty
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload,
                        color: Colors.white,
                      ),
                      MyText(
                        text: 'Upload Image',
                        color: white,
                      )
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText(
                            text: 'UPLOAD UP TO 6 PHOTOS',
                            color: white,
                            fontFamily: '',
                            size: 14.sp,
                            weight: FontWeight.bold,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: white,
                            size: 15,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(imageController.images.length,
                              (index) {
                            return GestureDetector(
                              onTap: () {
                                _edit(index, context);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    imageController.images[index],
                                    height: 50.h,
                                    width: 50.w,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 10),
                      MyText(
                        text: 'Tap on images to edit them',
                        color: white,
                        fontFamily: '',
                        size: 14.sp,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),
          );
        });
  }
}

void _edit(int index, context) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Remove Image'),
            onPressed: () {
              // remove the image at the given index
              imageController.removeImage(index);
              Get.back();
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
      );
    },
  );
}

class DropDownWidget extends StatelessWidget {
  const DropDownWidget({
    super.key,
    required this.dropList,
    required this.hintText,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.selectedValue,
  });

  final List<String> dropList;
  final String hintText;
  final String? selectedValue;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    // Ensure dropList has unique values
    final uniqueDropList = dropList.toSet().toList();

    // Ensure selectedValue is valid
    final isSelectedValueValid = uniqueDropList.contains(selectedValue);

    return DropdownButtonFormField2(
      isExpanded: true,
      value: isSelectedValueValid ? selectedValue : null, // Ensure valid value
      onSaved: onSaved,
      validator: validator,
      onChanged: onChanged,
      style: TextStyle(
        color: black,
        fontFamily: 'Poppins',
        fontSize: 12.sp,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: Get.height * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: kStyle,
        prefixIconConstraints: const BoxConstraints(maxWidth: 0),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        enabledBorder: kBorder2,
        border: kBorder2,
        fillColor: kPrimary.withOpacity(0.2),
        filled: true,
      ),
      items: uniqueDropList.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}


class CarType {
  final String title;
  final List<String>? models;

  CarType({
    required this.title,
    this.models,
  });
}
