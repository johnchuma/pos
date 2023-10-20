// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/app_controller.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/register_controller.dart';
import 'package:pos/pages/add_business.dart';
import 'package:pos/pages/business_page.dart';
import 'package:pos/pages/update_profile_details.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/notifications.dart';
import 'package:pos/utils/onesignal_notification.dart';
import 'package:pos/widgets/avatar.dart';
import 'package:pos/widgets/business_item.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/dashboard_appbar.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/heading_text.dart';
import 'package:pos/widgets/menu_item.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/no_data.dart';
import 'package:pos/widgets/translatedText.dart';

class DashboardPage extends StatefulWidget {
 DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
AuthController auth = Get.find<AuthController>();
AppController appController = Get.find<AppController>();

  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
String language = appController.language.value;

    return  AnnotatedRegion(
      value: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: backgroundColor,
           appBar: dashboardAppbar(context),
    
        body:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              const SizedBox(height: 20,),
                 Material(
                  color: Colors.white,
              
                  borderRadius: BorderRadius.circular(15),
                  child: Padding(
                   padding: const EdgeInsets.all(20),
                   child: Column
                   (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    headingText(text:  translatedText("Add business", "Ongeza biashara mpya")),
                    const SizedBox(height: 5,),
                 
                    mutedText(text: translatedText("Add your business here to start managing", "Weka biashara yako kuanza kusimamia.") ),
                    const SizedBox(height: 20,),
                    customButton(text: translatedText("Add business", "Ongeza biashara mpya"),onClick: (){
                      Get.to(()=>AddBusiness());
                      // sendNotification();
                    })
                    
                   ],),
                 ),),
                 const SizedBox(height: 30,),
                 heading2(text: translatedText("My businesses", "Biashara zangu")),
                 const SizedBox(height: 20,),
                 GetX<BusinessController>(
                  init: BusinessController(),
                   builder: (find) {
                     return find.businesses.isEmpty ? noData():Column(children:find.businesses.map((business) => GestureDetector(
                      onTap: (){
                        find.selectedBusiness.value = business;
                        
                        Get.to(()=>const BusinessPage());
                      },
                       child: businessItem(business),
                     ) ).toList());
                   }
                 )
            ],),
          ),
        ),
      ),
    );
  }
}