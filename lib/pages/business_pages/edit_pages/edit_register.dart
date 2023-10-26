
// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/Product_controller.dart';
import 'package:pos/controllers/register_controller.dart';
import 'package:pos/models/register.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/file_picker.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/text_form.dart';
import 'package:pos/widgets/translatedText.dart';


class UpdateRegister extends StatefulWidget {
 
   UpdateRegister({super.key});
  @override
  State<UpdateRegister> createState() => _UpdateRegisterState();
}

class _UpdateRegisterState extends State<UpdateRegister> {
   final _formKey = GlobalKey<FormState>();

   TextEditingController nameController = TextEditingController();
   TextEditingController descriptionController = TextEditingController();
    RegisterController registerController = Get.find<RegisterController>();
  var path = "";
  bool loading = false;
  List relatedTo = [];
    @override
  void initState() {
     Register register = registerController.selectedRegister!;
     nameController.text = register.title;
     descriptionController.text = register.description;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
     Register register = registerController.selectedRegister!;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: back(),
        elevation: 0.3,
        backgroundColor: backgroundColor,
        title: heading2(text:translatedText("Update register", "Badili taarifa za dirisha")),
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
                     mutedText(text: translatedText("Register title", "Jina la dirisha")),
              const SizedBox(height: 10,),
               TextForm(hint: translatedText("Write register title", "Andika jina la dirisha"),
               textEditingController: nameController,
               lines: 1),
             
                mutedText(text: translatedText("Register description", "Maelezo kuhusu dirisha")),
              const SizedBox(height: 10,),
               TextForm(hint: translatedText("Write register descriptions", "Andika maelezo ya dirisha"),
               
               textEditingController: descriptionController,
               lines: 4),
             
             
              ],)),
               const SizedBox(height: 20,),
             
               customButton(text: translatedText("Update register", "Ongeza dirisha"), loading: loading, onClick: (){
               
                  if(_formKey.currentState!.validate()){
                     setState(() {
                     loading = true;
                   });
                   var data = {
                    "title":nameController.text,
                    "description:":descriptionController.text
                   };
                  RegisterController().updateRegister(register.id,data).then((value) {
                    Get.back();
                  });}
               }),      
               const SizedBox(height: 30,),
          ],),
        ),
      ),
    );
  }
}