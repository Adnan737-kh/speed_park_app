import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../core/constants/string.dart';
import '../../../widgets/appBar.dart';

List driver_printing = [
  'S.No',
  'Plate Number',
  'Ticket Number',
  'Register Date',
  'Register Time',
];

class Selected_Printing extends StatelessWidget {
  Selected_Printing(this.ressult, this.name);
  String ressult;
  String name;

  @override
  Widget build(BuildContext context) {
    List<String> lines = ressult.split('\n');
    return SafeArea(
      child: Scaffold(
        appBar:appBarWidget(text: 'Drive Record',),
        body: PdfPreview(
          shouldRepaint: false,
          build: (format) async {
            final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

            pdf.addPage(
              pw.MultiPage(
                pageFormat: format,
                build: (context) {
                  return [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Container(
                          margin: pw.EdgeInsets.symmetric(vertical: 10),
                          height: 10,
                          width: double.infinity,
                          decoration: pw.BoxDecoration(
                            color: PdfColors.black,
                          ),
                        ),
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                              pw.Text('Driver Name:$name',
                                  style: pw.TextStyle(
                                      color: PdfColors.black, fontSize: 18))
                            ]),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    // for (int index = 0; index < mdl.length; index++)
                    // Create a new Column for each line of data
                    for (int i = 0; i < lines.length; i += 5)
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          ...List.generate(
                            4,
                                (fIndex) {
                              int dataIndex = i + fIndex;
                              return pw.Expanded(
                                child: pw.Container(
                                  height: 25,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(color: PdfColors.black),
                                  ),
                                  padding: pw.EdgeInsets.all(8.0),
                                  child: pw.Text(
                                    dataIndex < lines.length ? lines[dataIndex] : '',
                                    style: pw.TextStyle(color: PdfColors.black, fontSize: 8),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                  ];
                },
              ),
            );

            return pdf.save();
          },
        ),
      ),
    );
  }

  pw.Row buildHeader(pw.ImageProvider imagePath) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: 100,
          height: 100,
          child: pw.Image(imagePath),
        ),
        pw.SizedBox(width: 10),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Rasheed Electric Store Mardan',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 24,
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              'Address: Bicket Gunj Bazar Mardan',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 12,
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              'Property Advisor: Rasheed Khan 0300-5729031 0312-5729031',
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 12,
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              'Muhammad Hassan 0317-9535110',
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 12,
              ),
            ),
            pw.SizedBox(height: 5),
          ],
        ),
      ],
    );
    ;
  }
}
