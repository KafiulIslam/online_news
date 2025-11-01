import 'package:flutter/material.dart';
 import 'package:google_fonts/google_fonts.dart';
import 'color.dart';

const verticalSpacer = SizedBox(height: 16,);

final appTitle = Text(
  'Global News',
  style: GoogleFonts.roboto(
      textStyle: const TextStyle(
          color: white, fontSize: 20, fontWeight: FontWeight.w800)),
);

final inputFieldBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10.0),
  borderSide: const BorderSide(color: Colors.white54,),
);

