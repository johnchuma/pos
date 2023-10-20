import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/controllers/product_sales_controller.dart';
import 'package:pos/controllers/staff_sales_controller.dart';
import 'package:pos/controllers/sales_controller.dart';
import 'package:pos/pages/business_pages/staff_sales.dart';
import 'package:pos/pages/sales_reports.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/format_date.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';

class StaffSalesMain extends StatefulWidget {
  const StaffSalesMain({super.key});

  @override
  State<StaffSalesMain> createState() => _StaffSalesMainState();
}

class _StaffSalesMainState extends State<StaffSalesMain> {
  bool expanded = false;
  String supplierId = "";
  String selectedOption = "Today";
  @override
  void initState() {
   Get.put(ProductController());
    super.initState();
  }
    int currentfunction = 0;

  @override
  Widget build(BuildContext context) {
    BusinessController find = Get.find<BusinessController>();
    StaffSaleController salesController= Get.find<StaffSaleController>();

  
    return  Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(leading: back(),backgroundColor: backgroundColor,elevation: 0.3,
      title: Row(children: [
      
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading2(text: "${salesController.selectedStaff.value?.details.name}'s sales"),
       

          ],
        ))
      ],) 
      ,),
      body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              
              children: [
                  const SizedBox(height: 20,),
                   Container(
                          height: 40,
                           child: ListView(scrollDirection: Axis.horizontal,
                           children: [
                            {"title":"Today","function":0},
                            {"title":"Yeterday","function":1},
                            {"title":"This week","function":2},
                            {"title":"This month","function":3},
                            {"title":"This year","function":4},
                            {"title":"All time","function":5},
                            {"title": salesController.endingDate.value != null? "${formatDate(salesController.startingDate.value!)} - ${formatDate(salesController.endingDate.value!)}": "Select date range","function":6}
                           ].map((item) {
                            return GestureDetector(
                              onTap: (){
                                if(item["function"] == 6){
                                  Get.bottomSheet(SingleChildScrollView(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
                                      child: Container(color: Colors.white,child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                         const SizedBox(height: 20,),
                                            Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [ClipRRect(
                                            borderRadius: BorderRadius.circular(15),
                                            child: Container(width: 80,height: 5,color: primaryColor.withOpacity(0.2),))],),
                                                                         SizedBox(height: 20,),
                                                                         heading2(text: "Filter sales reports by date range",color: primaryColor)
                                        , 
                                         const SizedBox(height: 20,),
                                        
                                         Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            mutedText(text: "Starting date"),
                                            GestureDetector(
                                              onTap: ()async{
                                                 DateTime? startDate = await showDatePicker(context: context, firstDate: DateTime.now().subtract(Duration(days: 5000)), initialDate: DateTime.now(), lastDate:DateTime.now());
                                                        salesController.startingDate.value = startDate;
                                              },
                                              child: Icon(Icons.calendar_month,color: textColor,))
                                          ],
                                        ),  
                                        Obx(()=> salesController.startingDate.value ==null?Container(): heading2(text:formatDate(salesController.startingDate.value!) )),
                                         const SizedBox(height: 20,),
                                        Obx(()=> salesController.startingDate.value == null?Container():Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              mutedText(text: "Ending date"),
                                              GestureDetector(
                                                onTap: () async{
                                                  DateTime? endingDate = await showDatePicker(context: context, firstDate: salesController.startingDate.value!, initialDate: DateTime.now(), lastDate:DateTime.now());
                                                          salesController.endingDate.value = endingDate;
                                                },
                                                child: Icon(Icons.calendar_month,color: textColor,))
                                            ],
                                          ),
                                       ),
                                        Obx(()=>salesController.endingDate.value ==null?Container(): 
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            heading2(text:formatDate(salesController.endingDate.value!).toString() ),
                                           const SizedBox(height: 20,),            
                                         customButton(text: "Get sales report",onClick: (){
                                          salesController.selectedOption.value = "Date range";
                                          salesController.selectedFunction.value = 6;
                                          Get.back();
                                          setState(() {
                                            
                                          });
                                         }),
                                          ],
                                        )),                                                      
                                       
                                         const SizedBox(height: 40,),
                                      
                                        ],),
                                      ),)),
                                  ));
                                }else{
                                  salesController.selectedOption.value = item["title"].toString();
                                  salesController.selectedFunction.value = int.parse(item["function"].toString());
                                }
                              },
                              child: Obx(()=> Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                   child: Container(
                                    color:item["function"]==salesController.selectedFunction.value? primaryColor:backgroundColor,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                      child: heading2(text: item["title"],color: item["function"]==salesController.selectedFunction.value?Colors.white:textColor,fontSize: 12),
                                    ),),
                                                       ),
                                ),
                              ),
                            );
                           }).toList() 
                           ),
                         ),
                        SizedBox(height: 20,),
             
                      StaffSales()
            ],)));
          
        
  }
}