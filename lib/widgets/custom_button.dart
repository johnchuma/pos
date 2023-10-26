import 'package:pos/utils/colors.dart';
import 'package:flutter/material.dart';

Widget customButton({var text,onClick,color,double? height,bool loading=false,Color? textColor,FontWeight? fontWeight}){
  
  return GestureDetector(
    onTap:onClick?? (){},
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
                 decoration: BoxDecoration(gradient: LinearGradient(colors: [color??primaryColor,color??primaryColor2])),              
                  width: double.infinity,
                  child:  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 50,vertical: height??25),
                    child: Center(child:loading?const Center(child: CircularProgressIndicator(color: Colors.white,),): Text(text??"",
                    style:  TextStyle(color: textColor??Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),)),
                  ),),),
  );
}