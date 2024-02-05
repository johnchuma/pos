import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/controllers/product_request_controller.dart';
import 'package:pos/pages/admin/approve_request.dart';
import 'package:pos/pages/business_pages/product_request_chat_page.dart';
import 'package:pos/pages/business_pages/request_product.dart';
import 'package:pos/pages/my_product_requests.dart';
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
import 'package:timeago/timeago.dart' as timeago;

class PublicProductsConversations extends StatefulWidget {
  const PublicProductsConversations({super.key});

  @override
  State<PublicProductsConversations> createState() => _PublicProductsConversationsState();
}

class _PublicProductsConversationsState extends State<PublicProductsConversations> {
  bool expanded = false;
  String productrequestId = "";
  @override
  void initState() {
    super.initState();
  }
  BusinessController businessController = Get.find<BusinessController>();
  @override
  Widget build(BuildContext context) {
  
    return  Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(leading: back(),backgroundColor: backgroundColor,elevation: 0.3,
      title: Row(children: [
        
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading2(text:translatedText("Product requests", "Maulizo ya bidhaa")),
          ],
        ))
      ],) 
      ,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                
                children: [
                       
                     
                       GetX<ProductRequestController>(
                      init: ProductRequestController(selectedStream: 2),
                       builder: (find) {
                         return find.productrequests.isEmpty ?noData(): Column(children:find.productrequests.map((productrequest) => Padding(
                           padding: const EdgeInsets.only(bottom: 15),
                           child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                            List offers = productrequest.businessesThatSentTheirOffers;
                                            Set uniqueOffers = {};
                                            find.selectedProductRequest.value = productrequest;
                                            uniqueOffers.addAll(offers);
                                            uniqueOffers.add(businessController.selectedBusiness.value?.id);
                                            find.isClient = false;
                                            find.aboutProductRequest = true;
                                            find.updateRequest(data: {"businessesThatSentTheirOffers":uniqueOffers.toList()});
                                            find.selectedClient.value = productrequest.client;
                                            Get.to(()=>const ProductRequestChatPage());
                                          
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Row(children:  [
                                           
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                              heading2(text: productrequest.request,fontSize:18),
                                              mutedText(text:timeago.format(productrequest.createdAt.toDate()),maxLines: 2 ),
                                             
                                            ],),
                                          ),
                                                      ],),
                                        ),
                                      ),
                                     
                                               
                                    ],
                                  ),
                                  
                                ),),
                            ),
                         ) ).toList());
                       }
                     )
              ],),
            ),
           
          ],
        )
      ),);
  }
}