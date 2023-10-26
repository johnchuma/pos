

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/app_controller.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/businesses_chat_controller.dart';
import 'package:pos/controllers/clients_controller.dart';
import 'package:pos/controllers/private_chat_controller.dart';
import 'package:pos/controllers/order_chat_controller.dart';
import 'package:pos/controllers/supplier_controller.dart';
import 'package:pos/models/client.dart';
import 'package:pos/models/message_model.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/avatar.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/chat_item.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';

class BusinessToSupplierChatPage extends StatefulWidget {
  
   const BusinessToSupplierChatPage({super.key});

  @override
  State<BusinessToSupplierChatPage> createState() => _BusinessToSupplierChatPageState();
}

class _BusinessToSupplierChatPageState extends State<BusinessToSupplierChatPage> {
   var message = "";
  TextEditingController messageController = TextEditingController();
  AuthController authController  = Get.find<AuthController>();
  ClientsController clientController  = Get.find<ClientsController>();
 
  BusinessController businessController = Get.find<BusinessController>();
  AppController appController = Get.find<AppController>();
  
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: backgroundColor,
        
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0.3,
          leading: Container(),
         leadingWidth: 1,
          title: Row(children: [
            
           Row(
            children: [
              back(),
              const SizedBox(width: 20,),
              avatar(size: 35,image: businessController.selectedSender.value.image),
              SizedBox(width: 10,),
              heading2(text: businessController.selectedSender.value.name)
            ],
          )
          ],),
        ),
        body: GetX<BusinessToSupplierChatController>(
          init: BusinessToSupplierChatController(),
          builder: (find) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Stack(
                children: [
                  SizedBox(height: 20,),
                  Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                     
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 80),
                            child: ListView(
                              reverse: true,
                              children:find.messages.map((item) => GestureDetector(
                                onLongPress: (){
                                  find.deleteMessage(item?.id);
                                },
                                child: chatItem(item: item))).toList(),
                              ),
                          ),
                        ),
                      )
                  ],),
                   Positioned(
                    bottom: 0,
                    left: 0,
                    right:0,
                     child: Container(
                  color: Colors.black12.withOpacity(0.03),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                    child: TextFormField(
                      controller: messageController,
                      onChanged: ((value){
                        setState(() {
                          message = value;
                        });
                      }),
                      maxLines: 4,
                      minLines: 1,
                      style: TextStyle(color: textColor),
                      decoration:  InputDecoration(
                        hintStyle: TextStyle(color: mutedColor),
                        suffixIcon: GestureDetector(
                              
                              child:  GestureDetector(
                                onTap: (){
                                  find.sendMessage(message);
                                  setState(() {
                                  messageController.clear();
                                    message = "";
                                  });
                                },
                                child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                color: primaryColor,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 13),
                                  child: Icon(Icons.send,color: Colors.white, size: 20,),
                                )),
                              )),
                            ),
                        border: InputBorder.none,hintText: "Type your message here...")),
                  )),
                   )
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}