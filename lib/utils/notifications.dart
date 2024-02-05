import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/private_chat_controller.dart';
import 'package:pos/pages/business_pages/request_product.dart';
import 'package:pos/pages/private_chat_room.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';

successNotification(message){
    Get.snackbar("","",
    duration: Duration(seconds: 2),
    backgroundColor: mutedBackground,
          padding: EdgeInsets.all(20),
          messageText: Container(),
          
          icon: Container(
            height: 25,
            child: Image.asset("assets/check_6785304.png"),),
          titleText: heading2(text: message));
}

failureNotification(message){
    Get.snackbar("","",backgroundColor: mutedBackground,
    duration: Duration(seconds: 2),

          padding: EdgeInsets.all(20),
          messageText: Container(),
          
          icon: Container(
            height: 25,
            child: Image.asset("assets/cancel_753345.png"),),
          titleText: heading2(text: message));
}


    paymentRemainder (context,find,loading,value){
    Get.defaultDialog(title: "",
backgroundColor: mutedBackground,
titlePadding: EdgeInsets.all(0),
        content: Container(width: MediaQuery.of(context).size.width,child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
            Container(
              height: 80,
              child: Image.asset("assets/cancel_753345.png",)),
              SizedBox(height: 10,),
            heading2(text: "$value days remained",textAlign: TextAlign.center,),
            mutedText(text: "Your subscription is about to end, please pay ealier ",textAlign: TextAlign.center),
           SizedBox(height: 20,),
            Obx(
              ()=> customButton(text: "I want to pay ",loading: loading.value, onClick: (){
                loading.value = true;
                 PrivateChatController().sendMessage("Hello, Customer Service Team,I need assistance with processing a payment for ${find.selectedBusiness.value?.name}. Could you please help me? Thank you in advance.").then((value) {
                       Get.back();
                        Get.to(()=>PrivateChatRoom(true));
                loading.value = false;
                      
                       });
              }),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                Get.back();
              },
              child: mutedText(text: "Not now"))
          
          ],),
        ),));
   }


       requestProductPopupMessage (context){
    Get.defaultDialog(title: "",
    barrierDismissible: false,
backgroundColor: mutedBackground,
titlePadding: EdgeInsets.all(0),
        content: SingleChildScrollView(
          child: Container(width: MediaQuery.of(context).size.width,child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                
                Icon(Icons.star,color: Colors.orange,size: 25,),
                Icon(Icons.star,color: Colors.orange,size: 40,),
                Icon(Icons.star,color: Colors.orange,size: 25,),
        
              
              ],),
              SizedBox(height: 20,),
              heading2(text: "Do you want best offers ?",textAlign: TextAlign.center,),
              mutedText(text: "Send us a request of what you want, and let sellers send you their offers",textAlign: TextAlign.center),
             SizedBox(height: 20,),
               customButton(text: "Make a request", onClick: (){
                  
                                    Get.to(()=>RequestProduct());
        
                }),
              
              SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: mutedText(text: "Not now"))
            
            ],),
          ),),
        ));
   }