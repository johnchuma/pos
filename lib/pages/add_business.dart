
// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
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


class AddBusiness extends StatefulWidget {
 
   AddBusiness({super.key});
  @override
  State<AddBusiness> createState() => _AddBusinessState();
}

class _AddBusinessState extends State<AddBusiness> {
   final _formKey = GlobalKey<FormState>();
   TextEditingController nameController = TextEditingController();
   TextEditingController phoneController = TextEditingController();
   TextEditingController descriptionController = TextEditingController();
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
        title: heading2(text: translatedText("Add business", "Ongeza biashara mpya")),
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
              mutedText(text: translatedText("Business name", "Jina la biashara")),
              const SizedBox(height: 10,),
              TextForm(hint: translatedText("Enter business name", "Andika jina la biashara"),textEditingController: nameController,lines: 1),
              mutedText(text: translatedText("Phone number", "Namba ya simu")),
              const SizedBox(height: 10,),
              TextForm(hint: translatedText("Enter business phone number", "Andika namba ya simu ya biashara"),textEditingController: phoneController,lines: 1),
                      mutedText(text: translatedText("What is the primary role of your business ?", "Aina ya biashara yako ?")),
              const SizedBox(height: 10,),
              
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: mutedBackground,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Obx(
                      ()=> Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                                   Row(children: [
                      Checkbox(value: businessController.role.value == "supplier",activeColor: Colors.green, onChanged: (value){
                        businessController.role.value = "supplier";
                      }),
                      paragraph(text: "Supplier")
                                  ],),
                      Row(children: [
                      Checkbox(value: businessController.role.value == "reseller",activeColor: Colors.green, onChanged: (value){
                        businessController.role.value = "reseller";
                      }),
                      paragraph(text: "Reseller")
                                  ],),
                      ],
                                  ),
                    ),
                  )),
              ),
              
             
              mutedText(text: translatedText("About business", "Kuhusu biashara")),
              const SizedBox(height: 10,),
              TextForm(hint:translatedText("What does this business sell ?", "Andika aina ya bidhaa unazoziuza") ,textEditingController: descriptionController,lines: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  mutedText(text: translatedText("Business background image", "Weka picha ya mbele ya biashara yako") ),
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
              const SizedBox(height: 10,),
                      mutedText(text: translatedText("Select type of your store", "Aina ya biashara yako ?")),
              const SizedBox(height: 10,),
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
                        child: Wrap(children: find.stores.map((item) =>Obx(()=>
                           pill(active: businessController.category.value == item.name,text: item.name,onClick: (){
                           businessController.category.value = item.name;
                           }),
                        ) ).toList(),),
                      ),
                    ),
                  );
                }
              ),),
               const SizedBox(height: 40,),
             
               customButton(text: translatedText("Add business", "Ongeza biashara"), loading: loading, onClick: (){
               
                  if(_formKey.currentState!.validate()){
                     setState(() {
                     loading = true;
                   });
                  businessController.createBusiness(nameController.text,phoneController.text, descriptionController.text, imageFile).then((value) {
                    Get.back();
                  }); }
               }),      
               const SizedBox(height: 30,),
      
          ],),
        ),
      ),
    );
  }
}