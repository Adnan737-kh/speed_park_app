import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

const kTextFormFieldStyle = TextStyle(
  color: black,
  fontSize: 14,
  fontWeight: FontWeight.normal,
);
var kLightGreyStyle = TextStyle(
  color: black.withOpacity(0.3),
  fontSize: 14,
  fontWeight: FontWeight.normal,
);
var kBorder = OutlineInputBorder(
  borderSide: const BorderSide(color: Colors.transparent),
  borderRadius: BorderRadius.circular(15),
);
TextStyle normalTextStyle = GoogleFonts.openSans(
  fontSize: 16.sp,
  fontWeight: FontWeight.w400,
  color: Colors.black,
);
var kBorder2 = OutlineInputBorder(
  borderSide: const BorderSide(color: Colors.transparent),
  borderRadius: BorderRadius.circular(10),
);
var kStyle = TextStyle(
  color: black.withOpacity(0.5),
  fontFamily: 'Poppins',
  fontSize: 12.sp,
);

var kParkingStyle = TextStyle(
  color: black.withOpacity(0.5),
  fontFamily: 'Poppins',
  fontSize: 12.sp,
);
