import 'package:flutter/material.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/translatedText.dart';

Widget noData(){
  return Padding(
                     padding: const EdgeInsets.all(20),
                     child: Column(children: [
                      Image.asset("assets/8961448_3973481-removebg-preview.png"),
                      const SizedBox(height: 10,),
                      heading2(text: translatedText("Waiting for data", "Inasubiria data"),),
                      mutedText(text: translatedText("Available data will be displayed here","Data zitaonekana hapa"),textAlign: TextAlign.center)
                     ],),
      );
}