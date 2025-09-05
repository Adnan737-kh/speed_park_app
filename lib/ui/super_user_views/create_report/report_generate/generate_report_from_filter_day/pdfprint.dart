import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../../../../../core/model/history/car_history_model.dart';
import '../../../../../widgets/appBar.dart';
import '../../../../lobby_controller_views/request_a_car/logic.dart';
import '../../logic.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart' as pdfwidgets;
import 'edit_car.dart';
import 'logic.dart';

final logic = Get.put(GenerateReportFromFilterLogicDay());
final homeScreen = Get.put(CreateReportLogic());
final carRequest = Get.put(RequestACarLogic());
final GenerateReportFromFilterLogicDay controller = Get.put(GenerateReportFromFilterLogicDay());


class ListViewPageOfDay extends StatefulWidget {
  final List<CarHistoryModel> dataSet;

  const ListViewPageOfDay({super.key, required this.dataSet});

  @override
  State<ListViewPageOfDay> createState() => _ListViewPageOfDayState();
}

class _ListViewPageOfDayState extends State<ListViewPageOfDay> {
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

    // print('Total Original Amount: ${totalOriginalAmount.toStringAsFixed(2)}');
    // print('Total VAT: ${totalVAT.toStringAsFixed(2)}');
    // print('Total Amount Including VAT: ${totalAmountIncludingVAT.toStringAsFixed(2)}');

    String dataRows2;
    double totalOriginalAmountForUnpaidCars = 0.0;
    double addVATForUnpaidCars = 0.0;
    double addTotalForUnpaidCars = 0.0;
    double minusPaidOriginalAmountFromUnPaid= 0.0;
    double minusPaidVATAmountFromUnPaidVAT= 0.0;
    double minusPaidTotalAmountFromUnPaidTotal= 0.0;

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

              minusPaidOriginalAmountFromUnPaid = totalOriginalAmount -totalOriginalAmountForUnpaidCars;
              minusPaidVATAmountFromUnPaidVAT = totalVAT -addVATForUnpaidCars;
              minusPaidTotalAmountFromUnPaidTotal = totalAmountIncludingVAT -addTotalForUnpaidCars;


   return """  
      <tr>
         <td>${car.validatorName}</td>
         <td>${originalAmount.toStringAsFixed(2)}</td>
         <td>${vat.toStringAsFixed(2)}</td>  
         <td>${totalAmount.toStringAsFixed(2)}</td>
      </tr> """;
            } else {
              return null; // Return null for paid cars
            }
          }).where((element) => element != null).join();
    } else {
      // No unpaid cars found, set dataRows2 to the message
      dataRows2 = """
  <tr>
   <td>N/A</td>
   <td>N/A</td>
   <td>N/A</td>
   <td>N/A</td>
  </tr>""";
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
        <p>Date From: $dateFormat</p>
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

  // Function to delete a car
  void deleteCar(String uid) {
    // Your delete car logic here
    setState(() {
      // Update dataSet after deletion
      widget.dataSet.removeWhere((car) => car.uid == uid);
      logic.deleteCar(uid);
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      widget.dataSet;
    });

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(text: 'Results'),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Printing.layoutPdf(
              onLayout: (PdfPageFormat format) async =>
                  buildPrintablePageDay(widget.dataSet),
            );
          },
          child: const Icon(Icons.print),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Enable horizontal scrolling
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical, // Enable vertical scrolling for long tables
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
                  DataColumn(label: Text('Controls')),
                ],
                rows: widget.dataSet.asMap().entries.map((entry) {
                  int index = entry.key;
                  var car = entry.value;

                  double totalAmount = double.tryParse(car.amountIncludeTax ?? '0.0') ?? 0.0;
                  double vat = totalAmount * 0.05;
                  double originalAmount = totalAmount - vat;

                  return DataRow(cells: [
                    DataCell(Text((index + 1).toString())),
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
                    DataCell(Text(totalAmount.toStringAsFixed(2))),
                    DataCell(Text(car.isCarPaidOrValidated.toString())),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            deleteCar(car.uid.toString());
                          },
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.green, size: 40),
                          onPressed: () {
                            Get.to(() => CarEditOptionHistory(
                              model: car,
                              uid: car.uid.toString(),
                              index: index,
                            ));
                          },
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
