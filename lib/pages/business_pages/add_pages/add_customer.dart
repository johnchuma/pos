
// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/customer_controller.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/file_picker.dart';
import 'package:pos/utils/notifications.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/text_form.dart';
import 'package:pos/widgets/translatedText.dart';


class AddCustomer extends StatefulWidget {
 
   AddCustomer({super.key});
  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
   final _formKey = GlobalKey<FormState>();
   TextEditingController nameController = TextEditingController();
   TextEditingController phoneController = TextEditingController();
   TextEditingController emailController = TextEditingController();
   TextEditingController addressController = TextEditingController();
   TextEditingController descriptionController = TextEditingController();
   BusinessController businessController = Get.find<BusinessController>();
   AuthController authController = Get.find<AuthController>();
   DateTime? selectedDate = DateTime.now();
   Rx<bool> isSampleBusiness = Rx<bool>(false);
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
        title: heading2(text: translatedText("Add customer", "Ongeza mteja mpya")),
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
              mutedText(text: translatedText("Full name", "Jina kamili")),
              const SizedBox(height: 10,),
              TextForm(hint: translatedText("Enter customer name", "Andika jina la mteja"),textEditingController: nameController,lines: 1),
              mutedText(text: translatedText("Phone number", "Namba ya simu")),
              const SizedBox(height: 10,),
              TextForm(hint: translatedText("Enter customer phone number", "Andika namba ya simu ya biashara"),textEditingController: phoneController,lines: 1),
              // const SizedBox(height: 10,),
              mutedText(text: translatedText("Email address", "Email ya mteja")),
              const SizedBox(height: 10,),
              TextForm(hint: translatedText("Enter customer email", "Andika email ya mteja"),textEditingController: emailController,lines: 1),
              // const SizedBox(height: 10,),

              mutedText(text: translatedText("Customer address", "Mahali anapotokea")),
              const SizedBox(height: 10,),
              TextForm(hint: translatedText("Enter customer address", "Andika mahali anapotokea mteja"),textEditingController: addressController,lines: 1),
              // const SizedBox(height: 10,),
              mutedText(text: translatedText("Customer description", "Maelezo ya mteja")),
              const SizedBox(height: 10,),
              TextForm(hint:translatedText("Write customer description", "") ,textEditingController: descriptionController,lines: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  mutedText(text: translatedText("Customer image", "Picha ya mteja") ),
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
             
               customButton(text: translatedText("Add customer", "Ongeza mteja"), loading: loading, onClick: ()async{
                  setState(() {
                     loading = true;
                   });
                   var image = "";
                    if(path != ""){
                    image = await AuthController().getImageLink(imageFile);
                    }
                   var data = {
                   "name":nameController.text,
                   "phone":phoneController.text,
                   "email":emailController.text,
                   "description":descriptionController.text,
                   "address":addressController.text,
                   "image":image
                   };
                  CustomerController().addCustomer(data).then((value) {
                    Get.back();
                    successNotification("Customer is added successfully");
                  });
               }),      
               const SizedBox(height: 30,),
      
          ],),
        ),
      ),
    );
  }
}