import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';

 confirmDelete (context,{onClick,onSuccess}){
        Get.defaultDialog(
          title: "",
          titlePadding: EdgeInsets.all(0),
          backgroundColor: mutedBackground,
          
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          radius: 15,
          content: Container(
            width: MediaQuery.of(context).size.width,
          
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Container(
                  height: 80,
                  child: Image.asset("assets/cancel_753345.png")),
            const SizedBox(height: 10,),

              heading2(text: "Are sure, you want to delete ?",textAlign: TextAlign.center),
            const SizedBox(height: 20,),
                GestureDetector(
                   onTap:(){
                    onClick();
                    Get.back();
                    onSuccess();
                   },
                  child: heading2(text: "Yes, delete",color: Colors.red)),
            const SizedBox(height: 10,),
          GestureDetector(
            onTap: (){
              Get.back();
            },
            child: mutedText(text: "No, Don't delete")),
            const SizedBox(height: 20,),

            
      ])));
}