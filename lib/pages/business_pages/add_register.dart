
// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/Product_controller.dart';
import 'package:pos/controllers/register_controller.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/file_picker.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/text_form.dart';
import 'package:pos/widgets/translatedText.dart';


class AddRegister extends StatefulWidget {
 
   AddRegister({super.key});
  @override
  State<AddRegister> createState() => _AddRegisterState();
}

class _AddRegisterState extends State<AddRegister> {
   final _formKey = GlobalKey<FormState>();

   TextEditingController nameController = TextEditingController();
   TextEditingController descriptionController = TextEditingController();

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
        title: heading2(text:translatedText("Add register", "Ongeza dirisha")),
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
             
               customButton(text: translatedText("Add register", "Ongeza dirisha"), loading: loading, onClick: (){
               
                  if(_formKey.currentState!.validate()){
                     setState(() {
                     loading = true;
                   });
                  RegisterController().addRegister(nameController.text,descriptionController.text).then((value) {
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