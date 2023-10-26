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
import 'package:pos/pages/add_worker.dart';
import 'package:pos/pages/business_pages/assign_register.dart';
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
          heading2(text: "Trade Point clients"),
        ],
      ) 
      ,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          
          children: [
                      const SizedBox(height: 0,),

               const SizedBox(height: 20),
                 GetX<ClientsController>(
                init: ClientsController(),
                 builder: (find) {
                   return Column(children:find.clients.map((client) => Padding(
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
                                    if(clientId == client.id){
                                       clientId = "";
                                      }else{
                                       clientId = client.id;
                                      }
                                    });
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Row(children:  [
                                      ClipOval(
                                      child: SizedBox(height: 50,width: 50,child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl:client.profileImageUrl),),
                                    ),
                                    const SizedBox(width: 10,),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                        heading2(text: client.name,fontSize: 14),
                                        mutedText(text: client.email),
                                       
                                      ],),
                                    ),
                                                ],),
                                  ),
                                ),
                                 AnimatedSize(
                                              duration: const Duration(milliseconds: 200),
                                              child:clientId == client.id ? Column(
                                                children: [
                                                  const SizedBox(height: 10,),                      
                                                  expandedItem(title:"Chat with client", iconData:Icons.chat_bubble, onClick:  (){ 
                                                     find.selectedClient.value = client;
                                                    Get.to(()=>PrivateChatRoom()); 
                                                  }),
                                                
                                                  
                                               
                                                                                                                           
                                                ],
                                              ):Container(),
                                            )
                                         
                              ],
                            ),
                            
                          ),),
                      ),
                   ) ).toList());
                 }
               )
        ],)
      ),);
  }
}