import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/retailer_order_controller.dart';

import 'package:pos/controllers/register_controller.dart';
import 'package:pos/controllers/staff_register_controller.dart';
import 'package:pos/controllers/supplier_controller.dart';
import 'package:pos/controllers/worker_controller.dart';
import 'package:pos/models/staff_registers.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/avatar.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';

class SelectOrderSupplier extends StatefulWidget {
  const SelectOrderSupplier({super.key});

  @override
  State<SelectOrderSupplier> createState() => _SelectOrderSupplierState();
}

class _SelectOrderSupplierState extends State<SelectOrderSupplier> {  


RetailerOrderController retailerOrderController = Get.find<RetailerOrderController>();
bool loading = false;
  @override
  Widget build(BuildContext context) {
    return GetX<SupplierController>(
      init: SupplierController(),
      builder: (find) {
        return SingleChildScrollView(
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
                  const SizedBox(height: 30,),
                  
                  heading2(text: "select a supplier for this order",),
        
                  const SizedBox(height: 20,),
                  AnimatedSize(
                    duration: Duration(milliseconds: 300),
                    child: Container(
                      child: Column(
                        children: [
                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(15),
                          //   child: Container(color: Colors.green.withOpacity(0.1),
                          //   child: Padding(
                          //     padding: const EdgeInsets.symmetric(vertical: 20),
                          //     child: Row(
                          //       children: [
                          //         Obx(()=> Checkbox(value: retailerOrderController.selectedSupplier.value == null, onChanged: (value){
                          //           retailerOrderController.selectedSupplier.value = null;
                          //         },activeColor: Colors.green,)),
                                  
                          //         Expanded(
                          //           child: Column(
                          //             crossAxisAlignment: CrossAxisAlignment.start,
                          //             children: [
                          //               heading2(text: "Order in app"),
                          //           mutedText(text: "Get your order within 24 hours, pay on delivery")
                                  
                          //             ],
                          //           ),
                          //         ),
                          //         Container(
                          //           height: 50,
                          //           child: Image.asset("assets/check-mark_5290058.png"),),
                          //         SizedBox(width: 20,)
                          //       ],
                          //     ),
                          //   ),
                          //   ),
                          // ),
                          // SizedBox(height: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: find.suppliers.map((item)=>Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(child: Row(children: [
                              Obx(()=>
                                 Checkbox(
                                  activeColor: Colors.green[600],
                                  focusColor: mutedColor,
                                  value:retailerOrderController.selectedSupplier.value==null?false:retailerOrderController.selectedSupplier.value?.id == item.id?true:false, onChanged: (value){
                                  
                                    if(value == true){
                                  retailerOrderController.selectedSupplier.value = item;
                                           
                                    }
                                    else{
                                      retailerOrderController.selectedSupplier.value= null;
                                    }
                                    
                                  
                                }),
                              ),
                              SizedBox(width: 10,),
                              avatar(image: item.supplier.image,size: 50)
                              ,SizedBox(width: 10,),
                               Expanded(
                                 child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     heading2(text: item.supplier.name),
                                     mutedText(text: item.supplier.description,maxLines: 1)
                               
                                   ],
                                 ),
                               ),
                                                      ],),),
                            )).toList(),),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  
                  customButton(text: "Send order",loading: loading, onClick: (){
                  setState(() {
                    loading = true;
                  });
                    retailerOrderController.addSupplierOrder().then((value) {
                      setState(() {
                    loading = false;
                    Get.back();
                    Get.back();
        
                  });
                    });
                  }),
                  const SizedBox(height: 30,),

                ],),
              ),
            )),
        );
      }
    );
  }
}