// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:pos/utils/colors.dart';
Widget TextForm({hint,key,
TextEditingController? textEditingController,initialValue, TextInputType? textInputType,color,onChanged, validator,isPassword =false,int? lines,suffixIcon}){
  return  Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
              color: color??Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: TextFormField(
                  obscureText: isPassword,
                  initialValue:initialValue ,
                  cursorColor: primaryColor,
                  onChanged: onChanged??(value){},
                  keyboardType: textInputType?? TextInputType.text,
                  maxLines: lines??1,
                  validator: validator??(value){
                        if(value == ""){
                          return "Field required";
                        }
                        return null;
                  },
                  controller: textEditingController,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(fontSize: 15),
                    suffixIcon: suffixIcon??Container(width: 0,),
                    border: InputBorder.none,hintText: hint),),
              )),
    ),
  );
}