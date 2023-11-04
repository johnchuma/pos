// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/app_controller.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/clients_controller.dart';
import 'package:pos/controllers/register_controller.dart';
import 'package:pos/models/client.dart';
import 'package:pos/pages/add_business.dart';
import 'package:pos/pages/business_page.dart';
import 'package:pos/pages/update_profile_details.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/notifications.dart';
import 'package:pos/utils/onesignal_notification.dart';
import 'package:pos/widgets/avatar.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/business_item.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/dashboard_appbar.dart';
import 'package:pos/widgets/heading2_text.dart';

import 'package:pos/widgets/no_data.dart';


class ViewClientBusinesses extends StatefulWidget {
 ViewClientBusinesses({super.key});

  @override
  State<ViewClientBusinesses> createState() => _ViewClientBusinessesState();
}

class _ViewClientBusinessesState extends State<ViewClientBusinesses> {
AuthController auth = Get.find<AuthController>();
AppController appController = Get.find<AppController>();

  @override
  void initState() {

    super.initState();
  }
ClientsController clientsController = Get.find<ClientsController>();

  @override
  Widget build(BuildContext context) {
String language = appController.language.value;
Client client = clientsController.selectedClient.value!;
    return  AnnotatedRegion(
      value: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: backgroundColor,
           appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            leading: back(),title: Row(children: [
              avatar(image: client.profileImageUrl,size: 40),
              SizedBox(width: 10,),
              heading2(text: client.name)
            ],),),
    
        body:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ListView(
                    
                    children: [
                              
            SizedBox(height: 10,),
                   
                       GetBuilder<BusinessController>(
                        init: BusinessController(),
                         builder: (find) {
                           return FutureBuilder(
                            future: find.getUserBusinesses(),
                             builder: (context,snapshot) {
                              if(snapshot.connectionState == ConnectionState.waiting){
                                return Center(child: CircularProgressIndicator(color: Colors.white,),);
                              }
                              var businesses = snapshot.requireData;
                               return businesses.isEmpty ? noData():Column(children:businesses.map((business) => GestureDetector(
                                onTap: (){
                                  find.selectedBusiness.value = business;
                                  Get.to(()=>const BusinessPage());
                                },
                                 child: businessItem(business),
                               ) ).toList());
                             }
                           );
                         }
                       ),
                        
                  ],), 
                ),
              ),
          

            ],
          ),
        ),
      ),
    );
  }
}