import 'package:flutter/material.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/paragraph.dart';

Widget pill({bool active = false,String? text}){
  return Padding(
    padding: const EdgeInsets.only(right: 10,bottom: 10),
    child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    color: active?primaryColor: primaryColor.withOpacity(0.07),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                      child: paragraph(text: text,color:active?Colors.white:textColor),
                                    ),),
                                ),
  );
}