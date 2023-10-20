import 'package:flutter/material.dart';
import 'package:pos/utils/colors.dart';


Widget heading2({var text,maxLines, TextAlign? textAlign,double? fontSize,Color? color,FontWeight? fontWeight}){
  return  Text(text.toString(),
  textAlign: textAlign??TextAlign.start,
  maxLines: maxLines??5,
  overflow: TextOverflow.ellipsis,
  style: TextStyle(fontWeight: fontWeight??FontWeight.w900,fontSize: fontSize??16,color: color??textColor  ),);
}