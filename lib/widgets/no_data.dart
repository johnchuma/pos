import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/translatedText.dart';

Widget noData(){
  return Padding(
                     padding: const EdgeInsets.all(20),
                     child: Column(children: [
                      Container(child: Lottie.asset("assets/Animation - 1698840215085.json")),
                      const SizedBox(height:0),
                      mutedText(text: translatedText("No data found", "Inasubiria data"),color: mutedColor.withOpacity(0.5)),
                     ],),
      );
}