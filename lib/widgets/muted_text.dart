import 'package:flutter/material.dart';
import 'package:pos/utils/colors.dart';


Widget mutedText({var text,color,maxLines, double? fontSize,TextAlign? textAlign}){
  return Padding(
    padding: const EdgeInsets.only(top: 2),
    child: Text(text.toString(),
    textAlign: textAlign??TextAlign.start,
    maxLines:maxLines??50,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(color:color??mutedColor,fontSize: fontSize??16 )),
  );
}