
// ignore_for_file: prefer_typing_uninitialized_variables


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/Product_controller.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/worker_controller.dart';
import 'package:pos/models/client.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/file_picker.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/text_form.dart';


class UpdateProfileDetails extends StatefulWidget {

   UpdateProfileDetails({super.key});
  @override
  State<UpdateProfileDetails> createState() => _UpdateProfileDetailsState();
}

class _UpdateProfileDetailsState extends State<UpdateProfileDetails> {
   final _formKey = GlobalKey<FormState>();
   TextEditingController nameController = TextEditingController();
   TextEditingController phoneController = TextEditingController();
  AuthController authController = Get.find<AuthController>();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:authController.findMyInfo() ,
      builder: (context,snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Scaffold(body: Center(child: CircularProgressIndicator(color: textColor),),);
        }
        Client client = snapshot.requireData;
        nameController.text = client.name;
        phoneController.text = client.phone;

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            leading: back(),
            elevation: 0.3,
            backgroundColor: backgroundColor,
            title: heading2(text: "Update profile details"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              
                  const SizedBox(height: 20,),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         mutedText(text: "Username"),
                  const SizedBox(height: 10,),
                   TextForm(hint: "Write your user name",
                   textEditingController: nameController,
                   lines: 1),
                  mutedText(text: "Phone number"),
                  const SizedBox(height: 10,),
                   TextForm(hint: "Enter your phone number",
                   textEditingController: phoneController,
                   textInputType: TextInputType.phone,
                   lines: 1),
                  
                  
                 
                  ],)),
                   const SizedBox(height: 20,),
                
                  
                   Obx(
                     ()=> customButton(text: "Update details", loading: authController.loading.value, onClick: (){
                     
                        if(_formKey.currentState!.validate()){
                           authController.loading.value = true;
                        var data = {"name:":nameController.text,"phone":phoneController.text};
                        authController.updateClientInfo(data).then((value) {
                          setState(() {
                           authController.loading.value = false;
                   
                          });
                        });
                        }
                     }),
                   ),      
                   const SizedBox(height: 30,),
          
              ],),
            ),
          ),
        );
      }
    );
  }
}