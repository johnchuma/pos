import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/controllers/retailer_order_controller.dart';
import 'package:pos/controllers/supplier_order_controller.dart';
import 'package:pos/controllers/unread_messages_controller.dart';

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
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/translatedText.dart';
import 'package:timeago/timeago.dart' as timeago;

class SupplierOrdersPage extends StatefulWidget {
  const SupplierOrdersPage({super.key});

  @override
  State<SupplierOrdersPage> createState() => _SupplierOrdersPageState();
}

class _SupplierOrdersPageState extends State<SupplierOrdersPage> {
  bool expanded = false;
  String supplierOrderId = "";
  @override
  void initState() {
    Get.put(ProductController());
    Get.put(RetailerOrderController());
    super.initState();
  }
  BusinessController businessController = Get.find<BusinessController>();
  @override
  Widget build(BuildContext context) {
    BusinessController find = Get.find<BusinessController>();
  RetailerOrderController retailerOrderController= Get.find<RetailerOrderController>();

    return  Scaffold(
        backgroundColor: backgroundColor,
      appBar: AppBar(leading: back(),backgroundColor: backgroundColor,elevation: 0.3,
      title: Row(children: [
        
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading2(text:translatedText("Product orders", "Order za bidhaa")),
          

          ],
        ))
      ],) 
      ,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
              children: [
                      const SizedBox(height: 20,),
                     GetX<SupplierOrderController>(
                    init: SupplierOrderController(),
                     builder: (find) {
                      // print(find.supplierOrders.length);
                       return find.fetching.value?Container(
                        height: MediaQuery.of(context).size.height-200,
                        child: Center(child: CircularProgressIndicator(color: textColor,),)): find.supplierOrders.isEmpty?noData(): Column(children:find.supplierOrders.map((item) => Padding(
                         padding: const EdgeInsets.only(bottom: 10),
                         child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              color: item.inAppOrder ?Colors.green.withOpacity(0.1) :mutedBackground,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                            retailerOrderController.selectedSupplierOrder.value = item;
                                            businessController.selectedSender.value = item.from;
                                            Get.to(const OrderChatPage());
                                            UnreadMessagesController().updateAllUnreadMessages(messages:item.unreadMessages.value);
                                        // setState(() {
                                        //   if(supplierOrderId == item.id){
                                        //   supplierOrderId = "";
                                        //   }else{
                                        //   supplierOrderId = item.id;
                                        //   }
                                        // });
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Row(children:  [
                                     item.inAppOrder?Container(
                                      height: 30,
                                      child: Image.asset("assets/check-mark_5290058.png"),):avatar(image: item.from.image),
                                      SizedBox(width: 10,),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                            heading2(text: item.inAppOrder == true? "In app order": "${item.from.name}",fontSize: 14,maxLines: 1),
                                          item.unreadMessages.value.length>0? mutedText(text:"${item.unreadMessages.value.last?.message}"): mutedText(text:"Ordered ${timeago.format(item.createdAt.toDate()) }"),
                                          ],),
                                        ),
                                        SizedBox(width: 10,),
                                          GestureDetector(
                                          onTap: (){
                                            retailerOrderController.selectedSupplierOrder.value = item;
                                            businessController.selectedSender.value = item.from;
                                            Get.to(const OrderChatPage());
                                          },
                                          child:  item.unreadMessages.value.isNotEmpty ? ClipOval(child: Container(width: 25,height: 25,color: Colors.red,  child: Center(child: paragraph(text: item.unreadMessages.value.length.toString(),color: Colors.white,fontSize: 11)),))
                                        :  Icon(Ionicons.chatbubble, size: 25,color: mutedColor.withOpacity(0.4),))
                                                    ],),
                                      ),
                                    ),
                                  
                                                 AnimatedSize(
                                                  duration: const Duration(milliseconds: 200),
                                                  child: supplierOrderId == item.id ? Padding(
                                                    padding: const EdgeInsets.only(left: 8),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                         SizedBox(height: 20,),
                                                         heading2(text: "Ordered products",fontSize: 14,color:mutedColor),
                                                         SizedBox(height: 20,),
                                                         Obx(
                                                           ()=> Column(children:item.productOrders.value.map((productOrder)=>
                                                            Padding(
                                                              padding: const EdgeInsets.only(bottom: 10),
                                                              child: Row(
                                                                 crossAxisAlignment: CrossAxisAlignment.center,
                                                                 children: [
                                                                 ClipRRect(
                                                                   borderRadius: BorderRadius.circular(15),
                                                                   child: Container(width: 80,height: 80,child: CachedNetworkImage(imageUrl:productOrder.product.value!.image,fit: BoxFit.cover, ),)),
                                                                                                              
                                                                                                               SizedBox(width: 20,),
                                                                                                               Expanded(
                                                               child: Column(
                                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                                 mainAxisAlignment: MainAxisAlignment.center,
                                                                 children: [
                                                                  heading2(text: productOrder.product.value!.name,fontSize: 14),
                                                                 Obx(()=> mutedText(text: "Quantity: ${productOrder.amount}")),
                                                               ],),
                                                              ),
                                                               
                                                                                                              
                                                                                     ]),
                                                            )
                                                           ).toList(),),
                                                         ),
                                                         SizedBox(height: 20,),
                                                                                                                    
                                                      ],
                                                    ),
                                                  ):Container(),
                                                )
                                  ],
                                ),
                                
                              ),),
                          ),
                       ) ).toList());
                     }
                   )
            ],),
      ),
    );
     
  }
}