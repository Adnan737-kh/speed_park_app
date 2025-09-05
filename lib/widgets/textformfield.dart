// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/constants/colors.dart';
import '../core/constants/styles.dart';

// ignore: must_be_immutable
class MyField extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  var hintText,
      prefixIcon,
      suffixIcon,
      hintstyle,
      controller,
      validator,
      visibile;
  MyField({
    Key? key,
    this.suffixIcon,
    this.visibile = false,
    this.controller,
    this.hintText,
    this.hintstyle,
    this.prefixIcon,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(

      obscureText: visibile,
      style: kTextFormFieldStyle,
      validator: validator,
      controller: controller,
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
        hintText: hintText,
        hintStyle: kLightGreyStyle,
        // labelStyle: kLighGreyStyle,
        // labelText: hintText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
      ),
    );
  }
}

class MyColorField extends StatelessWidget {
  MyColorField({
    Key? key,
    this.hintText,
    this.controller,
    this.validator,
    this.onPress,
    this.inpuText,
    this.readyOnly=false,
  }) : super(key: key);
  String? Function(String?)? validator;
  var hintText, controller,inpuText;
  VoidCallback? onPress;
  bool? readyOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      readOnly: readyOnly!,
      onChanged: (value) {
        inpuText = value;
        if (kDebugMode) {
          print(inpuText);
        }
      },
      decoration: InputDecoration(
        hintText: hintText,
        labelText: hintText,
        hintStyle: kStyle,
        labelStyle: kStyle,
        fillColor: kPrimary.withOpacity(0.2),
        filled: true,
        border: kBorder,
        focusedBorder: kBorder,
        enabledBorder: kBorder,
        contentPadding:const EdgeInsets.symmetric(horizontal: 10),
        suffixIcon: onPress != null
            ? IconButton(
          onPressed: onPress,
          icon:const Icon(Icons.qr_code), // Replace with your desired icon
        )
            : null,
      ),
    );
  }
}

var kBorder = OutlineInputBorder(
  borderSide:const BorderSide(color: Colors.transparent),
  borderRadius: BorderRadius.circular(10),
);
