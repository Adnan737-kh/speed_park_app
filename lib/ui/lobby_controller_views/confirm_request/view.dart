import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed_park_app/widgets/appBar.dart';
import 'package:speed_park_app/widgets/mytext.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../../../core/model/register_car/car_registration.dart';
import '../lobby_login/logic.dart';
import '../request_a_car/logic.dart';
import 'logic.dart';

class ConfirmRequestPage extends StatelessWidget {
  final logic = Get.put(ConfirmRequestLogic());
  final requestCarLogic = Get.put(RequestACarLogic());
  final state = Get.find<ConfirmRequestLogic>().state;
  final carRequest = Get.put(RequestACarLogic());
  final lobbyLogic = Get.put(LobbyLoginLogic());


  late final CarRegistrationModel? model;

   ConfirmRequestPage({super.key});
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
          appBar: appBarWidget(text: 'User Requests'),
          body: Obx(() {
            return logic.car.isEmpty
                ? Center(
                    child: Text(
                      'No Car Request',
                      style: normalTextStyle,
                    ),
                  )
                : ListView.builder(
                    itemCount: logic.car.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: kPrimary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),),
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Plate No : ${logic.car[index].plateNumber}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ticket No: ${logic.car[index].ticket}'),
                              Text(' Date : ${logic.car[index].date}'),
                              logic.car[index].validationRequestBy == true
                                  ? Text('Validation Center: ${logic.car[index].validationUserName}')
                                  : Container(), // Add ticket number subtitle
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              logic.car[index].paidUnPaid == true
                                  ? Column(
                                children: [
                                        const Text('Unpaid', style: TextStyle(
                                              color: Colors.red, fontSize: 12)),
                                        Text(
                                          'Total amount:${logic.car[index].amount}',
                                          style: const TextStyle(
                                              color: Colors.red, fontSize: 12)),
                                      ],)
                                  : Container(),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(kPrimary,),),
                                onPressed: () async {
                                  String isCarPaidOrValidated;
                                  if (logic.car[index].validationRequestBy == true) {
                                    isCarPaidOrValidated = 'Validated';
                                  } else {
                                    isCarPaidOrValidated = 'Paid';
                                  }
                                  if (logic.car[index].lobbyRequest == true) {
                                    logic.showAddDriverDialog(context, () {
                                      carRequest.carRequestToConfirmHistory(
                                        context: context,
                                        response: false,
                                        uid: logic.car[index].uid,
                                        index: index,
                                        platNumber: logic.car[index].plateNumber,
                                        registerDate: logic.car[index].date,
                                        registerTime: logic.car[index].time,
                                        locationTypeCheck: logic.car[index].selectLocation,
                                        selectCharges: logic.car[index].selectCharges,
                                        taxInclude: logic.car[index].totalAmountTax,
                                        amountIncludeTax: logic.car[index].amount,
                                        perHour: logic.car[index].perHour,
                                        taxCharge: logic.car[index].taxCharge,
                                        userLocation: logic.car[index].userLocation,
                                        carMade: logic.car[index].carMade,
                                        carModel: logic.car[index].model,
                                        carType: logic.car[index].carType,
                                        color: logic.car[index].color,
                                        owner: logic.car[index].owner,
                                        mobileNumber:logic.car[index].mobileNumber,
                                        recordDamage: logic.car[index].recordDamage,
                                        floorNumber: logic.car[index].floorNumber,
                                        parkingNumber: logic.car[index].parkingNumber,
                                        images: logic.car[index].images,
                                        ticketNumber: logic.car[index].ticket,
                                        validatorName: logic.car[index].validationUserName,
                                        driveName: logic.car[index].driverName.toString().toLowerCase(),
                                        driverRecieve: logic.controllerDriver.text.toString().toLowerCase(),
                                        validationRequestBy: logic.car[index].validationRequestBy,
                                        isCarPaidOrValidated: isCarPaidOrValidated,
                                      );
                                      carRequest.deliveredRequest(
                                          logic.car[index].uid.toString(),
                                          logic.car[index].amount.toString());
                                      logic.controllerDriver.clear();
                                      Get.back();
                                    });
                                  } else {
                                    if (logic.car[index].validationRequestBy == false) {
                                      if ( logic.car[index].totalAmountTax != null &&
                                          logic.car[index].totalAmountTax!.trim().isNotEmpty) {
                                      String amountInitial = logic.car[index].totalAmountTax ?? '0.0';
                                      double totalAmount = double.parse(amountInitial);

                                      // Calculate VAT amount (5% of the total amount)
                                      double vat = totalAmount * 0.05;
                                      totalAmount += vat;
                                      RequestACarLogic.showPaymentDialog(
                                        message: 'Total amount: $totalAmount AED ',
                                        context: context,
                                        onPress: () {
                                          Get.back();
                                          logic.showAddDriverDialog(context,
                                                  () {
                                                carRequest.carRequestToConfirmHistory(
                                                    context: context,
                                                    response: false,
                                                    uid: logic.car[index].uid,
                                                    index: index,
                                                    platNumber: logic.car[index].plateNumber,
                                                    selectCharges: logic.car[index].selectCharges,
                                                    taxInclude: logic.car[index].totalAmountTax,
                                                    amountIncludeTax: logic.car[index].amount,
                                                    perHour: logic.car[index].perHour,
                                                    taxCharge: logic.car[index].taxCharge,
                                                    userLocation: logic.car[index].userLocation,
                                                    carMade: logic.car[index].carMade,
                                                    carModel: logic.car[index].model,
                                                    carType: logic.car[index].carType,
                                                    color: logic.car[index].color,
                                                    owner: logic.car[index].owner,
                                                    mobileNumber: logic.car[index].mobileNumber,
                                                    recordDamage: logic.car[index].recordDamage,
                                                    floorNumber: logic.car[index].floorNumber,
                                                    parkingNumber: logic.car[index].parkingNumber,
                                                    registerDate: logic.car[index].date,
                                                    registerTime: logic.car[index].time,
                                                    locationTypeCheck: logic.car[index].selectLocation,
                                                    images: logic.car[index].images,
                                                    ticketNumber: logic.car[index].ticket,
                                                    validatorName: logic.car[index].validationUserName,
                                                    driveName: logic.car[index].driverName.toString().toLowerCase(),
                                                    driverRecieve: logic.controllerDriver.text.toString().toLowerCase(),
                                                    validationRequestBy: logic.car[index].validationRequestBy,
                                                    isCarPaidOrValidated: isCarPaidOrValidated);
                                                carRequest.deliveredRequest(
                                                    logic.car[index].uid.toString(),
                                                    logic.car[index].amount
                                                        .toString());
                                                logic.controllerDriver.clear();
                                                Get.back();
                                              });
                                        },
                                      );
                                      }else{
                                        carRequest.carRequestToConfirmHistory(
                                            context: context,
                                            response: false,
                                            uid: logic.car[index].uid,
                                            index: index,
                                            platNumber: logic.car[index].plateNumber,
                                            selectCharges: logic.car[index].selectCharges,
                                            taxInclude: logic.car[index].totalAmountTax,
                                            amountIncludeTax: logic.car[index].amount,
                                            perHour: logic.car[index].perHour,
                                            taxCharge: logic.car[index].taxCharge,
                                            userLocation: logic.car[index].userLocation,
                                            carMade: logic.car[index].carMade,
                                            carModel: logic.car[index].model,
                                            carType: logic.car[index].carType,
                                            color: logic.car[index].color,
                                            owner: logic.car[index].owner,
                                            mobileNumber: logic.car[index].mobileNumber,
                                            recordDamage: logic.car[index].recordDamage,
                                            floorNumber: logic.car[index].floorNumber,
                                            parkingNumber: logic.car[index].parkingNumber,
                                            registerDate: logic.car[index].date,
                                            registerTime: logic.car[index].time,
                                            locationTypeCheck: logic.car[index].selectLocation,
                                            images: logic.car[index].images,
                                            ticketNumber: logic.car[index].ticket,
                                            validatorName: logic.car[index].validationUserName,
                                            driveName: logic.car[index].driverName.toString().toLowerCase(),
                                            driverRecieve: logic.controllerDriver.text.toString().toLowerCase(),
                                            validationRequestBy: logic.car[index].validationRequestBy,
                                            isCarPaidOrValidated: isCarPaidOrValidated);
                                        carRequest.deliveredRequest(
                                            logic.car[index].uid.toString(),
                                            logic.car[index].amount
                                                .toString());
                                        logic.controllerDriver.clear();
                                        Get.back();
                                      }


                                    } else {
                                      carRequest.deliveredRequest(
                                          logic.car[index].uid.toString(),
                                          logic.car[index].amount.toString());
                                      logic.controllerDriver.clear();
                                    }
                                    carRequest.deliveredRequest(
                                        logic.car[index].uid.toString(),
                                        logic.car[index].amount.toString());
                                    logic.controllerDriver.clear();
                                  }

                                },
                                child: MyText(
                                  text: logic.car[index].lobbyRequest == false
                                      ? 'Accept'
                                      : 'Delivered',
                                  color: white,
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                      );
                    },
                  );
          })),
    );
  }
}
