
// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/poster_request_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/controllers/product_variants_controller.dart';
import 'package:pos/models/poster_request.dart';
import 'package:pos/models/product.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/file_picker.dart';
import 'package:pos/utils/format_date.dart';
import 'package:pos/utils/notifications.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/menu_item.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/text_form.dart';
import 'package:pos/widgets/translatedText.dart';


class CreatePosterRequest extends StatefulWidget {
 
   CreatePosterRequest({super.key});
  @override
  State<CreatePosterRequest> createState() => _CreatePosterRequestState();
}

class _CreatePosterRequestState extends State<CreatePosterRequest> {
   final _formKey = GlobalKey<FormState>();


   TextEditingController requestController = TextEditingController();
   DateTime? selectedDate = DateTime.now();
   ProductController productController = Get.find<ProductController>();
   bool expanded = false;
   Rx<bool> useOtherImage = Rx<bool>(false);
   var imageFile;
  var path = "";
    var networkImage = "";
  bool loading = false;
  List relatedTo = [];
  List properties = [];
  @override
  void initState() {
     
    super.initState();
  }
  PosterRequestController posterRequestController = Get.put(PosterRequestController());

  @override
  Widget build(BuildContext context) {
    Product product =productController.selectedProduct.value;
    
  return  Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            leading: back(),
            elevation: 0.3,
            backgroundColor: backgroundColor,
            title: heading2(text: translatedText("Request a poster", "Agiza tangazo")),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        heading2(text: "You are requesting poster for "),
                        SizedBox(height: 10,),
                       ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                         child: Container(
                          height: 200,
                          width: double.infinity,
                          child: CachedNetworkImage(imageUrl: product.image,fit: BoxFit.cover,)),
                       ),
                       SizedBox(height: 10,),
                       paragraph(text: product.name),
                       SizedBox(height: 20,),
                         mutedText(text: translatedText("Poster request description", "Maelezo kuhusu tangazo")),
                  const SizedBox(height: 10,),
                   TextForm(hint: translatedText("Write description here", "Andika maelezo hapa"),
                   textEditingController: requestController,
                   lines: 5),
                  ],)),
                  
                 
                   const SizedBox(height: 20,),             
                   heading2(text: "Can we use other images"),
              Obx(
                ()=>Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  mutedText(text: "Allow using other product images"),
                  Switch(value: useOtherImage.value,activeColor: primaryColor, onChanged: (value){
                    useOtherImage.value = value;
                 
                  })
                ],),
              ),
                  
               
                  
                   customButton(text: translatedText("Send request", "Tuma ombi"), loading: loading, onClick: ()async{
                         setState(() {
                         loading = true;
                       });
                   List posterRequests   =  posterRequestController.posterrequests.map((item)=>formatMonthYear(item.createdAt.toDate())).where((element) => element == formatMonthYear(DateTime.now())).toList();
                      
                      if(posterRequests.length <2){
                       PosterRequestController().addPosterRequest(requestController.text,useOtherImage.value).then((value) {
                        Get.back();
                      });
                      }
                      else{
                        failureNotification("You have reached your request limit for this month");
                         setState(() {
                         loading = false ;
                       });
                      }
                      
                   }),      
                   const SizedBox(height: 30,),
          
              ]),
            ),
          ),
        );
     
  }
}