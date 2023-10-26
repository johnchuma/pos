import 'package:flutter/material.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';

import '../utils/colors.dart';

Widget forbiddenMessage({title,message}){
  return SingleChildScrollView(
    child: ClipRRect(
              borderRadius: const BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
              child: Container(
                color: mutedBackground,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    const SizedBox(height: 10,),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(width: 80,height: 5,color: backgroundColor,))],),
                       SizedBox(height: 30,),
                      Container(
                        height: 100,
                        child: Image.asset("assets/cancel_753345.png")),
                      SizedBox(height: 20,),
                      heading2(text:title,textAlign: TextAlign.center ),
                      mutedText(text:message,textAlign: TextAlign.center ),
                      SizedBox(height: 20,)
        ],
      ),) ,),
    ),
  );
}