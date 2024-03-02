import 'dart:ui';
import 'package:devhit_mobile/helpers/size.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

TextStyle navbar = TextStyle(color: Colors.white,fontSize: 20,fontFamily: "MainReg");
TextStyle user = TextStyle(color: pallete1,fontSize: 20,fontFamily: "MainReg");

TextStyle primaryStyle(context,Color fColor,double fSize){
  return TextStyle(color: fColor,fontSize: getSize(context, fSize),fontFamily: "MainReg");
}
TextStyle primaryStyleBold(context,Color fColor,double fSize){
  return TextStyle(color: fColor,fontSize: getSize(context, fSize),fontFamily: "MainReg",fontWeight: FontWeight.bold,);
}