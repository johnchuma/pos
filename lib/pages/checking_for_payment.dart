import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/business_subscription_controller.dart';
import 'package:pos/controllers/private_chat_controller.dart';
import 'package:pos/pages/business_page.dart';
import 'package:pos/pages/private_chat_room.dart';
import 'package:pos/pages/select_register.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckingForPayment extends StatelessWidget {
  const CheckingForPayment({super.key});
  @override
  Widget build(BuildContext context) {
BusinessController businessController = Get.find();
    return Scaffold(body:FutureBuilder(
      future: BusinessSubscriptionController().checkRemainedDays(),
      builder: (context,snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(color: Colors.black,),);
        }
        int days = snapshot.requireData;
        print(days);
        businessController.daysRemained = days;
        return days >0?SelectRegister():Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 70,
                child: Image.asset("assets/credit-card_726488.png")),
                SizedBox(height: 10,),
             heading2(text: "Pay to continue..."),
                SizedBox(height: 10,),

             mutedText(text: "Your subscription is over, pay to continue using our app",textAlign: TextAlign.center),
             SizedBox(height: 20,),
             customButton(text: "Call to pay",onClick: (){
                launchUrl(Uri.parse("tel:0627707434"));
             })
                  ],),
          ),);
      }
    ),);
  }
}