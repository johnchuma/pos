import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/controllers/supplier_order_controller.dart';
import 'package:pos/pages/business_pages/add_product.dart';
import 'package:pos/pages/business_pages/confirm_received_order.dart';
import 'package:pos/pages/business_pages/pick_products_to_order.dart';
import 'package:pos/pages/business_pages/previous_orders.dart';
import 'package:pos/pages/business_pages/product_stock.dart';
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
import 'package:timeago/timeago.dart' as timeago;

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool expanded = false;
  String supplierOrderId = "";
  @override
  void initState() {
    Get.put(ProductController());
    Get.put(SupplierOrderController());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    BusinessController find = Get.find<BusinessController>();
    return  Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(leading: back(),backgroundColor: backgroundColor,elevation: 0.3,
      title: heading2(text: "Orders to suppliers") 
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
                    headingText(text: "Create new order",),
                    const SizedBox(height: 5,),
                    
                    mutedText(text: "Pick products to order to a supplier"),
                    const SizedBox(height: 20,),
                    customButton(text: "Create new order",onClick: (){
                      Get.to(()=>PickProductsToOrder());
                    })
                    
                   ],),
                 ),),
               ),
               const SizedBox(height: 20,),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   heading2(text: "Orders list"),
                   GestureDetector(
                    onTap: (){
                         Get.to(()=>const PreviousOrders());
                    },
                    child: mutedText(text: "Completed orders ",color: mutedColor,fontSize: 13))
                 ],
               ),

               const SizedBox(height: 20),
                 GetX<SupplierOrderController>(
                init: SupplierOrderController(),
                 builder: (find) {
                   return find.supplierOrders.isEmpty?noData(): Column(children:find.supplierOrders.map((item) => Padding(
                     padding: const EdgeInsets.only(bottom: 10),
                     child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          color: item.inAppOrder ?Colors.green.withOpacity(0.1) :Colors.white,
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
                                 item.inAppOrder?Container(
                                  height: 30,
                                  child: Image.asset("assets/check-mark_5290058.png"),):avatar(image: item.supplier.image),
                                  SizedBox(width: 10,),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                        heading2(text: item.inAppOrder == true? "In app order": "Order to ${item.supplier.name}",fontSize: 14),
                                        mutedText(text:"Ordered ${timeago.format(item.createdAt.toDate()) }"),
                                      ],),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        find.selectedSupplierOrder.value = item;
                                        Get.to(OrderChatPage());
                                      },
                                      child: Icon(Ionicons.chatbubble, size: 30,color: mutedColor.withOpacity(0.4),))
                                  
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
                                                     heading2(text: "Ordered products",fontSize: 14,color: primaryColor),
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
                                                            Obx(
                                                              ()=> Checkbox(value: productOrder.isDelivered.value,activeColor: Colors.green, onChanged: (value){
                                                              find.selectedProductOrder.value  = productOrder;
                                                              find.selectedSupplierOrder.value = item;
                                                              if(value == false){
                                                                setState(() {
                                                                  
                                                                find.updateOrderProducts(productOrder.id,data:{"isDelivered":false});
                                                                productOrder.isDelivered.value = false;
                                                                });
                                                              }else{
                                                               Get.bottomSheet(
                                                                Container(width:MediaQuery.of(context).size.width,
                                                                child: const ConfirmReceivedOrder(),
                                                              )
                                                              );
                                                              }
                                                              
                                                           
                                                              }),
                                                            )
                                                                                                          
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
        ],)
      ),);
  }
}