import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/controllers/product_request_controller.dart';
import 'package:pos/models/business.dart';
import 'package:pos/pages/business_pages/product_request_chat_page.dart';
import 'package:pos/pages/business_pages/request_product.dart';
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
import 'package:pos/widgets/translatedText.dart';
import 'package:timeago/timeago.dart' as timeago;

class BusinessThatMadeOffer extends StatefulWidget {
  const BusinessThatMadeOffer({super.key});

  @override
  State<BusinessThatMadeOffer> createState() => _BusinessThatMadeOfferState();
}

class _BusinessThatMadeOfferState extends State<BusinessThatMadeOffer> {
  bool expanded = false;
  String productrequestId = "";
  @override
  void initState() {
    super.initState();
  }
  BusinessController businessController = Get.find<BusinessController>();
  ProductRequestController  productRequestController = Get.find<ProductRequestController>();
  AuthController authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(leading: back(),backgroundColor: backgroundColor,elevation: 0.3,
      title: Row(children: [
        
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading2(text:translatedText("Offers from businesses", "Offers kutoka biashara mbalimbali")),
          

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
                       
                     const SizedBox(height: 20),
                       StreamBuilder(
                      stream: productRequestController.getBusinessesThatMadeOffers(),
                      initialData: [],
                       builder: (context,snapshot) {
                      var businesses = snapshot.requireData;
                         return businesses.isEmpty ?noData(): Column(children:businesses.map((business) => Padding(
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
                                              businessController.selectedBusiness.value = business;
                                              productRequestController.isClient = true;
                                              productRequestController.aboutProductRequest = true;
                                            productRequestController.selectedClient.value = authController.me.value;
                                              Get.to(()=>const ProductRequestChatPage());
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Row(children:  [
                                           
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                              heading2(text: business.name,fontSize: 14),
                                              mutedText(text:"Click to view offer" ),
                                             
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
             customButton(text: "New product request",onClick: (){
              Get.to(()=>RequestProduct());
            }),
            SizedBox(height: 30,)
          ],
        )
      ),);
  }
}