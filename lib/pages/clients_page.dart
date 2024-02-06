// ignore_for_file: avoid_unnecessary_containers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/app_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/clients_controller.dart';
import 'package:pos/controllers/product_controller.dart';

import 'package:pos/controllers/register_controller.dart';
import 'package:pos/controllers/worker_controller.dart';
import 'package:pos/models/business.dart';
import 'package:pos/pages/add_worker.dart';
import 'package:pos/pages/admin/view_client_businesses.dart';
import 'package:pos/pages/business_page.dart';
import 'package:pos/pages/business_pages/assign_register.dart';
import 'package:pos/pages/business_pages/payment_page.dart';
import 'package:pos/pages/checking_for_payment.dart';
import 'package:pos/pages/private_chat_room.dart';

import 'package:pos/utils/colors.dart';
import 'package:pos/utils/delete_confirmation.dart';
import 'package:pos/utils/notifications.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/expanded_item.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/heading_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/translatedText.dart';
import "package:timeago/timeago.dart" as timeago;

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  bool expanded = false;
  String clientId = "";
  @override
  void initState() {
     Get.put(ClientsController());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  
  AppController appController = Get.find<AppController>();
    return  Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(leading:Container(),  backgroundColor: backgroundColor,elevation: 0.3,
      leadingWidth: 1,
      title: Row(
        children: [
         back(),
         SizedBox(width: 20,),
          heading2(text: "Businesses"),
        ],
      ) 
      ,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
              const SizedBox(height: 0,),
               const SizedBox(height: 20),
                 GetX<BusinessController>(
                init: BusinessController(),
                 builder: (find) {
                   return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                      ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        color: mutedBackground,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            cursorColor: primaryColor,
                            onChanged: (value){
                              find.searchKeyword.value = value;
                            },
                          
                            decoration:  InputDecoration(
                            icon: Icon(Icons.search,color: mutedColor),
                            border: InputBorder.none,
                          hintStyle: TextStyle(color: mutedColor),
                            hintText: translatedText("Search businesses here", "Tafuta bidhaa hapa")),
                          style:  TextStyle(fontSize:15,color: textColor)),
                        )),
                    ),
                                    SizedBox(height: 10,),

                    mutedText(text: "${find.allbusinesses.length} registered businesses"),
                                    SizedBox(height: 5,),

                       Column(children:find.allbusinesses.where((element) => element.name.toLowerCase().contains(find.searchKeyword.value.toLowerCase()))
                       .map((business) => Padding(
                         padding: const EdgeInsets.only(bottom: 10),
                         child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              color: mutedBackground,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                      setState(() {
                                        if(clientId == business.id){
                                           clientId = "";
                                          }else{
                                           clientId = business.id;
                                          }
                                        });
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Row(children:  [
                                          ClipOval(
                                          child: SizedBox(height: 50,width: 50,child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: business.image),),
                                        ),
                                        const SizedBox(width: 10,),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                            heading2(text: business.name,fontSize:18),
                                            mutedText(text: timeago.format(business.createdAt.toDate())),
                                           
                                          ],),
                                        ),
                                                    ],),
                                      ),
                                    ),
                                     AnimatedSize(
                                                  duration: const Duration(milliseconds: 200),
                                                  child:clientId == business.id ? Column(
                                                    children: [
                                                      const SizedBox(height: 10,),                      
                                                     
                                                       expandedItem(title:"View business", iconData:Icons.remove_red_eye, onClick:  (){ 
                                                        find.selectedBusiness.value = business; 
                                                        Get.to(()=>CheckingForPayment()); 
                                                      }),
                                                   expandedItem(title:"Payments", iconData:Icons.done_all_sharp, onClick:  (){ 
                                                        find.selectedBusiness.value = business; 
                                                        Get.to(()=>PaymentsPage()); 
                                                      }),
                                                                                                                               
                                                    ],
                                                  ):Container(),
                                                )
                                             
                                  ],
                                ),
                                
                              ),),
                          ),
                       ) ).toList()),
                     ],
                   );
                 }
               )
        ],)
      ),);
  }
}