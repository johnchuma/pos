import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/customer_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/controllers/customer_controller.dart';
import 'package:pos/controllers/worker_controller.dart';
import 'package:pos/pages/add_worker.dart';
import 'package:pos/pages/business_pages/add_pages/add_customer.dart';

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
import 'package:pos/widgets/no_data.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/translatedText.dart';
import 'package:timeago/timeago.dart' as timeago;

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  bool expanded = false;
  String customerId = "";
  @override
  void initState() {
    // Get.put(ProductController());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    BusinessController find = Get.find<BusinessController>();
    return  Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(leading: back(),backgroundColor: backgroundColor,elevation: 0.3,
      title: Row(children: [
        
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading2(text:translatedText("Customers", "Madirisha ya mauzo")),
          

          ],
        )),
        GestureDetector(
          onTap: (){
            Get.to(()=>AddCustomer());
          },
          child: Icon(Icons.add,size: 30,color: textColor,))
      ],) 
      ,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
               const SizedBox(height: 20),
                 GetX<CustomerController>(
                init: CustomerController(),
                 builder: (find) {
                   return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                           ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        color: mutedBackground,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            cursorColor: primaryColor,
                            onChanged: (value){
                              find.searchKeyword.value = value;
                            },
                          
                            decoration:  InputDecoration(
                            icon: Icon(Icons.search,color: mutedColor,),
                            border: InputBorder.none,
                          hintStyle: TextStyle(color: mutedColor),
                            hintText: translatedText("Search products here", "Tafuta bidhaa hapa")),
                          style:  TextStyle(fontSize:15,color: mutedColor)),
                        )),
                       ),
                       SizedBox(height: 10),
                       find.customers.isEmpty ?noData(): Column(children:find.customers.where((item) => item.name.toLowerCase().contains(find.searchKeyword.value.toLowerCase())).map((customer) => Padding(
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
                                        if(customerId == customer.id){
                                           customerId = "";
                                          }else{
                                           customerId = customer.id;
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
                                            heading2(text: customer.name,fontSize:18),
                                            mutedText(text:timeago.format(customer.createdAt.toDate()) ),
                                           
                                          ],),
                                        ),
                                                    ],),
                                      ),
                                    ),
                                     AnimatedSize(
                                                  duration: const Duration(milliseconds: 200),
                                                  child:customerId == customer.id ? Column(
                                                    children: [
                                                      const SizedBox(height: 10,),                      
                                                      expandedItem(title:translatedText("Edit customer", "Boresha taarifa za dirisha"), iconData:Icons.edit, onClick:  (){   
                                                       find.selectedCustomer.value = customer;
                                                      //  Get.to(()=>UpdateCustomer());
                                                      
                                                      }),
                                                       expandedItem(title:translatedText("Delete customer", "Futa dirisha"), iconData:Icons.delete, onClick:  (){
                                                        confirmDelete(context,onClick:  (){
                                                            find.deleteCustomer(customer.id);
                                                        },onSuccess: (){
                                                          successNotification(translatedText("Deleted successfully", "Umefanikiwa kufuta") );
                                                        });
                                                      },elevation: 0), 
                                                     
                                                    ],
                                                  ):Container(),
                                                )
                                             
                                  ],
                                ),
                                
                              ),),
                          ),
                       ) ).toList()),
                     ],
                   );
                 }
               )
        ],)
      ),);
  }
}