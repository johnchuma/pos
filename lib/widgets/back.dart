import 'package:flutter/material.dart';
import 'package:get/get.dart';
Widget back (){
  return GestureDetector(
          onTap: (){
            Get.back();
          },
          child: Container(
          color: Colors.transparent,
            child: const Icon(Icons.arrow_back,color: Colors.black45,size: 20,)));
}