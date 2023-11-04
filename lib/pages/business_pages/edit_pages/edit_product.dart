
// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/controllers/product_variants_controller.dart';
import 'package:pos/models/product.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/file_picker.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/menu_item.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/text_form.dart';
import 'package:pos/widgets/translatedText.dart';


class EditProduct extends StatefulWidget {
 
   EditProduct({super.key});
  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
   final _formKey = GlobalKey<FormState>();

   TextEditingController nameController = TextEditingController();
   TextEditingController titleController = TextEditingController();
   TextEditingController valueController = TextEditingController();
   TextEditingController descriptionController = TextEditingController();
   DateTime? selectedDate = DateTime.now();
   ProductController productController = Get.find<ProductController>();
   bool expanded = false;
   var imageFile;
  var path = "";
    var networkImage = "";
  bool loading = false;
  List relatedTo = [];
  List properties = [];
  @override
  void initState() {
    Product product =productController.selectedProduct.value;
    networkImage = product.image;
    nameController.text = product.name;
    properties = product.properties;

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Product product =productController.selectedProduct.value;
    
  return  Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            leading: back(),
            elevation: 0.3,
            backgroundColor: backgroundColor,
            title: heading2(text: translatedText("Edit product", "Ongeza bidhaa")),
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
                         mutedText(text: translatedText("Product name", "Jina la bidhaa")),
                  const SizedBox(height: 10,),
                   TextForm(hint: translatedText("Write product name", "Andika jina la bidhaa"),
                   textEditingController: nameController,
                   lines: 1),
                  ],)),
                  
                 
                   const SizedBox(height: 20,),             
                     Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  paragraph(text: translatedText("Product image", "Weka picha ya bidhaa") ),
                    path != "" || networkImage != "" ? GestureDetector(
                      onTap: (){
                        setState(() {
                          path = "";
                          networkImage = "";
                        });
                      },
                      child: Icon(Icons.cancel,size: 20,color: textColor.withOpacity(0.5),)):Container()
                    ],
                  ),
                  SizedBox(height: 10,),
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
                        : networkImage != ""? CachedNetworkImage(imageUrl: networkImage,fit: BoxFit.cover,):  Row(
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
                   const SizedBox(height: 30,),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    heading2(text: "Add product properties"), GestureDetector(
                      onTap: (){
                        Get.bottomSheet(SingleChildScrollView(child: 
                        ClipRRect(
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
                        child: Container(
                          color: mutedBackground,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(width: 80,height: 5,color: backgroundColor,))],),
                                SizedBox(height: 20,),
                                heading2(text: "Product properties"),
                                SizedBox(height: 20,),
                                paragraph(text: "Title"),
                                TextForm(hint: "Properties title",textEditingController: titleController,color: backgroundColor),
                                paragraph(text: "Value"),
                                TextForm(hint: "Properties  value/info",textEditingController: valueController,color:backgroundColor ),
                                SizedBox(height: 20,),
                                customButton(text: "Add properties",onClick: (){
                                         Get.back();
                                         setState(() {
                                         properties.add({"title":titleController.text,"value":valueController.text});
                                           
                                         });
                              
                                }),
                                SizedBox(height: 20,),
                                                    
                                                    
                              ],),
                            ),
                          ),
                        )));
                      },
                      child: Icon(Icons.add_circle,color: mutedColor,))
                   ],),
                   SizedBox(height: 15,),
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:properties.map((item) =>Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                        color: mutedBackground,
                        width: double.infinity,
                        child: Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                         child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Expanded(child: paragraph(text: "${item["title"]}:  ${item["value"]}" )),
                             GestureDetector(
                              onTap: (){
                                setState(() {
                                properties.remove(item);
                                });
                              },
                              child: Icon(Icons.delete,color: mutedColor,))
                           ],
                         ),
                                         )),
                      ),
                    )).toList(),),
              
                   const SizedBox(height: 30,),


                  
                   customButton(text: translatedText("Edit product", "Ongeza bidhaa"), loading: loading, onClick: ()async{
                         setState(() {
                         loading = true;
                       });
                        var image = "";
                          if(path != ""){
                              image  = await  AuthController().getImageLink(imageFile);
                          }       
                  var data = {
                      "name":nameController.text,
                      "properties":properties,
                      "image":path == ""?product.image:image
                    };
                      ProductController().updateProduct(product.id,data).then((value) {
                        Get.back();
                      });
                   }),      
                   const SizedBox(height: 30,),
          
              ],),
            ),
          ),
        );
     
  }
}