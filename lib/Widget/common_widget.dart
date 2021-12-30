import 'package:clikr_wallpaper/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget cappbar() {
  return AppBar(
    elevation: 0.0,
    centerTitle: true,
    backgroundColor: Colors.black,
    title: RichText(
        text: TextSpan(children: [
      TextSpan(
        text: "Clikr",
        style: GoogleFonts.aBeeZee(
          color: Colors.white,
          fontSize: 21,
          letterSpacing: 2.1,
        ),
      ),
      TextSpan(
        text: "Wallpaper",
        style: GoogleFonts.aBeeZee(
          color: Colors.amber,
          fontSize: 21,
          letterSpacing: 2.1,
        ),
      ),
    ])),
  );
}
