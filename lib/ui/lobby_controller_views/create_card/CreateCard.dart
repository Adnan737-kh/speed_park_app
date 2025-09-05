import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../../../widgets/appBar.dart';



class PVCGenerator extends StatefulWidget {
   PVCGenerator({super.key});

  @override
  State<PVCGenerator> createState() => _PVCGeneratorState();
}

class _PVCGeneratorState extends State<PVCGenerator> {
  final TextEditingController _dataController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(text: 'Create Card'),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // PVC Card layout
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(

                  decoration: InputDecoration(
                    filled: true,
                    fillColor: kPrimary.withOpacity(0.2),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    focusedBorder: kBorder,
                    enabledBorder: kBorder,
                    border: kBorder,
                    hintText: 'Enter Card Data',
                    hintStyle: kLightGreyStyle,
                  ),
                  controller: _dataController,

                  onChanged: (value) {
                    setState(() {
                      _dataController.text = value;

                    });
                  },
                ),
              ),
              Container(
                width: 300,
                height: 200,
                // color: Colors.white,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Name: John Doe',
                      style: TextStyle(fontSize: 18),
                    ),
                    QrImageView(
                      data: _dataController.text,
                      version: QrVersions.auto,
                      size: 100.0,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => _printPVC(context),
                child: const Text('Print PVC Card to PDF'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _printPVC(BuildContext context) async {
    final pdfBytes = await _buildPDF();
    Printing.sharePdf(bytes: pdfBytes);
  }

  Future<Uint8List> _buildPDF() async {

    print(_dataController.text);

    // PDF document
    final pdf = pw.Document();

    // Add PVC card to PDF
    pdf.addPage(pw.Page(

      build: (pw.Context context) {
        return pw.Container(
          width: 500,
          height: 300,
          decoration: pw.BoxDecoration(

            borderRadius: pw.BorderRadius.circular(20),
            color: PdfColors.yellow,
            boxShadow: const [
              pw.BoxShadow(
                // spreadRadius: 2,
                blurRadius: 2,
                offset: PdfPoint(0,0),
                color: PdfColors.white,
              )
            ]
          ),
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text('Name: John Doe', style: const pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 20),
              pw.BarcodeWidget(
                barcode: pw.Barcode.qrCode(),
                data: _dataController.text,
                width: 100,
                height: 100,
              ),
            ],
          ),
        );
      },
    ));

    // Save PDF to bytes
    return pdf.save();
  }
}
