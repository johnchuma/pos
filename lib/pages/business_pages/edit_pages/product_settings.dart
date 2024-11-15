
// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/controllers/product_variants_controller.dart';
import 'package:pos/models/product.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/dynamic_links.dart';
import 'package:pos/utils/file_picker.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/menu_item.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/text_form.dart';
import 'package:pos/widgets/translatedText.dart';
import 'package:share_plus/share_plus.dart';

import '../../../utils/money_format.dart';


class ProductSettings extends StatefulWidget {
 
   ProductSettings({super.key});
  @override
  State<ProductSettings> createState() => _ProductSettingsState();
}

class _ProductSettingsState extends State<ProductSettings> {
   final _formKey = GlobalKey<FormState>();

   TextEditingController lowAmountController = TextEditingController();
   TextEditingController measurementController = TextEditingController();
   TextEditingController valueController = TextEditingController();
   TextEditingController descriptionController = TextEditingController();
   TextEditingController offerPriceController = TextEditingController();

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
    lowAmountController.text = product.lowAmount.toString();
    measurementController.text = product.measurement;
    offerPriceController.text = product.offerPrice.toString();
    super.initState();
  }
  Rx<bool> gettingLink = Rx<bool>(false);

  @override
  Widget build(BuildContext context) {
    Product product =productController.selectedProduct.value;
     DateTime now = DateTime.now();
          DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
  return  Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            leading: back(),
            elevation: 0.3,
            backgroundColor: backgroundColor,
            title: heading2(text: translatedText("Product settings", "Mipangilio ya bidhaa")),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10,),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         mutedText(text: translatedText("Product low amount", "Kiwango cha chini cha bidhaa")),
                  const SizedBox(height: 10,),
                   TextForm(hint: translatedText("Enter low amount", "Kiwango cha chini cha bidhaa",),
                   textInputType: TextInputType.number,
                   textEditingController: lowAmountController,
                   lines: 1),
                  SizedBox(height: 10,),
                    mutedText(text: translatedText("Product quantity measurement", "Kipimo cha bidhaa")),
                  const SizedBox(height: 10,),
                   TextForm(hint: translatedText("Eg: litres, kg, units, etc", "Mfano: litres, kg, units, etc",),
                  
                   textEditingController: measurementController,
                   lines: 1),
                    SizedBox(height: 10,),
                    mutedText(text: translatedText("Sell product for the offer price", "Uza kwa bei ya offer")),
                  const SizedBox(height: 10,),
                   TextForm(hint: translatedText("Enter an offer price","Weka bei ya offer"),
                  
                   textEditingController: offerPriceController,
                   lines: 1),
                  ],)),
                  SizedBox(height: 10,),
                  heading2(text: "Offer visibility"),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Expanded(child: mutedText(text: "It will only show for this week then you will have to switch it on again")),
                                                                        Switch(value: product.updatedAt.toDate().compareTo(startOfWeek) >=0 && product.updatedAt.toDate().compareTo(endOfWeek) ==-1? true:false ,activeColor: primaryColor, onChanged: (value){
                                                                         setState(() {
                                                                          if(value){
                                                                             product.updatedAt = Timestamp.now();
                                                                             productController.updateProduct(product.id, {"updatedAt":Timestamp.now()});
                                                                          }
                                                                          else{
                                                                            product.updatedAt = product.createdAt;
                                                                             productController.updateProduct(product.id, {"updatedAt":product.createdAt});

                                                                          }
                                                                          
                                                                          
                                                                         });
                                                                          
                                                                        })
                                                                      ],),
                                                                    
                  SizedBox(height: 10,),


                    heading2(text: "Product visibility"),
                                                                    Obx(
                                                                     ()=>Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Expanded(child: mutedText(text: "By switching on this product will be available to public users")),
                                                                        Switch(value: product.isPublic.value,activeColor: primaryColor, onChanged: (value){
                                                                          product.isPublic.value = value;
                                                                        productController.updateProduct(product.id, {"isPublic":value,"updatedAt":Timestamp.now()});
                                                                        })
                                                                      ],),
                                                                    ),
                    Obx(
                      ()=>product.isPublic.value? GestureDetector(
                        onTap: (){
                         gettingLink.value = true;
                        getDynamicLink(title: product.name,description: "Price: ${moneyFormat(product.sellingPrice)} TZS, click to chat with seller",image: product.image,productId: product.id ).then((value) {
                          Share.share(value);
                          gettingLink.value = false;
                        });
                        },
                        child: Row(
                          children: [
                           gettingLink.value ?Container(
                        height: 20,width: 20,
                        child: CircularProgressIndicator(color: textColor,)): Icon(Icons.share,color: mutedColor,size: 20,),SizedBox(width: 10,),
                            heading2(text: "Share product",color: Colors.green),
                          ],
                        )):Container(),
                    ),
              
                   const SizedBox(height: 30,),
                  
                   
                
                 
              


                  
                   customButton(text: translatedText("Save settings", "Hifadhi mpangilio"), loading: loading, onClick: ()async{
                         setState(() {
                         loading = true;
                       });
                           
                  var data = {
                      "lowAmount":double.parse(lowAmountController.text) ,
                      "measurement":measurementController.text.toLowerCase(),
                      "offerPrice":double.parse(offerPriceController.text),
                      "isCheap":double.parse(offerPriceController.text)>0?true:false 
                    };
                    
                      productController.updateProduct(product.id,data).then((value) {
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