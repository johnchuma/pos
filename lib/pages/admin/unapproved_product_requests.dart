import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/controllers/product_request_controller.dart';
import 'package:pos/pages/admin/approve_request.dart';
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

class UnapprovedProductsRequests extends StatefulWidget {
  const UnapprovedProductsRequests({super.key});

  @override
  State<UnapprovedProductsRequests> createState() => _UnapprovedProductsRequestsState();
}

class _UnapprovedProductsRequestsState extends State<UnapprovedProductsRequests> {
  bool expanded = false;
  String productrequestId = "";
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  
    return  Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(leading: back(),backgroundColor: backgroundColor,elevation: 0.3,
      title: Row(children: [
        
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading2(text:translatedText("Unapproved requests", "Maulizo yangu")),
          

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
                       GetX<ProductRequestController>(
                      init: ProductRequestController(selectedStream: 1),
                       builder: (find) {
                         return find.productrequests.isEmpty ?noData(): Column(children:find.productrequests.map((productrequest) => Padding(
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
                                          if(productrequestId == productrequest.id){
                                             productrequestId = "";
                                            }else{
                                             productrequestId = productrequest.id;
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
                                              heading2(text: productrequest.request,fontSize: 14),
                                              mutedText(text:timeago.format(productrequest.createdAt.toDate()) ),
                                             
                                            ],),
                                          ),
                                                      ],),
                                        ),
                                      ),
                                       AnimatedSize(
                                                    duration: const Duration(milliseconds: 200),
                                                    child:productrequestId == productrequest.id ? Column(
                                                      children: [
                                                        const SizedBox(height: 10,),                      
                                                         expandedItem(title: "Approve request",iconData: Icons.handshake,onClick: (){
                                                             find.selectedProductRequest.value = productrequest;
                                                             Get.to(()=>ApproveRequest());
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
              ],),
            ),
           
          ],
        )
      ),);
  }
}