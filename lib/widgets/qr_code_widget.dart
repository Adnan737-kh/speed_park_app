import 'dart:math';

import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:pdf/widgets.dart' as pdf_lib;

import '../ui/lobby_controller_views/register_car/logic.dart';
RegisterCarLogic _logic = Get.put(RegisterCarLogic());
class QRCodeDialog extends StatelessWidget {
  final GlobalKey globalKey = GlobalKey();

  QRCodeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    const String message = 'Car Register';


    int generateRandomNumber() {
      final random = Random();
      return random.nextInt(10000); // Change 10000 to the range you want
    }
    Future<Uint8List> captureQRCodeAsImage() async {
      try {
        RenderRepaintBoundary boundary = globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(pixelRatio: 2.0);
        ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        return byteData!.buffer.asUint8List();
      } catch (e) {
        if (kDebugMode) {
          print('Error capturing QR code image: $e');
        }
        return Uint8List(0); // Return an empty Uint8List in case of an error
      }
    }

    Future<void> saveQRCodeAsPDF(Uint8List imageBytes) async {
      final pdf = pdf_lib.Document();

      // Create a PDF page and add the QR code image
      pdf.addPage(
        pdf_lib.Page(
          build: (pdf_lib.Context context) {
            return pdf_lib.Image(pdf_lib.MemoryImage(imageBytes));
          },
        ),
      );
      final randomNumber = generateRandomNumber();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      // Get the external storage directory
      final directory = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);

      final pdfPath = '$directory/valet_parking_${timestamp}_$randomNumber.pdf';

      // Save the PDF to the external storage directory
      final pdfFile = File(pdfPath);
      await pdfFile.writeAsBytes(await pdf.save());
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: RepaintBoundary(
        key: globalKey,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                blurRadius: 10.0,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Valet Parking',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: Center(
                  child: CustomPaint(
                    size: const Size.square(280),
                    painter: QrPainter(
                      data: message,
                      version: QrVersions.auto,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: Colors.black,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: Colors.black,
                      ),
                      embeddedImageStyle: const QrEmbeddedImageStyle(
                        size: Size.square(90),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  await _logic.updateMessage();
                  final qrCodeImageBytes = await captureQRCodeAsImage();
                  await saveQRCodeAsPDF(qrCodeImageBytes);
                },
                child: Text(
                  _logic.buttonMessage,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
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
