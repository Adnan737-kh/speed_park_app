import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../../../../../core/model/history/car_history_model.dart';
import '../../../../../widgets/appBar.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart' as pdfwidgets;
import 'package:pdf/widgets.dart' as pw;

import '../../super_user_views/create_report/logic.dart';
import '../../super_user_views/create_report/report_generate/generate_report_from_filter_day/logic.dart';

final logic = Get.put(GenerateReportFromFilterLogicDay());
final homeScreen = Get.put(CreateReportLogic());

class SalesReport extends StatelessWidget {
  final List<CarHistoryModel> dataSet;
  final double totalOriginalAmount = 0;
  final double totalVAT = 0;
  final double totalAmountIncludingVAT = 0;

  SalesReport({super.key, required this.dataSet});

  Future<Uint8List> buildPrintablePageDay(List<CarHistoryModel> dataSet) async {
    try {
      final pdfBytes = await _convertHtmlToPdf(buildHtmlContent(dataSet));
      return pdfBytes;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error during PDF conversion: $e\n$stackTrace');
      }
      return Uint8List(
          0); // or handle the error in a way that suits your application
    }
  }

  Future<Uint8List> _convertHtmlToPdf(String htmlContent) async {
    final pdfWidgets = pdfwidgets.HTMLToPdf();
    final widgets = await pdfWidgets.convert(htmlContent);

    // Convert the list of widgets to a Uint8List (PDF bytes)
    final pdfDocument = pdfwidgets.Document();
    pdfDocument.addPage(pdfwidgets.MultiPage(
      pageFormat: pdfwidgets.PdfPageFormat.a4,
      build: (context) => widgets,
    ));

    final pdfBytes = await pdfDocument.save();
    return Uint8List.fromList(pdfBytes);
  }

  final String dateFormat = DateFormat('MMM d, y').format(logic.startDate);
  final String endFormatDate = DateFormat('MMM d, y').format(logic.endDate);

  String buildHtmlContent(List<CarHistoryModel> dataSet) {
    double totalAmount = 0.0;

    // Generate rows for each car in the dataset
    String dataRows = dataSet.map((car) {
      // Calculate the total amount for the car including VAT
      String amountInitial = car.amountIncludeTax ?? '0.0';
      double totalAmount = double.parse(amountInitial);

      // Calculate VAT amount (5% of the total amount)
      double vat = totalAmount * 0.05;

      // Add VAT to the total amount
      totalAmount += vat;

      // Now, totalAmount holds the sum of the original amount and VAT
      // If you still need the original amount, you can calculate it separately
      double originalAmount = totalAmount - vat;
      print(car.deliveredTime);

      // Construct the HTML row for the car data
      // Construct the HTML row for the car data
      return """
      <tr>
       <td style="font-size: 10px;">${dataSet.indexOf(car) + 1}</td>
       <td style="font-size: 10px;">${car.ticketNumber}</td>
     
      <td style="font-size: 10px;">${car.carMade}</td>
      <td style="font-size: 10px;">${car.platNumber}</td>
      <td style="font-size: 10px;">${car.color}</td>
      <td style="font-size: 10px;">${car.driverName}</td>
      <td style="font-size: 10px;">${car.registerTime}</td>
      <td style="font-size: 10px;">${car.driverReceive}</td>
      <td style="font-size: 10px;">${car.deliveredTime}</td>
      <td style="font-size: 10px;">${originalAmount.toStringAsFixed(2)}</td>
      <td style="font-size: 10px;">${vat.toStringAsFixed(2)}</td>
      <td style="font-size: 10px;">${totalAmount.toStringAsFixed(2)}</td>
      <td style="font-size: 10px;">${car.isCarPaidOrValidated}</td>
    </tr>
    """;
    }).join();

    // Calculate the total of all original amounts
    double totalOriginalAmount = dataSet
        .map((car) => double.parse(car.amountIncludeTax ?? '0.0'))
        .reduce((value, element) => value + element);

// Calculate the total of all VAT amounts
    double totalVAT = dataSet
        .map((car) => double.parse(car.amountIncludeTax ?? '0.0') * 0.05)
        .reduce((value, element) => value + element);

// Calculate the total of all amounts including VAT
    double totalAmountIncludingVAT = dataSet
        .map((car) => double.parse(car.amountIncludeTax ?? '0.0'))
        .map((amount) => amount + amount * 0.05)
        .reduce((value, element) => value + element);

    String dataRows2;
    double totalOriginalAmountForUnpaidCars = 0.0;
    double addVATForUnpaidCars = 0.0;
    double addTotalForUnpaidCars = 0.0;
    double minusPaidOriginalAmountFromUnPaid = 0.0;
    double minusPaidVATAmountFromUnPaidVAT = 0.0;
    double minusPaidTotalAmountFromUnPaidTotal = 0.0;

// Check if there are unpaid cars
    bool unpaidCarFound =
        dataSet.any((car) => car.isCarPaidOrValidated != 'Paid');

    if (unpaidCarFound) {
      // Unpaid cars found, generate HTML rows for them

      dataRows2 = dataSet
          .map((car) {
            if (car.isCarPaidOrValidated != 'Paid') {
              String amountInitial = car.amountIncludeTax ?? '0.0';
              double totalAmount = double.parse(amountInitial);

              // Calculate VAT amount (5% of the total amount)
              double vat = totalAmount * 0.05;

              // Add VAT to the total amount
              totalAmount += vat;

              // Now, totalAmount holds the sum of the original amount and VAT
              // If you still need the original amount, you can calculate it separately
              double originalAmount = totalAmount - vat;

              // Add original amount to the total original amount for unpaid cars
              totalOriginalAmountForUnpaidCars += originalAmount;
              addVATForUnpaidCars += vat;
              addTotalForUnpaidCars += totalAmount;

              minusPaidOriginalAmountFromUnPaid =
                  totalOriginalAmount - totalOriginalAmountForUnpaidCars;
              minusPaidVATAmountFromUnPaidVAT = totalVAT - addVATForUnpaidCars;
              minusPaidTotalAmountFromUnPaidTotal =
                  totalAmountIncludingVAT - addTotalForUnpaidCars;

              return """
    
     <tr>
   
       <td>${car.validatorName}</td>
         <td>${originalAmount.toStringAsFixed(2)}</td>
         <td>${vat.toStringAsFixed(2)}</td>  
           <td>${totalAmount.toStringAsFixed(2)}</td>
      </tr>
      """;
            } else {
              return null; // Return null for paid cars
            }
          })
          .where((element) => element != null)
          .join();
    } else {
      // No unpaid cars found, set dataRows2 to the message
      dataRows2 = """
  <tr>
   <td>N/A</td>
   <td>N/A</td>
   <td>N/A</td>
   <td>N/A</td>
  </tr>
  """;
    }

    // Calculate complete VAT and total
    double completeVAT = totalAmount * 0.05;
    double completeTotal = totalAmount + completeVAT;

    // Construct the HTML for the entire page
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
            margin-top: 70px;
          }
        </style>
      </head>
      <body>
        <h1>SPEED PARK LLC</h1>
        <p>Valet Parking Management System</p>
        <p>Date From: ${dateFormat}</p>
        <p>Site Location: ${homeScreen.selectLocation},</p>
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
      </body>
      <body>
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
                <td style="font-size: 50px;">${totalOriginalAmount.toStringAsFixed(2)}</td>
                <td>${totalVAT.toStringAsFixed(2)}</td>
                <td>${totalAmountIncludingVAT.toStringAsFixed(2)}</td>
            </tr>
            <tr>
                <td>Validated</td>
                <td>${totalOriginalAmountForUnpaidCars.toStringAsFixed(2)}</td> <!-- Replace with actual value -->
                <td>${addVATForUnpaidCars.toStringAsFixed(2)}</td> <!-- Replace with actual value -->
                <td>${addTotalForUnpaidCars.toStringAsFixed(2)}</td> <!-- Replace with actual value -->
            </tr>
            <tr>
                <td>Net Sale</td>
                <td>${minusPaidOriginalAmountFromUnPaid.toStringAsFixed(2)}</td> <!-- Replace with actual value -->
                <td>${minusPaidVATAmountFromUnPaidVAT.toStringAsFixed(2)}</td> <!-- Replace with actual value -->
                <td>${minusPaidTotalAmountFromUnPaidTotal.toStringAsFixed(2)}</td> <!-- Replace with actual value -->
            </tr>
        </tbody>
    </table>

