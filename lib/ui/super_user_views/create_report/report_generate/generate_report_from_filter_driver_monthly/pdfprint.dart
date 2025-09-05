import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:speed_park_app/ui/super_user_views/create_report/report_generate/generate_report_from_filter_day/readyprint.dart';

import '../../../../../core/model/history/car_history_model.dart';
import '../../../../../core/model/register_car/car_registration.dart';
import '../../../../../widgets/appBar.dart';
import '../../logic.dart';
import 'logic.dart';
final logic = Get.put(Generate_report_from_filterPage_driver_Monthly_logic());
final homescreen = Get.put(CreateReportLogic());
class ListViewPageofDrivernameMonthly extends StatelessWidget {
  final List<CarHistoryModel> dataSet;

  ListViewPageofDrivernameMonthly({required this.dataSet});

  Future<Uint8List> buildPrintablePagedrivernameMonthlyRep(List<CarHistoryModel> dataSet) async {
    final pdf = await Printing.convertHtml(
      format: PdfPageFormat.a4,
      html: buildHtmlContent(dataSet),
    );
    return pdf;
  }
  final String dateFormat = DateFormat('MMM d, y').format(logic.startDate);
  final String endformatdate = DateFormat('MMM d, y').format(logic.endDate);

  String buildHtmlContent(List<CarHistoryModel> dataSet) {
    double totalAmount = 0.0;

    String dataRows = dataSet.map((car) {
      double amountIncludeTax = double.tryParse(car.amountIncludeTax.toString()) ?? 0.0;
      totalAmount += amountIncludeTax;
      double totalAmounts = double.parse(car.amountIncludeTax ?? '0.0');
      double vat = totalAmounts * 0.05;
      double total = totalAmounts - vat;

      return """
    <tr>
      <td>${dataSet.indexOf(car) + 1}</td>
      <td>${car.ticketNumber}</td>
      <td>${car.carMade}</td>
      <td>${car.platNumber}</td>
      <td>${car.color}</td>
      <td>${car.driverName}</td>
      <td>${car.registerTime}</td>
      <td>${car.driverReceive}</td>
      <td>${car.deliveredTime}</td>
      <td>${total.toStringAsFixed(2)}</td>
      <td>${vat.toStringAsFixed(2)}</td>
      <td>${car.amountIncludeTax}</td>
      <td>${car.userLocation}</td>
    </tr>
  """;
    }).join();
    double completeVAT = totalAmount * 0.05;
    double completeTotal = totalAmount - completeVAT;

    return """
  <html>
    <head>
      <style>
        body {
          text-align: center;
          background-color: #e5dfec;
          color: #000000;
        }
        h1, p {
          margin: 8px;
        }
        table {
          margin: 16px auto;
          border-collapse: collapse;
          width: 100%;
        }
        th, td {
          border: 1px solid black;
          padding: 8px;
          text-align: left;
        }
        th {
          background-color: #fde9d9;
        }
         .summary {
          margin-top: 70px; /* Add 20px margin top */
        }
      </style>
    </head>
    <body>
      <h1>SPEED PARK LLC</h1>
      <p>Valet Parking Management System</p>
      <p>Date From: $dateFormat,Date To:$endformatdate</p>
      <p>Site Location: ${homescreen.selectLocation},Driver Name: ${logic.driverNameController.text.toString().toUpperCase()}</p>

      <!-- DataTable -->
      <table>
        <thead>
          <tr>
            <th style="font-size: 10px;">S.NO</th>
            <th style="font-size: 10px;">Ticket No</th>
            <th style="font-size: 10px;">Make</th>
            <th style="font-size: 10px;">Reg No</th>
            <th style="font-size: 10px;">Color</th>
            <th style="font-size: 10px;">VSA IN</th>
            <th style="font-size: 10px;">Time IN</th>
            <th style="font-size: 10px;">VSA Out</th>
            <th style="font-size: 10px;">Time Out</th>
            <th style="font-size: 10px;">Amount</th>
            <th style="font-size: 10px;">VAT</th>
            <th style="font-size: 10px;">Total</th>
             <th style="font-size: 10px;">Remarks</th>
            
          </tr>
        </thead>
        <tbody>
          $dataRows
         
        </tbody>
      </table>

      <!-- Additional Sale Summary Table -->
    <div class="summary">
      <h2>Sale Summary</h2>
      <table>
        <thead>
          <tr>
            <th style="font-size: 10px;">Description</th>
            <th style="font-size: 10px;">Amount</th>
            <th style="font-size: 10px;">VAT</th>
            <th style="font-size: 10px;">Total</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>Total Sale</td>
            
            <td>${completeTotal.toStringAsFixed(2)}</td>
            <td>${completeVAT.toStringAsFixed(2)}</td>
            <td>${totalAmount.toStringAsFixed(2)}</td>
          </tr>
        </tbody>
      </table>
    </div>
    </body>
  </html>
  """;
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(text: 'Result'),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Printing.layoutPdf(
              onLayout: (PdfPageFormat format) async => await buildPrintablePagedrivernameMonthlyRep(dataSet),
            );
          },
          child: const Icon(Icons.print),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding:const  EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: DataTable(
                    columns:const  [
                      DataColumn(label: Text('S.NO')),
                      DataColumn(label: Text('Ticket No')),
                      DataColumn(label: Text('Make')),
                      DataColumn(label: Text('Reg No')),
                      DataColumn(label: Text('Color')),
                      DataColumn(label: Text('VSA IN')),
                      DataColumn(label: Text('Time IN')),
                      DataColumn(label: Text('VSA OUT')),
                      DataColumn(label: Text('Time Out')),
                      DataColumn(label: Text('Amount')),
                      DataColumn(label: Text('VAT')),
                      DataColumn(label: Text('Total')),
                      DataColumn(label: Text('Remarks')),
                    ],
                    rows: dataSet.map((car) {
                      // Calculate VAT (5% of the total amount)
                      double totalAmount = double.parse(car.amountIncludeTax ?? '0.0');
                      double vat = totalAmount * 0.05;
                      double total = totalAmount - vat;

                      return DataRow(cells: [
                        DataCell(Text((dataSet.indexOf(car) + 1).toString())),
                        DataCell(Text(car.ticketNumber.toString())),
                        DataCell(Text(car.carMade.toString())),
                        DataCell(Text(car.platNumber.toString())),
                        DataCell(Text(car.color.toString())),
                        DataCell(Text(car.driverName.toString())),
                        DataCell(Text(car.registerTime.toString())),
                        DataCell(Text(car.driverReceive.toString())),
                        DataCell(Text(car.deliveredTime.toString())),
                        DataCell(Text(total.toStringAsFixed(2))),
                        DataCell(Text(vat.toStringAsFixed(2))),
                        DataCell(Text(car.amountIncludeTax.toString())),
                        DataCell(Text(car.userLocation.toString())),

                      ]);
                    }).toList(),


                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
