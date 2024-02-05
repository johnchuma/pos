import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

import 'package:pos/controllers/register_controller.dart';
import 'package:pos/controllers/staff_register_controller.dart';
import 'package:pos/controllers/stock_controller.dart';
import 'package:pos/controllers/retailer_order_controller.dart';
import 'package:pos/controllers/worker_controller.dart';
import 'package:pos/models/staff_registers.dart';
import 'package:pos/pages/business_pages/add_order_to_stock.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/delete_confirmation.dart';
import 'package:pos/utils/notifications.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/text_form.dart';

class ConfirmReceivedOrder extends StatefulWidget {
  const ConfirmReceivedOrder({super.key});

  @override
  State<ConfirmReceivedOrder> createState() => _ConfirmReceivedOrderState();
}

class _ConfirmReceivedOrderState extends State<ConfirmReceivedOrder> {  

TextEditingController passwordController = TextEditingController();
  RetailerOrderController find = Get.find<RetailerOrderController>();
  bool show = false;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
            child: Container(
              color: mutedBackground,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                
                const SizedBox(height: 10,),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(width: 80,height: 5,color: backgroundColor,))],),
                  const SizedBox(height: 20,),
                  heading2(text: "Confirm order delivery",textAlign:TextAlign.start ),
                  const SizedBox(height: 10,),
                  Row(children: [ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      height: 80,
                      width: 80,
                      child: CachedNetworkImage(imageUrl: find.selectedProductOrder.value!.product.value!.image,fit: BoxFit.cover,),),
                  ),
                    SizedBox(width:10,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          heading2(text: find.selectedProductOrder.value!.product.value?.name,fontSize: 14),
                          mutedText(text:"Quantity ordered: ${find.selectedProductOrder.value!.amount}" )
                        ],
                      ),
                    )
                    
                    ],),
                    SizedBox(height: 20,),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      color: backgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Checkbox(value: show,
                             fillColor: MaterialStateColor.resolveWith((states) =>Colors.white ),
                              splashRadius: 50,
                              activeColor: Colors.green,
                              hoverColor: primaryColor,
                              checkColor: Colors.black,
                              focusColor: Colors.black,
                               onChanged: (value){
                                    setState(() {
                                      show = value!;
                                    });
                              }),
                              Expanded(child: mutedText(text: "Received quantity is different from what was ordered ?",fontSize: 13))
                            ],),
                          AnimatedSize(
                            duration: Duration(milliseconds: 300),
                            child: !show?Container():Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    heading2(text: "Enter amount your recieived",fontSize: 13,color: textColor),
                                    SizedBox(height: 15,),
                                        Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                GestureDetector(
                                  onTap: (){
                                    double amount =   find.selectedProductOrder.value!.amount.value;
                                    if(amount >1){
                                    setState(() {
                                     find.selectedProductOrder.value!.amount.value = amount -1;
                                    });
                                    }
                                   
                                  },
                                  child: Icon(Icons.remove,color:mutedColor,)),
                                SizedBox(width: 20,),
                                heading2(text: find.selectedProductOrder.value!.amount,color: textColor),
                                SizedBox(width: 20,),
                                GestureDetector(
                                  onTap: (){
                                    double amount =   find.selectedProductOrder.value!.amount.value;
                                    setState(() {
                                     find.selectedProductOrder.value!.amount.value = amount +1;
                                    });
                                  },
                                  child: Icon(Icons.add,color:mutedColor,))
                              
                                                  
                                                ],),
                                  ],
                                ),
                              ),
                          ),
                        
                          ],
                          
                        ),
                      ),
                    ),
                  ),
                                       
                  
                  const SizedBox(height: 20,),
                 customButton(text: "Confirm delivery",loading: loading,onClick: (){
                  setState(() {
                    loading = true;
                  });
                  find.selectedProductOrder.value?.isDelivered.value = true;
                    var data = {"isDelivered":true,"amount":find.selectedProductOrder.value!.amount.value};
                      find.updateOrderProducts(find.selectedProductOrder.value!.id,data: data).then((value) {
                         setState(() {
                      loading = false;
                     });
                  Get.back();
                  Get.bottomSheet(const AddorderToStock());
                      });

                    
                    }),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            confirmDelete(context,onClick: (){
                              find.deleteOrderProduct(find.selectedProductOrder.value?.id);
                              print(find.selectedSupplierOrder.value!.productOrders.value.length);
                              find.selectedSupplierOrder.value!.productOrders.value.removeWhere((element) => element.id == find.selectedProductOrder.value?.id);
                             var remainedOrders = find.selectedSupplierOrder.value!.productOrders.value;
                             find.selectedSupplierOrder.value!.productOrders.value = [];
                             find.selectedSupplierOrder.value!.productOrders.value = remainedOrders;
                            
                              Get.back();
                              

                            },onSuccess: (){
                              successNotification("Removed successfully!");
                            });
                          },
                          child: heading2(text: "Not available on delivery, delete ?",fontSize: 13,color: mutedColor.withOpacity(0.6))),
                      ],
                    ),
                    SizedBox(height: 20,),

                ],),
              ),
            )),
        );
     
  }
}