import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/supplier_controller.dart';
import 'package:pos/pages/business_pages/business_to_supplier_chat_page.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/avatar.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/translatedText.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../controllers/suppliers_conversations_controller.dart';

class BusinessesConversation extends StatelessWidget {
   BusinessesConversation({super.key});
   BusinessController businessController = Get.find<BusinessController>();
  SupplierController supplierController = Get.find<SupplierController>();
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
        backgroundColor: backgroundColor,
      appBar: AppBar(leading: back(),backgroundColor: backgroundColor,elevation: 0.3,
      title: Row(children: [
        
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading2(text:translatedText("Conversations", "Maulizo ya bidhaa")),
          

          ],
        ))
      ],) 
      ,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GetX<SuppliersConversationsController>(
                init: SuppliersConversationsController(),
                builder: (find) {
                  return ListView(children: find.suppliers.map((item) => 
                  GestureDetector(
                    onTap: (){
                      find.updateAllNewConversations(item?.messages);
                      businessController.selectedSender.value = item!.business;
                      supplierController.selectedSupplier.value = item;
                      Get.to(()=>const BusinessToSupplierChatPage());
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          color: mutedBackground,
                          child: 
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [avatar(image: item?.business.image),
                          const SizedBox(width: 14,),
                           Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                heading2(text:item?.business.name,fontSize: 15),
                            item?.messages.value.isEmpty == true ?mutedText(text: "No new messages for now"):
                             Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 paragraph(text: item?.messages.value.first.message,maxLines: 1),
                                 mutedText(text: timeago.format(item!.messages.value.first.createdAt.toDate()),fontSize: 14)
                               ],
                             ),
                              ],
                            ),   
                          ),
                        if(item?.messages.value.isNotEmpty == true)  ClipOval(child: Container(width: 25,height: 25,color: primaryColor,  child: Center(child: paragraph(text: item!.messages.value.length.toString(),color:mutedColor,fontSize: 11)),))
                          ],),
                        )
                        
                        ,),
                      ),
                    ),
                  )).toList(),);
                }
              ),
      ),
    );
  }
}