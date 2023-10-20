// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/app_controller.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/pages/add_business.dart';
import 'package:pos/pages/business_page.dart';
import 'package:pos/pages/business_pages/payment_page.dart';
import 'package:pos/pages/changeLanguage.dart';
import 'package:pos/pages/clients_page.dart';
import 'package:pos/pages/manage_password.dart';
import 'package:pos/pages/update_profile_details.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/avatar.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/heading_text.dart';
import 'package:pos/widgets/menu_item.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/translatedText.dart';

class SettingsPage extends StatelessWidget {
 SettingsPage({super.key});
AuthController auth = Get.find<AuthController>();
AppController appController = Get.find<AppController>();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: backgroundColor,
         appBar: AppBar(
        leading: Container(),
        leadingWidth: 10,
        title: heading2(text:translatedText("Settings", "Mipangilio")),
        backgroundColor: backgroundColor,
        elevation: 0.3,
       
        
      ),

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
                  borderRadius: BorderRadius.circular(15),
                   child: Container(
                  
                    child: Padding(
                     padding: const EdgeInsets.all(20),
                     child: Column
                     (
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                     Obx(
                       ()=> appController.isMainDashboardSelected.value? avatar(size: 100,image: auth.auth.currentUser?.photoURL): Container(
                        height: 150,
                          child: Image.asset("assets/29845426_7265372-removebg-preview.png")),
                     ),
                      Obx(()=> headingText(text:appController.isMainDashboardSelected.value? translatedText("You are in main dashboard", "Upo kwenye dashibodi kuu"):translatedText("You are in workers dashboard", "Upo kwenye dashibodi ya mfanyakazi"),fontSize: 20,textAlign: TextAlign.center)),
                      const SizedBox(height: 5,),
                 
                      mutedText(text: translatedText("You can change the app dashboards here", "Unaweza kubadili dashibodi hapa")),
                      const SizedBox(height: 20,),
                      Obx(()=> customButton(text: appController.isMainDashboardSelected.value?translatedText("Change to workers dashboard", "Tumia dashibodi ya mfanyakazi"):translatedText("Back to main dashboard", "Rudi kwenye dashibodi kuu"), onClick: (){
                          appController.isMainDashboardSelected.value = ! appController.isMainDashboardSelected.value;
                          auth.updateClientInfo({"selectedDashboard":appController.isMainDashboardSelected.value? "main":"worker"});
                        }),
                      )
                      
                     ],),
                   ),),
                 ),
               ),
        
               const SizedBox(height: 30,),
               heading2(text: translatedText("Settings options", "Machaguo ya mipangilio")),
               const SizedBox(height: 5,),
               Column(children: [
                   menuItem(icon:"assets/credit-card_726488.png",title: translatedText("Payments", "Malipo") ,onTap: (){
                    Get.to(()=>PaymentsPage());
                } ),
                //   menuItem(icon:"assets/icons8-contact-details-96.png",title: "Update profile details",onTap: (){
                //     Get.to(()=> UpdateProfileDetails());
                // } ),
                menuItem(icon:"assets/icons8-language-94.png",title: translatedText("Change language", "Badilisha lugha"),onTap: (){
                    Get.bottomSheet(const ChangeLanguage());
                } ),
              
                menuItem(icon:"assets/icons8-fingerprint-accepted-94.png",title: translatedText("Security", "Usalama"),onTap: (){
                    Get.to(()=> ManagePassword());
                } ),

               if(appController.isAdmin.value)  menuItem(icon:"assets/staff.png",title: translatedText("Powered POS Clients", "Wateja wa P owered POS"),onTap: (){
                    Get.to(()=> ClientsPage());
                } ),
            
             
              
               ],),
               const SizedBox(height: 30,),
            
          ],),
        ),
      ),
    );
  }
}