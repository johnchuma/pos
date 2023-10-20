// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/controllers/stock_controller.dart';
import 'package:pos/pages/business_pages/add_stock.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/avatar.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/heading_text.dart';
import 'package:pos/widgets/muted_text.dart';

class ProductStock extends StatefulWidget {
  const ProductStock({super.key});
  @override
  State<ProductStock> createState() => _ProductStockState();
}

class _ProductStockState extends State<ProductStock> {
  bool expanded = false;
  String productId = "";
  @override
  Widget build(BuildContext context) {
    ProductController productController = Get.find<ProductController>();
    BusinessController find2 = Get.find<BusinessController>();
    
    return  Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(leading: back(),backgroundColor: backgroundColor,elevation: 0.3,
      title: Row(children: [
        ClipOval(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: avatar(image:productController.selectedProduct.value.image,size: 30),
          ),
        ),
        const SizedBox(width: 10,),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading2(text: productController.selectedProduct.value.name),
            mutedText(text: "from ${find2.selectedBusiness.value.name}")
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
                   child: Column (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    headingText(text: "Manage product stocks",),
                    const SizedBox(height: 5,),
                    mutedText(text: "Add,edit,delete and view products here"),
                    const SizedBox(height: 20,),
                    customButton(text: "Add stock",onClick: (){
                      Get.to(()=>AddStock());
                    })
                   ],),
                 ),),
               ),
               const SizedBox(height: 20,),
               heading2(text: "Stock history"),
               const SizedBox(height: 20),
                 GetX<StockController>(
                init: StockController(),
                 builder: (find) {
                   return Column(children:find.stocks.map((stock) => Padding(
                     padding: const EdgeInsets.only(bottom: 15),
                     child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                       child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                          child: Row(
                            children: [
                              avatar(image:productController.selectedProduct.value.image,size: 30 ),
                              const SizedBox(width: 20,),
                              Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 heading2(text: stock.amount),
                                 mutedText(text: stock.createdAt.toDate())
                               ],
                                                 ),
                            ],
                          ),
                        ),),
                     )
                   ) ).toList());
                 }
               )
        ],)
      ),);
  }
}