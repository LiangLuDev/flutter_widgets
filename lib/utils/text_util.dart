import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

TextStyle textStyle(
    {Color color = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
    double fontSize = 14,
    TextDecoration decoration = TextDecoration.none}) {
  return TextStyle(
      color: color,
      fontWeight: fontWeight,
      decoration: decoration,
      fontSize: fontSize);
}
