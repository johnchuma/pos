import 'package:flutter/material.dart';
import 'package:pos/utils/colors.dart';


Widget headingText({var text,maxLines, TextAlign? textAlign,double? fontSize,Color? color,FontWeight? fontWeight}){
  return  Text(text,
  textAlign: textAlign??TextAlign.start,
  maxLines: maxLines??5,
  overflow: TextOverflow.ellipsis,
  style: TextStyle(fontWeight: fontWeight??FontWeight.w900,fontSize: fontSize??20,color: color??textColor  ),);
}