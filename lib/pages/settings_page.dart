// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/app_controller.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/pages/add_business.dart';
import 'package:pos/pages/admin/unapproved_product_requests.dart';
import 'package:pos/pages/business_page.dart';
import 'package:pos/pages/business_pages/conversations/clients_conversation.dart';
import 'package:pos/pages/business_pages/payment_page.dart';
import 'package:pos/pages/changeLanguage.dart';
import 'package:pos/pages/clients_page.dart';
import 'package:pos/pages/manage_password.dart';
import 'package:pos/pages/private_chat_room.dart';
import 'package:pos/pages/update_profile_details.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/avatar.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/enter_password.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/heading_text.dart';
import 'package:pos/widgets/menu_item.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/translatedText.dart';

class SettingsPage extends StatelessWidget {
 SettingsPage({super.key});
AuthController auth = Get.find<AuthController>();
AppController appController = Get.find<AppController>();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.transparent,
      body:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const SizedBox(height: 20,),
               AnimatedSize(
                duration: Duration(milliseconds: 300),
                 child: ClipRRect(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(40),bottomRight: Radius.circular(40)),
                   child: Container(
                  
                    child: Padding(
                     padding: const EdgeInsets.all(20),
                     child: Column
                     (
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                     Obx(
                       ()=> appController.isMainDashboardSelected.value? avatar(size: 100,image: auth.auth.currentUser?.photoURL): Container(
                        height: 100,
                          child: Image.asset("assets/29845426_7265372-removebg-preview.png")),
                     ),
                     SizedBox(height: 10,),
                      heading2(text:auth.auth.currentUser?.displayName),
                      mutedText(text:auth.auth.currentUser?.email),
                     SizedBox(height: 10,),
                      heading2(text:"${businessController.daysRemained} days remained",
                      fontSize: 14,
                      color: Colors.green),


                      const SizedBox(height: 20,),
                      // Row(children: [
                      //   Expanded(child: paragraph(text: "Is main dashboard ?")),
                      //   Obx(
                      //   ()=> Switch(value:appController.isMainDashboardSelected.value , onChanged:(value){
                      //                         appController.isMainDashboardSelected.value = ! appController.isMainDashboardSelected.value;
                      //       auth.updateClientInfo({"selectedDashboard":appController.isMainDashboardSelected.value? "main":"worker"});
                      //     }),
                      //   )
                      // ],),
                     
                      
                     ],),
                   ),),
                 ),
               ),
        
               const SizedBox(height: 30,),
               heading2(text: translatedText("Settings options", "Machaguo ya mipangilio")),
               const SizedBox(height: 5,),
               Column(children: [
                   if(appController.isAdmin.value)
                   menuItem(titleFontWeight: FontWeight.w400, title: translatedText("All businesses", "Wateja wa P owered POS"),onTap: (){
                    Get.to(()=> ClientsPage());
                } ),
                //    if(appController.isAdmin.value)
                //  menuItem(titleFontWeight: FontWeight.w400,title: translatedText("Conversations", "Malipo") ,onTap: (){
                //     Get.to(()=>PrivateChatRoom(true));
                // } ),
                   menuItem(titleFontWeight: FontWeight.w400,title: translatedText("Payments", "Malipo") ,onTap: (){
                    Get.to(()=>PaymentsPage());
                } ),
                menuItem(titleFontWeight: FontWeight.w400,title: translatedText("Go back home", "Biashara zangu") ,onTap: (){
                    Get.back();
                    Get.back();
                    Get.back();
                } ),
              
                // if(appController.isAdmin.value)  menuItem(titleFontWeight: FontWeight.w400,title: translatedText("Products requests", "Maulizo ya bidhaa"),onTap: (){
                //     Get.to(()=> UnapprovedProductsRequests());
                // } ),
            
             
              
               ],),
               const SizedBox(height: 60,),
            

            
          ],),
        ),
      ),
    );
  }
}