// ignore_for_file: avoid_unnecessary_containers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/controllers/register_controller.dart';
import 'package:pos/controllers/supplier_controller.dart';
import 'package:pos/controllers/worker_controller.dart';
import 'package:pos/pages/add_worker.dart';
import 'package:pos/pages/business_pages/business_to_supplier_chat_page.dart';
import 'package:pos/pages/business_pages/find_supplier.dart';
import 'package:pos/pages/business_pages/assign_register.dart';
import 'package:pos/pages/business_pages/order_chat_page.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/delete_confirmation.dart';
import 'package:pos/utils/notifications.dart';
import 'package:pos/widgets/avatar.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/expanded_item.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/heading_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/no_data.dart';
import 'package:pos/widgets/translatedText.dart';

class SuppliersPage extends StatefulWidget {
  const SuppliersPage({super.key});

  @override
  State<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  bool expanded = false;
  String supplierId = "";
  @override
  void initState() {
    Get.put(SupplierController());
    super.initState();
  }
  BusinessController businessController = Get.find<BusinessController>();
  @override
  Widget build(BuildContext context) {
    BusinessController find = Get.find<BusinessController>();
   
    return  Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(leading: back(),backgroundColor: backgroundColor,elevation: 0.3,
      title: Row(children: [
      
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading2(text:translatedText("Suppliers", "Wazambazaji")),
          

          ],
        ))
      ],) 
      ,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          
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
                    headingText(text: translatedText("Add new supplier", "Ongeza msambazaji mpya"),),
                    const SizedBox(height: 5,),
                    mutedText(text: translatedText("Add, remove and manage suppliers here", "Ongeza, ondoa au badili taarifa za msambazaji")),
                    const SizedBox(height: 20,),
                    customButton(text: translatedText("Find suppliers", "Ongeza msambazaji"),onClick: (){
                      Get.to(()=>FindSupplier());
                    }) 
                   ],),
                 ),),
               ),
               const SizedBox(height: 20,),
               heading2(text:translatedText("Available suppliers", "Wasambazaji waliopo")),
               const SizedBox(height: 20),
                 GetX<SupplierController>(
                init: SupplierController(),
                 builder: (find) {
                   return find.suppliers.isEmpty ?noData(): Column(children:find.suppliers.map((item) => Padding(
                     padding: const EdgeInsets.only(bottom: 15),
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
                                    if(supplierId == item.id){
                                      supplierId = "";
                                    }
                                    else{
                                    supplierId = item.id;
                                    }
                                  });
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Row(children:  [
                                  avatar(image: item.supplier.image,size: 50),
                                    const SizedBox(width: 10,),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                        heading2(text: item.supplier.name,fontSize:18),
                                        mutedText(text: item.supplier.description,maxLines: 1),
                                       
                                      ],),
                                    ),
                                                ],),
                                  ),
                                ),
                                 AnimatedSize(
                                              duration: const Duration(milliseconds: 200),
                                              child:supplierId == item.id ? Column(
                                                children: [
                                                  const SizedBox(height: 10,),                      
                                                     expandedItem(title:"Chat with a supplier", iconData:Icons.message, onClick:  (){
                                                       businessController.selectedSender.value = item.supplier;
                                                       find.selectedSupplier.value = item;
                                                      Get.to(()=>BusinessToSupplierChatPage());
                                                  },elevation: 0), 
                                                   expandedItem(title:"Delete this suppllier", iconData:Icons.delete, onClick:  (){
                                                    confirmDelete(context,onClick: (){
                                                             find.deleteSupplier(item.id);
                                                    },onSuccess: (){
                                                         successNotification("Supplier is deleted successfully");
                                                    });
                                                  },elevation: 0),                                                                          
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