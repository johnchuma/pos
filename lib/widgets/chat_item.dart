import 'package:cached_network_image/cached_network_image.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/clients_controller.dart';
import 'package:pos/controllers/product_request_controller.dart';
import 'package:pos/models/message_model.dart';
import 'package:pos/models/product_request.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/avatar.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/heading_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

Widget chatItem({var item}){
  AuthController authController = Get.find<AuthController>();
  BusinessController  businessController = Get.find<BusinessController>();

  bool isMe = false ;
  if(businessController.selectedBusiness.value != null){
 isMe = item.from == authController.auth.currentUser?.email || item.from == businessController.selectedBusiness.value?.id;

  }
  else if(authController.me.value?.role == "admin"){
    isMe = item.from == "admin";
  }
  else {
 isMe =  item.from == authController.auth.currentUser?.email ;

  }
  return Padding(
    padding:  EdgeInsets.only(top: 15,right: isMe?0:40,left: isMe?40:0),
    child: Column(
      crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child:Row(
            mainAxisAlignment:  isMe?MainAxisAlignment.end:MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
               
              Flexible(
                child: Column(
                  
                  crossAxisAlignment:  isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                                        color: isMe?primaryColor: mutedBackground,
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                             if(!isMe)heading2(text: item.name,fontSize: 13),
                                              paragraph(text: item.message,color: isMe?Colors.white:textColor),
                                            ],
                                          ),
                                        )
                                      ),
                    ),
                    const SizedBox(height: 3,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: mutedText(text: timeago.format(item.createdAt.toDate()),fontSize: 13),
                      )
                  ],
                ),
              ),
            ],
          )
        ),
        
      ],
    ),
  );
}