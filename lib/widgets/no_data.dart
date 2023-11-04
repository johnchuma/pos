import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/translatedText.dart';

Widget noData(){
  return Padding(
                     padding: const EdgeInsets.all(20),
                     child: Column(children: [
                      Container(
                        // height: 200,
                        child: Lottie.asset("assets/Animation - 1698840215085.json")),
                      const SizedBox(height: 10,),
                      heading2(text: translatedText("No data found", "Inasubiria data"),),
                      mutedText(text: translatedText("Available data will be displayed here","Data zitaonekana hapa"),textAlign: TextAlign.center)
                     ],),
      );
}