import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgressDialogNew {
  /// Show the progress dialog
  static void show({required String title, required String message}) {
    if (Get.isDialogOpen != true) {
      Get.dialog(
        PopScope(
          canPop: false, // Prevent dismiss by back button
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0), // Rounded corners
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    const CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    }
  }

  /// Dismiss the progress dialog
  static void dismiss() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }
}
