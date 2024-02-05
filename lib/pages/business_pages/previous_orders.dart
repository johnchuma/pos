import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/controllers/retailer_order_controller.dart';
import 'package:pos/pages/business_pages/add_product.dart';
import 'package:pos/pages/business_pages/pick_products_to_order.dart';
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
import 'package:pos/widgets/paragraph.dart';

class PreviousOrders extends StatefulWidget {
  const PreviousOrders({super.key});

  @override
  State<PreviousOrders> createState() => _PreviousOrdersState();
}

class _PreviousOrdersState extends State<PreviousOrders> {
  bool expanded = false;
  String supplierOrderId = "";
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
      
        const SizedBox(width: 10,),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading2(text: "Completed orders"),
            

          ],
        ))
      ],) 
      ,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          
          children: [
                     SizedBox(height: 20,),
                 GetX<RetailerOrderController>(
                init: RetailerOrderController(),
                 builder: (find) {
                   return Column(children:find.completedOrders.map((item) => Padding(
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
                                    setState(() {
                                      if(supplierOrderId == item.id){
                                      supplierOrderId = "";
                                      }else{
                                      supplierOrderId = item.id;
                                      }
                                    });
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Row(children:  [
                                 if(item.inAppOrder)Container(
                                  height: 30,
                                  child: Image.asset("assets/check-mark_5290058.png"),),
                                  SizedBox(width: 10,),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                        heading2(text: item.inAppOrder == true? "In app order": "An order to ${item.supplier.name}",fontSize:18),
                                        mutedText(text:"${item.createdAt.toDate()}"),
                                      ],),
                                    ),
                                   
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
                                                     heading2(text: "Ordered products",fontSize:18,color:mutedColor),
                                                     SizedBox(height: 20,),
                                                     Column(children:item.productOrders.value.map((productOrder)=>
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
                                                            heading2(text: productOrder.product.value!.name,fontSize:18),
                                                           mutedText(text: "Amount: ${productOrder.amount}"),
                                                          
                                                         
                                                         ],),
                                                        ),
                                                          Checkbox(value: productOrder.isDelivered.value,
                                                           fillColor: MaterialStateColor.resolveWith((states) =>Colors.white ),
                                                                splashRadius: 50,
                                                                activeColor: Colors.green,
                                                                hoverColor: primaryColor,
                                                                checkColor: Colors.black,
                                                                focusColor: Colors.black,
                                                          
                                                           onChanged: (value){
                                                            var data = {"isDelivered":!productOrder.isDelivered.value};
                                                            setState(() {
                                                           productOrder.isDelivered.value = !productOrder.isDelivered.value;
                                                                
                                                              });
                                                            find.updateOrderProducts(productOrder.id,data: data).then((value) {
                                                             
                                                            });
                                                            if(item.areAllProductsDelivered()){
                                                              find.updateSupplierProducts(item.id,data: {"isClosed":true}).then((value) {
                                                                successNotification("Order is completed successfully");
                                                              });

                                                            }else{
                                                              find.updateSupplierProducts(item.id,data: {"isClosed":false});
                                                            }
                                                          })
                                                                                                        
                                                                               ]),
                                                      )
                                                     ).toList(),),
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
        ],)
      ),);
  }
}