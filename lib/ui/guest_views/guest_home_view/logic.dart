import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';

import '../../../core/constants/colors.dart';
import '../../../core/services/database.dart';
import '../../../widgets/mytext.dart';
import 'state.dart';

ProgressDialog pd = ProgressDialog(
  Get.context!,
  blur: 10,
  title: const Text("Requesting car"),
  message: const Text("Please Wait"),
  onDismiss: () {
    if (kDebugMode) {
      debugPrint("Do something onDismiss");
    }
  },
);
class GuestHomeViewLogic extends GetxController {
  final GuestHomeViewState state = GuestHomeViewState();
  TextEditingController searchController = TextEditingController();
  TextEditingController ticketNumberController = TextEditingController();
  bool isTextFieldEmpty = true;
  bool isTicketNumberEmpty = true;

  final DataBaseServices _repository = DataBaseServices();

  checkPlatNumber(BuildContext context,String search,String ticketNumber) async {

    pd.show();
    try {
      final response = await _repository.guestRequest(search.toUpperCase());
      if (response) {
        searchController.clear();

        pd.dismiss();
        showDialogBox('Request Confirmation','Your car with plate number'
            ' $search has been requested.' ,context);
      } else {
        final request = await _repository.againGuestRequest(search,ticketNumber);
        if(request){
          pd.dismiss();
          showDialogBox('Car ','The Car with this $search'
              ' number has already Requested', context,);
        }else{
          pd.dismiss();
          showDialogBox('Sorry','Your car with plate number'
              ' $search has not registered.' ,context);

        }

      }
    } catch (e) {
      GetSnackBar(
        title: 'Error',
        message: e.toString(),
      );
      pd.dismiss();
    }
    update();
  }

  showDialogBox(String title,String desc,BuildContext context,){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
          title: MyText(
            text: title,
            color: kPrimary,
            size: 18.sp,
          ),
          content: Text(desc),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                pd.dismiss();
                Navigator.of(context).pop();

              },
            ),
          ],
        );
      },
    );
  }
}
