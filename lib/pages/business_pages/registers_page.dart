import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/controllers/register_controller.dart';
import 'package:pos/controllers/worker_controller.dart';
import 'package:pos/pages/add_worker.dart';
import 'package:pos/pages/business_pages/add_register.dart';
import 'package:pos/pages/business_pages/edit_pages/edit_register.dart';
import 'package:pos/pages/business_pages/product_stock.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/delete_confirmation.dart';
import 'package:pos/utils/notifications.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/expanded_item.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/heading_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/no_data.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/translatedText.dart';

class RegistersPage extends StatefulWidget {
  const RegistersPage({super.key});

  @override
  State<RegistersPage> createState() => _RegistersPageState();
}

class _RegistersPageState extends State<RegistersPage> {
  bool expanded = false;
  String registerId = "";
  @override
  void initState() {
    Get.put(ProductController());
    super.initState();
  }
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
            heading2(text:translatedText("Registers", "Madirisha ya mauzo")),
          

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
                    headingText(text: translatedText("Add new register", "Ongeza dirisha jipya"),),
                    const SizedBox(height: 5,),
                    mutedText(text: translatedText("Add, remove and manage registers", "Ongeza, futa au boresha dirisha jipya")),
                    const SizedBox(height: 20,),
                    customButton(text: translatedText("Add register", "Ongeza dirisha"),onClick: (){
                      Get.to(()=>AddRegister());
                    }) 
                   ],),
                 ),),
               ),
               const SizedBox(height: 20,),
               heading2(text: translatedText("Available registers", "Madirisha yaliyopo")),
               const SizedBox(height: 20),
                 GetX<RegisterController>(
                init: RegisterController(),
                 builder: (find) {
                   return find.registers.isEmpty ?noData(): Column(children:find.registers.map((register) => Padding(
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
                                    if(registerId == register.id){
                                       registerId = "";
                                      }else{
                                       registerId = register.id;
                                      }
                                    });
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Row(children:  [
                                     
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                        heading2(text: register.title,fontSize: 14),
                                        mutedText(text: register.description),
                                       
                                      ],),
                                    ),
                                                ],),
                                  ),
                                ),
                                 AnimatedSize(
                                              duration: const Duration(milliseconds: 200),
                                              child:registerId == register.id ? Column(
                                                children: [
                                                  const SizedBox(height: 10,),                      
                                                  expandedItem(title:translatedText("Edit register", "Boresha taarifa za dirisha"), iconData:Icons.edit, onClick:  (){   
                                                   find.selectedRegister = register;
                                                   Get.to(()=>UpdateRegister());
                                                  
                                                  }),
                                                   expandedItem(title:translatedText("Delete register", "Futa dirisha"), iconData:Icons.delete, onClick:  (){
                                                    confirmDelete(context,onClick:  (){
                                                        find.deleteRegister(register.id);
                                                    },onSuccess: (){
                                                      successNotification(translatedText("Register is deleted successfully", "Umefanikiwa kufuta dirisha") );
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