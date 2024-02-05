import 'package:flutter/material.dart';
import 'package:pos/utils/colors.dart';


Widget paragraph({var text,color,double? fontSize,int? maxLines}){
  return Text(text,
    maxLines:maxLines??50,
    overflow: TextOverflow.ellipsis,
  style: TextStyle(color:color??textColor,fontWeight: FontWeight.w500, fontSize: fontSize??16 ));
}