
// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/Product_controller.dart';
import 'package:pos/controllers/product_variants_controller.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/delete_confirmation.dart';
import 'package:pos/utils/file_picker.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/menu_item.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/text_form.dart';
import 'package:pos/widgets/translatedText.dart';


class ProductsSettings extends StatefulWidget {
 
   ProductsSettings({super.key});
  @override
  State<ProductsSettings> createState() => _ProductsSettingsState();
}

class _ProductsSettingsState extends State<ProductsSettings> {
   final _formKey = GlobalKey<FormState>();

   TextEditingController nameController = TextEditingController();
   TextEditingController titleController = TextEditingController();
  

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
        title: heading2(text: translatedText("Products settings", "Mipangilio ya bidhaa")),
      ),
      body: GetX<ProductVariantsController>(
        init: ProductVariantsController(),
        builder: (find) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      heading2(text: "Products variants categories",fontSize:15),
                      GestureDetector(
                        onTap: (){
                           Get.bottomSheet(SingleChildScrollView(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
                          child: Container(
                            color: Colors.white,
                            child: Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                               
                                children: [
                                SizedBox(height: 10,),
                                ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Container(width: 80,height: 5,color: backgroundColor,)),
                                SizedBox(height: 20,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    paragraph(text: "category title eg:Color or Size"),
                                    SizedBox(height: 10,),
                                     TextForm(textEditingController: titleController,color: primaryColor.withOpacity(0.1)),
                                SizedBox(height: 20,),
                                customButton(text: "Add category",onClick: (){
                                  if(_formKey.currentState!.validate()){
                                     find.addCategory(titleController.text);
                                     Get.back();
                                  }
                                })
                                  ],
                                ),
                               
                              ],),
                            ),
                          ),),
                            ),
                          ));

                        },
                        child: const Icon(Icons.add))
                    ],
                  ),
                  SizedBox(height: 20,),
                  Column(children:find.productsVariantsCategories.map((item) =>  
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                              heading2(text: item.title,fontSize:15),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      find.selectedCategory.value =item;
                                   Get.bottomSheet(SingleChildScrollView(
                                    child: ClipRRect(
                                          borderRadius: const BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
                                      child: Container(
                                        color: Colors.white,
                                        child: Form(
                                        key: _formKey,
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                           
                                            children: [
                                            SizedBox(height: 10,),
                                            ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: Container(width: 80,height: 5,color: backgroundColor,)),
                                            SizedBox(height: 20,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                paragraph(text: "Write ${find.selectedCategory.value?.title} variant name "),
                                                SizedBox(height: 10,),
                                                 TextForm(textEditingController: nameController,color: primaryColor.withOpacity(0.1)),
                                            SizedBox(height: 20,),
                                            customButton(text: "Add variant",onClick: (){
                                              if(_formKey.currentState!.validate()){
                                                 find.addVariant(nameController.text);
                                                find.getVariants();
                                               Get.back();
                                              }
                                            })
                                              ],
                                            ),
                                           
                                          ],),
                                        ),
                                      ),),
                                    ),
                                  ));

                                    },
                                    child: heading2(text: "Add variant",color: primaryColor,fontSize:15)),
                                    SizedBox(width: 10,),
                                    GestureDetector(
                                      onTap: (){
                                        confirmDelete(context,onClick: (){
                                          find.deleteCategory(item.id);
                                        },onSuccess: (){});
                                      },
                                      child: Icon(Icons.cancel,color: textColor.withOpacity(0.3),))
                                ],
                              ),
                                              ],),
                              SizedBox(height: 20,),
                               AnimatedSize(
                                duration: Duration(milliseconds: 300),
                                 child: Wrap(children: item.variants.value.map((variant) => Padding(
                                   padding: const EdgeInsets.only(right: 10,bottom: 10),
                                   child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                     child: Container(
                                      color: primaryColor.withOpacity(0.1),
                                      child: Padding(
                                       padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                       child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           paragraph(text: variant.name),
                                           SizedBox(width: 10,),
                                           GestureDetector(
                                            onTap: (){
                                              confirmDelete(context,onClick: (){
                                                find.selectedCategory.value = item;
                                            find.deleteVariant(variant.id);
                                          },onSuccess: (){
                                            find.getVariants();
                                          });
                                            },
                                            child: Icon(Icons.cancel,size: 17,color: textColor.withOpacity(0.3),))
                                         ],
                                       ),
                                     ),),
                                   ),
                                 )).toList(),),
                               )

                            ],
                          ),
                        ),),
                    ),
                  )
                  ).toList())
          
              ],),
            ),
          );
        }
      ),
    );
  }
}