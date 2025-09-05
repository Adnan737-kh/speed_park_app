import 'package:flutter/material.dart';

import '../core/constants/colors.dart';
import 'mytext.dart';

class AppButton extends StatelessWidget {
  final Color bgColor;
  final Color textColor;
  final Color bdColor;
  final String text;
  final VoidCallback? onPress;
  final bool loading;
  final double textSize;

  const AppButton({
    Key? key,
    this.textSize = 14,
    required this.text,
    this.loading = false,
    this.bdColor = kButton,
    this.bgColor = kButton,
    this.textColor = white,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: bdColor),
          gradient: LinearGradient(
            colors: [
              kButton,
              kButton2.withOpacity(0.8),
            ], // Define your gradient colors here
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        width: w,
        height: h * 0.065,
        child: Center(
          child: loading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : MyText(
                  align: TextAlign.center,
                  text: text,
                  size: 14,
                  fontFamily: 'Montserrat',
                  weight: FontWeight.w700,
                  color: textColor,
                ),
        ),
      ),
    );
  }
}
