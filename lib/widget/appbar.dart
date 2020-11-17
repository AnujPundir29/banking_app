import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarCustom extends StatelessWidget {
  final title;
  final goto;
  final color;

  const AppBarCustom(
      {Key key, @required this.title, this.goto, @required this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: WaveClipperOne(),
          child: Container(
            height: Get.height / 2 * .5,
            color: color,
            child: Center(
                child: Text(
              title,
              style: GoogleFonts.lato(
                  textStyle: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 26,
              )),
            )),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: Get.height / 2 * .09, right: Get.width / 2 * .05),
          child: Align(
            alignment: Alignment.topRight,
            child: IconButton(
                icon: Icon(FlutterIcons.theme_light_dark_mco,
                    size: 27, color: Colors.white),
                onPressed: () {
                  (Get.isDarkMode)
                      ? Get.changeTheme(ThemeData.light())
                      : Get.changeTheme(ThemeData.dark());
                }),
          ),
        ),
        if (goto == 'back')
          Padding(
            padding: EdgeInsets.only(
                top: Get.height / 2 * .09, left: Get.width / 2 * .01),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                  icon: Icon(FlutterIcons.arrow_back_mdi,
                      size: 27, color: Colors.white),
                  onPressed: () {
                    Get.back();
                  }),
            ),
          ),
      ],
    );
  }
}
