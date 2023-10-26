import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/utils/colors.dart';
Widget back (){
  return GestureDetector(
          onTap: (){
            Get.back();
          },
          child: Container(
          color: Colors.transparent,
            child:  Icon(Icons.arrow_back,color:mutedColor,size: 20,)));
}