</body>

      
       <body>
        <h2>Validation Summary</h2>
   
        <table>
          <thead>
            <tr>
              <th style="font-size: 10px;">Validation Center</th>
              <th style="font-size: 10px;">Amount</th>
              <th style="font-size: 10px;">VAT</th>
              <th style="font-size: 10px;">Total</th>
          
            </tr>
          </thead>
          <tbody>
            $dataRows2
          </tbody>
        </table>
     
      </body>
    </html>
  """;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(text: 'Sales Summary'),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Printing.layoutPdf(
              onLayout: (PdfPageFormat format) async =>
                  await buildPrintablePageDay(dataSet),
            );
          },
          child: const Icon(Icons.print),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DataTable(
                columns: const [
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
                  String amountInitial = car.amountIncludeTax ?? '0.0';
                  print('amount initial $amountInitial');
                  double totalAmount = double.parse(amountInitial);

                  // Calculate VAT amount (5% of the total amount)
                  double vat = totalAmount * 0.05;

                  // Add VAT to the total amount
                  totalAmount += vat;

                  // Now, totalAmount holds the sum of the original amount and VAT
                  // If you still need the original amount, you can calculate it separately
                  double originalAmount = totalAmount - vat;

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
                    DataCell(Text(originalAmount.toStringAsFixed(2))),
                    DataCell(Text(vat.toStringAsFixed(2))),
                    DataCell(Text(totalAmount.toString())),
                    DataCell(Text(car.isCarPaidOrValidated.toString())),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }



  late pw.Column table1 = pw.Column(
      crossAxisAlignment: pdfwidgets.CrossAxisAlignment.start,
      children: [
        pw.Text('SPEED PAR LLC ',
            style: pw.TextStyle(
                fontSize: 40, fontWeight: pdfwidgets.FontWeight.bold)),
        pw.SizedBox(height: 15),
        pw.Text('Valet Parking Management System ',
            style: pw.TextStyle(
                fontSize: 20, fontWeight: pdfwidgets.FontWeight.bold)),
        pw.SizedBox(height: 15),
        pw.Text(' Date From: $dateFormat',
            style: pw.TextStyle(
                fontSize: 20, fontWeight: pdfwidgets.FontWeight.bold)),
        pw.SizedBox(height: 15),
        pw.Text('Site Location: ${homeScreen.selectLocation},',
            style: pw.TextStyle(
                fontSize: 20, fontWeight: pdfwidgets.FontWeight.bold)),
        pw.Table(
          border: pw.TableBorder.all(), // Add borders to the table
          // headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          // headerDecoration: const pw.BoxDecoration(color: PdfColors.white),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(),
              children: [
                'S.NO',
                'Ticket No',
                'Make',
                'Reg No',
                'Color',
                'VSA IN',
                'Time IN',
                'VSA OUT',
                'Time Out',
                'Amount',
                'VAT',
                'Total',
                'Remarks',
              ].map((title) => pw.Column(children: [pw.Text(title)])).toList(),
            ),
            ...dataSet.map((car) {
              String amountInitial = car.amountIncludeTax ?? '0.0';
              double totalAmount = double.parse(amountInitial);

              // Calculate VAT amount (5% of the total amount)
              double vat = totalAmount * 0.05;

              // Add VAT to the total amount
              totalAmount += vat;

              // Now, totalAmount holds the sum of the original amount and VAT
              // If you still need the original amount, you can calculate it separately
              double originalAmount = totalAmount - vat;

              return pw.TableRow(
                // Add data rows
                children: [
                  pw.Text((dataSet.indexOf(car) + 1).toString(),
                      style: const pw.TextStyle(
                        fontSize: 10,
                      )),
                  pw.Text(car.ticketNumber.toString(),
                      style: const pw.TextStyle(
                        fontSize: 10,
                      )),
                  pw.Text(car.carMade.toString(),
                      style: const pw.TextStyle(
                        fontSize: 10,
                      )),
                  pw.Text(car.platNumber.toString(),
                      style: const pw.TextStyle(
                        fontSize: 10,
                      )),
                  pw.Text(car.color.toString(),
                      style: const pw.TextStyle(
                        fontSize: 10,
                      )),
                  pw.Text(car.driverName.toString(),
                      style: const pw.TextStyle(
                        fontSize: 10,
                      )),
                  pw.Text(car.registerTime.toString(),
                      style: const pw.TextStyle(
                        fontSize: 10,
                      )),
                  pw.Text(car.driverReceive.toString(),
                      style: const pw.TextStyle(
                        fontSize: 10,
                      )),
                  pw.Text(car.deliveredTime.toString(),
                      style: const pw.TextStyle(
                        fontSize: 10,
                      )),
                  pw.Text(originalAmount.toStringAsFixed(2),
                      style: const pw.TextStyle(
                        fontSize: 10,
                      )),
                  pw.Text(vat.toStringAsFixed(2),
                      style: const pw.TextStyle(
                        fontSize: 10,
                      )),
                  pw.Text(totalAmount.toStringAsFixed(2),
                      style: const pw.TextStyle(
                        fontSize: 10,
                      )),
                  pw.Text(car.isCarPaidOrValidated.toString(),
                      style: const pw.TextStyle(
                        fontSize: 10,
                      )),
                ],
              );
            }).toList(),
          ],
        ),
      ]);
}
