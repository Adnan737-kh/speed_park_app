import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speed_park_app/core/constants/colors.dart';
import 'package:speed_park_app/widgets/mytext.dart';

import '../../super_user_views/create_location/logic.dart';
List<String> imageUrls = [];
class ImageController extends GetxController {
  final RxList selectedImages = [].obs;

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      selectedImages.add(pickedFile);
    }
  }

  void deleteImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  final progressDialog = ProgressDialogSingleton.createProgressDialog(Get.context!);

  void openImagePicker() {
    var getStyle = TextStyle(color: black);

    Get.bottomSheet(
      Wrap(
        children: <Widget>[
          ListTile(
            leading: const Icon(
              Icons.photo_library,
              color: black,
            ),
            title: Text(
              'Gallery',
              style: getStyle,
            ),
            onTap: () {
              pickImage(
                ImageSource.gallery,
              );
              Get.back();
            },
          ),
          ListTile(
            leading: Icon(Icons.camera, color: black),
            title: Text(
              'Camera',
              style: getStyle,
            ),
            onTap: () {
              pickImage(ImageSource.camera);
              Get.back();
            },
          ),
        ],
      ),
      backgroundColor: white,
      isDismissible: true,
      enableDrag: true,
    );
  }

  Future<void> uploadImagesToFirebase() async {

    final storageRef =
        FirebaseStorage.instance.ref().child('car_registration_images');
    progressDialog.show();
    // ProgressDialogSingleton.getInstance(Get.context!).show();

    try {
      for (var pickedFile in selectedImages) {
        final imageName = DateTime.now().millisecondsSinceEpoch.toString();
        final imageRef = storageRef.child('$imageName.jpg');

        // Upload image to Firebase Storage
        await imageRef.putFile(File(pickedFile.path));

        // Get download URL
        final imageUrl = await imageRef.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      // Clear selectedImages after uploading
      selectedImages.clear();

      // // Reset the state of your image view (assuming you have a function for that)
      // resetImageViewState();
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}

ImageController imageController = Get.put(ImageController());

class ImageContainer extends StatelessWidget {
  const ImageContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: imageController.openImagePicker,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: kPrimary,
        ),
        child: Obx(
          () => imageController.selectedImages.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload,
                      color: white,
                    ),
                    MyText(
                      text: 'Upload',
                      color: white,
                    ),
                  ],
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: imageController.selectedImages
                        .asMap()
                        .entries
                        .map((entry) {
                      final index = entry.key;
                      final image = entry.value;
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                title: Text('Confirm to delete'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      imageController.deleteImage(index);
                                      Get.back();
                                    },
                                    child: Text(
                                      'Confirm',
                                      style: TextStyle(color: kPrimary),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          width: 80.h,
                          height: 80.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: FileImage(File(image.path)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
        ),
      ),
    );
  }
}
