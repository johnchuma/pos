
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
import 'package:pos/widgets/translatedText.dart';


class ManagePassword extends StatefulWidget {

   ManagePassword({super.key});
  @override
  State<ManagePassword> createState() => _ManagePasswordState();
}

class _ManagePasswordState extends State<ManagePassword> {
   final _formKey = GlobalKey<FormState>();
   TextEditingController passwordController = TextEditingController();
  AuthController authController = Get.find<AuthController>();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:authController.findMyInfo() ,
      builder: (context,snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Scaffold(
            backgroundColor: backgroundColor,
            body: Center(child: CircularProgressIndicator(color: textColor),),);
        }
        Client client = snapshot.requireData;
        passwordController.text = client.password;
      

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            leading: back(),
            elevation: 0.3,
            backgroundColor: backgroundColor,
            title: heading2(text:translatedText("Account password", "Neno lako la siri")),
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
                         mutedText(text: translatedText("Account password", "Neno lako la siri") ),
                  const SizedBox(height: 10,),
                   TextForm(hint: translatedText("Create password", "weka neno lako la siri"),
                   textEditingController: passwordController,
                   isPassword: true,
                   lines: 1),
                 
                  
                 
                  ],)),
                   const SizedBox(height: 10,),
                  if(client.password != "") ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      color: Colors.orange.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            heading2(text: translatedText("You have set password, you won't be able to use the app without password confirmation now", "Umefanikiwa kutengeneza neno la siri, sasa haitawezekana kutumia mfumo bila neno la siri"),fontSize:15),
                            GestureDetector(
                              onTap: (){
                                  var data = {"password":""};
                                   setState(() {
                          authController.updateClientInfo(data).then((value) {
                           
                             authController.loading.value = false;
                     
                            });
                              });},
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: heading2(text: translatedText("Remove password", "Futa neno la siri"),color: Colors.red[900]),
                              ),
                            ),
                        
                          ],
                        ),
                      ),),
                  ),
                   const SizedBox(height: 20,),
                  
                   Obx(
                     ()=> customButton(text: translatedText("Save password", "Hifadhi neno la siri"), loading: authController.loading.value, onClick: (){
                     
                        if(_formKey.currentState!.validate()){
                           authController.loading.value = true;
                        var data = {"password":passwordController.text};
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