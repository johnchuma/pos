
// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/product_request_controller.dart';
import 'package:pos/controllers/store_controller.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/file_picker.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/pill.dart';
import 'package:pos/widgets/text_form.dart';
import 'package:pos/widgets/translatedText.dart';


class ApproveRequest extends StatefulWidget {
 
   ApproveRequest({super.key});
  @override
  State<ApproveRequest> createState() => _ApproveRequestState();
}

class _ApproveRequestState extends State<ApproveRequest> {
   final _formKey = GlobalKey<FormState>();
   TextEditingController nameController = TextEditingController();
   TextEditingController phoneController = TextEditingController();
   TextEditingController descriptionController = TextEditingController();
    ProductRequestController productRequestController = Get.find<ProductRequestController>();
   DateTime? selectedDate = DateTime.now();
   var imageFile;
  var path = "";
  bool loading = false;
  String category = "";
  List relatedTo = [];
  @override
  void initState() {
    Get.put(ProductRequestController());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: back(),
        elevation: 0.3,
        backgroundColor: backgroundColor,
        title: heading2(text: translatedText("Approve request", "Ruhusu ombi")),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
            children: [   
             
              Container(child: 
              GetX<StoreController>(
                init: StoreController(),
                builder: (find) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: mutedBackground,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Wrap(children: find.stores.map((item) =>Padding(
                          padding: const EdgeInsets.only(right: 10,bottom: 10),
                          child: pill(active: category == item.name,text: item.name,onClick: (){
 setState(() {
                             category = item.name;                    
                              });
                          }),
                        ) ).toList(),),
                      ),
                    ),
                  );
                }
              ),),
               const SizedBox(height: 40,),
             
               customButton(text: translatedText("Approve request", "Ruhusu ombi"), loading: loading, onClick: (){
               
                 
                     setState(() {
                     loading = true;
                   });
                   productRequestController.updateRequest(data:{"category":category}).then((value){
                    Get.back();
                   });
                  
               }),      
               const SizedBox(height: 30,),
      
          ],),
        ),
      ),
    );
  }
}