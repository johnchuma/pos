import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_subscription_controller.dart';
import 'package:pos/controllers/clients_controller.dart';
import 'package:pos/controllers/private_chat_controller.dart';

import 'package:pos/controllers/register_controller.dart';
import 'package:pos/controllers/staff_register_controller.dart';
import 'package:pos/controllers/worker_controller.dart';
import 'package:pos/models/staff_registers.dart';
import 'package:pos/pages/private_chat_room.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/notifications.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/text_form.dart';

class SubscribeNowPage extends StatefulWidget {
  const SubscribeNowPage({super.key});

  @override
  State<SubscribeNowPage> createState() => _SubscribeNowPageState();
}

class _SubscribeNowPageState extends State<SubscribeNowPage> {  
  bool loading = false;
   BusinessSubscriptionController businessSubscriptionController = Get.find<BusinessSubscriptionController>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
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
                      borderRadius: BorderRadius.circular(15),
                      child: Container(width: 80,height: 5,color: backgroundColor,))],),
                  const SizedBox(height: 20,),
                  Container(
                    height: 150,
                    child: Image.asset("assets/8674921-removebg-preview.png")),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      heading2(text: "Paying for ${businessSubscriptionController.selectedBusiness.value?.name}"),
                    
                      mutedText(text: "Please click the button below to send a payment request to our customer service representative. They will assist you throughout the process. Thank you.",textAlign: TextAlign.center),
                  SizedBox(height: 20,),
                    ],
                  ),
                
              
              
                  SizedBox(height: 20,),
                  customButton(text: "Send payment request ",loading: loading, onClick: (){
                    setState(() {
                      loading = true;
                    });
                     PrivateChatController().sendMessage("Hello, Customer Service Team,I need assistance with processing a payment for ${businessSubscriptionController.selectedBusiness.value?.name}. Could you please help me? Thank you in advance.").then((value) {
                      Get.to(()=>PrivateChatRoom());
                      setState(() {
                        loading = false;
                      });
                     });
                    // GooglePayButton(
                    //   paymentConfiguration: PaymentConfiguration.fromJsonString(
                    //       defaultGooglePayConfigString),
                    //   paymentItems: _paymentItems,
                    //   type: GooglePayButtonType.pay,
                    //   margin: const EdgeInsets.only(top: 15.0),
                    //   onPaymentResult: onGooglePayResult,
                    //   loadingIndicator: const Center(
                    //     child: CircularProgressIndicator(),
                    //   ),
                    // );
                    // setState(() {
                    //   loading = true;
                    // });
                    // businessSubscriptionController.addBusinessSubscription().then((value) {
                      
                    //   Get.back();
                    // });
                  }),
                  const SizedBox(height: 10,),
                  
                
                  const SizedBox(height: 10,),

        
                ],),
              ),
            )),
        );
      
  }
}