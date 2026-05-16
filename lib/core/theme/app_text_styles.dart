import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

abstract final class AppTextStyles {
  static TextStyle appBarTitle({Color? color}) => GoogleFonts.sora(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.navy,
      );
}
