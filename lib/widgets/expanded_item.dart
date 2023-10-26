import 'package:flutter/material.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/paragraph.dart';

Widget expandedItem({String? title,IconData? iconData, onClick,double? elevation}){
  return GestureDetector(
    onTap:onClick??(){},
    child: Material(
            elevation:elevation?? 0,
            color: backgroundColor2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(children: [
              const SizedBox(width: 10),
              Icon(iconData, color: mutedColor.withOpacity(0.4),size: 20,),
              const SizedBox(width: 20),
              paragraph(text: title,)
              ],),
            ),
          ),
  );
}