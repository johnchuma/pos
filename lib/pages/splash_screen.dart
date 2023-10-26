import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/heading2_text.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: backgroundColor,
      body: Center(child: Container(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
                  //  ClipOval(
                  //         child: Container(
                  //             height: 100,
                  //             width: 100,
                  //             child: Image.asset("assets/icons/1024.png")),
                  //       ),
                    
      heading2(text: "Trade Point",fontSize: 45,color: Colors.white)
    ],),),),);
  }
}