import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../widgets/appBar.dart';
import '../../../widgets/elevated_button.dart';
import 'logic.dart';

class NonPaidLocationPage extends StatelessWidget {
  final logic = Get.put(NonPaidLocationLogic());
  final state = Get.find<NonPaidLocationLogic>().state;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(text: 'Non-Paid Location'),
        body: GetBuilder<NonPaidLocationLogic>(builder: (logic) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Record Customer Visit:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: logic.rNameController,
                  decoration: InputDecoration(labelText: 'Restaurant Name'),
                ),
                SizedBox(height: 20),
                AppButton(
                    text: 'Save Customer Record',
                    onPress: () {
                      logic.updateList();
                    }),
                SizedBox(height: 20),
                Text(
                  'Customer Visits:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: logic.customerVisits.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(logic.customerVisits[index]),
                      );
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
