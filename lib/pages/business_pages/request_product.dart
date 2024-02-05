
// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/product_request_controller.dart';
import 'package:pos/controllers/store_controller.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/file_picker.dart';
import 'package:pos/utils/notifications.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/pill.dart';
import 'package:pos/widgets/text_form.dart';
import 'package:pos/widgets/translatedText.dart';


class RequestProduct extends StatefulWidget {
 
   RequestProduct({super.key});
  @override
  State<RequestProduct> createState() => _RequestProductState();
}

class _RequestProductState extends State<RequestProduct> {
   final _formKey = GlobalKey<FormState>();
   TextEditingController requestController = TextEditingController();
   BusinessController businessController = Get.find<BusinessController>();
   DateTime? selectedDate = DateTime.now();
   var imageFile;
  var path = "";
  bool loading = false;
  List relatedTo = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: back(),
        elevation: 0.3,
        backgroundColor: backgroundColor,
        title: heading2(text: translatedText("Request product", "Ulizia bidhaa")),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
            children: [   
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
         
             
              mutedText(text: translatedText("What do you want to buy ?", "Unataka kununua nini ?")),
              const SizedBox(height: 10,),
              TextForm(hint:translatedText("Write your request here", "Andika ulizo lako lako hapa") ,textEditingController: requestController,lines: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  mutedText(text: translatedText("Image of product you are requesting ? (optional)", "Picha ya bidhaa unayouilizia") ),
                    path != "" ? GestureDetector(
                      onTap: (){
                        setState(() {
                          path = "";
                        });
                      },
                      child: Icon(Icons.cancel,size: 20,color: textColor.withOpacity(0.5),)):Container()
                ],
              ),
              const SizedBox(height: 10,),
               ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      color: mutedBackground,
                      height: 250,
                      width: double.infinity,
                      child:  Padding(
                        padding: const EdgeInsets.all(0),
                        child: path != ""
                        ? Image.file(imageFile,fit: BoxFit.cover)
                        :  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){
                                  pickImageFromGalley().then((value) {
                                    if(value != null){
                                      setState(() {
                                        imageFile = File.fromUri(Uri.file(value.path));
                                      path = value.path;
                                      });
                                      
                                    }
                                  });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Icon(Icons.camera,size: 30,color: textColor.withOpacity(0.4),),
                                  ),
                                  mutedText(text: "Gallery")
                                ],
                              ),
                            ),
                            SizedBox(width: 50,),
                            GestureDetector(
                              onTap: (){
                                  pickImageFromCamera().then((value) {
                                    if(value != null){
                                      setState(() {
                                        imageFile = File.fromUri(Uri.file(value.path));
                                      path = value.path;
                                      });
                                      
                                    }
                                  });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Icon(Icons.add_a_photo,size: 30,color: textColor.withOpacity(0.4),),
                                  ),
                                  mutedText(text: "Camera")
                                ],
                              ),
                            ),
                          ],
                        )
                    )),
                  ),
              ],)),
          
               const SizedBox(height: 40,),
             
               customButton(text: translatedText("Send request", "Tuma ulizo"), loading: loading, onClick: (){
               
                  if(_formKey.currentState!.validate()){
                     setState(() {
                     loading = true;
                   });
                  ProductRequestController().sendRequest(requestController.text, imageFile).then((value) {
                    Get.back();
                    successNotification("Request is sent successfully");
                  }); }
               }),      
               const SizedBox(height: 30,),
      
          ],),
        ),
      ),
    );
  }
}