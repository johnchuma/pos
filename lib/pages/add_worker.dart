
// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/Product_controller.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/worker_controller.dart';
import 'package:pos/models/client.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/file_picker.dart';
import 'package:pos/utils/notifications.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/text_form.dart';
import 'package:pos/widgets/translatedText.dart';


class AddWorker extends StatefulWidget {
 
   AddWorker({super.key});
  @override
  State<AddWorker> createState() => _AddWorkerState();
}

class _AddWorkerState extends State<AddWorker> {
   final _formKey = GlobalKey<FormState>();
   TextEditingController emailController = TextEditingController();
   AuthController authController = Get.find<AuthController>();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: back(),
        elevation: 0.3,
        backgroundColor: backgroundColor,
        title: heading2(text:translatedText("Add worker", "Ongeza mfanyakazi")),
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
                     mutedText(text: translatedText("Worker's email", "Email ya mfanyakazi")),
              const SizedBox(height: 10,),
               TextForm(hint: translatedText("Write worker's email", "Andika email ya mfanyakazi"),
               textEditingController: emailController,
               lines: 1),
             
              
             
              ],)),
               const SizedBox(height: 20,),
            
              
               customButton(text: translatedText("Add worker", "Ongeza mfanyakazi"), loading: loading, onClick: (){
               
                  if(_formKey.currentState!.validate()){
                     setState(() {
                     loading = true;
                   });
                  authController.findUserByEmail(emailController.text).then((value) {
                   
                    if(value == null){
                      failureNotification(translatedText("User is not registered", "Email hii bado haijasajiliwa"));
                      setState(() {
                        loading = false;
                      });
                    }
                    else{
                      StaffsController().addWorker(emailController.text).then((value) {
                    Get.back();
                  });
                    }
                  });
                  
                  
                  }
               }),      
               const SizedBox(height: 30,),
      
          ],),
        ),
      ),
    );
  }
}