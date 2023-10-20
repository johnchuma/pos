// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/controllers/staff_sales_controller.dart';
import 'package:pos/controllers/sales_controller.dart';
import 'package:pos/controllers/supplier_controller.dart';
import 'package:pos/models/sale.dart';
import 'package:pos/pages/business_pages/find_supplier.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/avatar.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/expanded_item.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/heading_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/no_data.dart';

class StaffSales extends StatefulWidget {
  const StaffSales({super.key});

  @override
  State<StaffSales> createState() => _StaffSalesState();
}

class _StaffSalesState extends State<StaffSales> {
  bool expanded = false;
  String supplierId = "";
  String selectedOption = "Today";
  @override

 

  @override
  Widget build(BuildContext context) {
    
    StaffSaleController salesController= Get.find<StaffSaleController>();

    List functions  = [
      salesController.getTodaySales,
      salesController.getYesterdaySales,
      salesController.getThisWeekSales,
      salesController.getThisMonthSales,
      salesController.getThisYearSales,    
      salesController.getAllTimeSales,
      salesController.getInRangeSales,

    ];
    return  Obx(
      ()=>FutureBuilder(
          future: functions[salesController.selectedFunction.value](),
          builder: (context,AsyncSnapshot<List<Sale>> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Container(
                height: MediaQuery.of(context).size.height-200,
                child:Center(child: CircularProgressIndicator(color: textColor,),),);
            }
            List<Sale> sales = snapshot.requireData;
            return 
                 Expanded(
                   child: ListView(
                     children: [
                       ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                             child: Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                
                                  Padding(
                                   padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 20),
                                   child: Column
                                   (
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      mutedText(text: "Total sales",color: mutedColor.withOpacity(0.6)),
                                      SizedBox(height: 5,),
                                      headingText(text: "${salesController.totalSales(sales)} TZS",fontSize: 35),
                                      SizedBox(height: 10,),
                                    
                                      Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                       Row(
                                         children: [
                                          Icon(Icons.rocket,size: 20,color: Color.fromARGB(255, 230, 175, 10),),
                                          SizedBox(width: 5,),
                                           mutedText(text: "Capital: ${salesController.productsCapital(sales)}TZS",fontSize: 12),
                                         ],
                                       ),
                                       Row(
                                         children: [
                                          SizedBox(width: 20,),
                                                                            Icon(Icons.arrow_upward,size: 20,color:Colors.green),
                                           mutedText(text: "profit: ${salesController.productsProfit(sales)}TZS",fontSize: 12),
                                         ],
                                       ),
                                      ],
                                    ),
                                  SizedBox(height: 20,),
                                   
                             customButton(text: "Show graph")
                                  
                                   
                                   ],),
                             ),
                                ],
                              ),),
                           ),
                            const SizedBox(height: 20,),
                     heading2(text: "${salesController.selectedOption.toLowerCase()}'s sales"),
                     const SizedBox(height: 10),
                       Column(
                           children: [
                            
                            sales.isEmpty ?noData():   Column(children:sales.map((sales) => Padding(
                               padding: const EdgeInsets.only(bottom: 10),
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
                                            // setState(() {
                                            //   if(supplierId == supplier.id){
                                            //     supplierId = "";
                                            //   }
                                            //   else{
                                            //   supplierId = supplier.id;
                                            //   }
                                            // });
                                            },
                                            child: Container(
                                              color: Colors.transparent,
                                              child: Row(children:  [
                                               avatar(image: sales.product.image),
                                              const SizedBox(width: 10,),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                  heading2(text: sales.product.name,fontSize: 14),
                                                  mutedText(text: "Qantity: ${sales.amount}"),
                                                 
                                                ],),
                                              ),
                                              Column(
                                                children: [
                                                  mutedText(text: "Sold for",color: mutedColor.withOpacity(0.5)),
                                              heading2(text: "${sales.totalPrice}TZS",fontSize: 14)
    
                                                ],
                                              ),
                                                          ],),
                                            ),
                                          ),
                                           AnimatedSize(
                                                        duration: const Duration(milliseconds: 200),
                                                        child:supplierId == sales.id ? Column(
                                                          children: [
                                                                                                                                 
                                                          ],
                                                        ):Container(),
                                                      )
                                                   
                                        ],
                                      ),
                                      
                                    ),),
                                ),
                             ) ).toList()),
                           ],
                       
                     )
                     ],
                   ));
          }),
    );}}
                  
            
        
        