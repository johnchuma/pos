import 'package:flutter/material.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/paragraph.dart';

Widget pill({bool active = false,String? text,onClick}){
  return GestureDetector(
    onTap: onClick?? (){
       
    },
    child: Padding(
      padding: const EdgeInsets.only(right: 5,bottom: 5),
      child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                      color: active?primaryColor:backgroundColor,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                        child: heading2(text: text,color:active?Colors.white:textColor,fontSize:18),
                                      ),),
                                  ),
    ),
  );
}