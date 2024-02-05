import 'package:flutter/material.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';

Widget menuItem({icon,title,onTap,trailing, titleFontWeight, subtitle,double? paddingTop,double iconSize = 30,double? verticalPadding,Color? titleColor,bool? expandable=false, Widget? expandedItem}){
  return Padding(
            padding:  EdgeInsets.only(top:paddingTop?? 10),
            child: GestureDetector(
              onTap:onTap??(){},
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(color: backgroundColor2,
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 15,vertical:verticalPadding?? 20),
                  child: Row(children: [
                    if(icon != null) Container(
                      height: iconSize,width: iconSize,
                      child:  Image.asset(icon)),
                      const SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        heading2(text: title,color: titleColor??textColor,fontWeight: titleFontWeight??FontWeight.bold),
                       if(subtitle != null) mutedText(text:subtitle??"",color: mutedColor ),
                       AnimatedSize(
                        duration: Duration(milliseconds: 300),
                         child: expandable == false ?Container(): Container(
                           child: expandedItem,
                         ),
                       )
                      ],),
                    ),
                   trailing??Container()
                  ],),
                ),
                ),
              ),
            ),
          );
}