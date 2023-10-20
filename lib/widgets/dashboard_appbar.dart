import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/app_controller.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/avatar.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/translatedText.dart';

PreferredSizeWidget dashboardAppbar(context,{title}){
AuthController auth = Get.find<AuthController>();
AppController appController = Get.find<AppController>();
String language = appController.language.value;
  return AppBar(
          leading: Container(),
          leadingWidth: 10,
          title: heading2(text: title??language == "ENG"?"Dashboard":"Dashibodi"),
          backgroundColor: backgroundColor,
          elevation: 0.3,
          actions: [
            // GestureDetector(
            //   onTap: (){
            //     appController.accessGranted.value = false;
            //   },
            //   child: Icon(Icons.lock,color: textColor,size: 20,)),
            SizedBox(width:20,),
            Padding(
            padding: const EdgeInsets.only(right: 20,top: 13,bottom: 13),
            child: GestureDetector(
              onTap: (){
                    Get.defaultDialog(
                      title: "",
                      
                           titleStyle: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: textColor),
                      titlePadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                     
                      content: Container(width: MediaQuery.of(context).size.width,
                    
                    child: Column(children: [
                      
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(children: [
                                
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                avatar(image: auth.user?.photoURL,size: 100),
                                 SizedBox(height: 10,),
                                    heading2(text: auth.user?.displayName),
                                    mutedText(text: auth.user?.email)],),
                                ),
                                
                              ],),
                               SizedBox(height: 20,),
                          

                      GestureDetector(
                        onTap: (){
                          Get.back();
                          AuthController().logout();
                        },
                        child: heading2(text:translatedText("Sign out", "Toka kwenye account yako"),color: Colors.red,fontSize: 14)),
                               SizedBox(height: 10,),

                            ],
                          ),
    
                        ),
                        ),
                      ),
                
                    
                    ],),
                    ));
               },
              child: ClipOval(
                child: SizedBox(height: 30,width: 30,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: auth.auth.currentUser!.photoURL!),),
              ),
            ),
          )
          
          ],
          
        );
}