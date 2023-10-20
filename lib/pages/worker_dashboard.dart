import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/register_controller.dart';
import 'package:pos/models/register.dart';
import 'package:pos/pages/add_business.dart';
import 'package:pos/pages/business_page.dart';
import 'package:pos/pages/business_pages/tutorials_page.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/notifications.dart';
import 'package:pos/widgets/avatar.dart';
import 'package:pos/widgets/business_item.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/dashboard_appbar.dart';
import 'package:pos/widgets/expanded_item.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/heading_text.dart';
import 'package:pos/widgets/menu_item.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/no_data.dart';
import 'package:pos/widgets/translatedText.dart';

class WorkerDashboardPage extends StatefulWidget {
 WorkerDashboardPage({super.key});

  @override
  State<WorkerDashboardPage> createState() => _WorkerDashboardPageState();
}


class _WorkerDashboardPageState extends State<WorkerDashboardPage> {
AuthController auth = Get.find<AuthController>();

String businessId = "";
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: backgroundColor,
         appBar: dashboardAppbar(context),

      body:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const SizedBox(height: 20,),
               ClipRRect(
                borderRadius: BorderRadius.circular(15),
                 child: Container(
                  color: mutedBackground,
                  child: Padding(
                   padding: const EdgeInsets.all(20),
                   child: Column
                   (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    headingText(text: translatedText("Start selling", "Anza kuuza"),),
                    const SizedBox(height: 5,),
                    mutedText(text: translatedText("Select business below to start selling", "Chagua biashara kuanza kuuza")), 
                    const SizedBox(height: 20,),
                    customButton(text: translatedText("How to use the app", "Jinsi ya kutumia"),onClick: (){
                      Get.to(()=>TutorialsPage());
                    })
                   ],),
                 ),),
               ),
        
               const SizedBox(height: 30,),
               heading2(text: translatedText("Selling at", "Unauza kwenye")),
               const SizedBox(height: 20,),
               GetX<BusinessController>(
                init: BusinessController(),
                 builder: (find) {
                   return find.staffBusinesses.isEmpty ? noData(): Column(children:find.staffBusinesses.map((business) => 
                  businessItem(business) ).toList());
                 }
               )
          ],),
        ),
      ),
    );
  }
}