import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/widgets/heading2_text.dart';

successNotification(message){
    Get.snackbar("","",
    duration: Duration(seconds: 2),
    backgroundColor: Colors.white70,
          padding: EdgeInsets.all(20),
          messageText: Container(),
          
          icon: Container(
            height: 25,
            child: Image.asset("assets/check_6785304.png"),),
          titleText: heading2(text: message));
}

failureNotification(message){
    Get.snackbar("","",backgroundColor: Colors.white70,
    duration: Duration(seconds: 2),

          padding: EdgeInsets.all(20),
          messageText: Container(),
          
          icon: Container(
            height: 25,
            child: Image.asset("assets/cancel_753345.png"),),
          titleText: heading2(text: message));
}