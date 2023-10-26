import 'package:flutter/material.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/heading2_text.dart';

PreferredSizeWidget appbar({title}){
  return AppBar(leading:Container(),  backgroundColor: backgroundColor,elevation: 0.3,
      leadingWidth: 1,
      title: Row(
        children: [
         back(),
         SizedBox(width: 20,),
          heading2(text: title),
        ],
      ) 
      ,);
}