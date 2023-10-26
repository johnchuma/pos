import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/controllers/product_sales_controller.dart';
import 'package:pos/pages/business_pages/add_product.dart';
import 'package:pos/pages/business_pages/edit_pages/edit_product.dart';
import 'package:pos/pages/business_pages/product_sales_main.dart';
import 'package:pos/pages/business_pages/product_stock.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/delete_confirmation.dart';
import 'package:pos/utils/format_date.dart';
import 'package:pos/utils/notifications.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/bottomsheet_template.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/expanded_item.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/heading_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/no_data.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/translatedText.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  bool expanded = false;
  String productId = "";
  @override
  void initState() {
    Get.put(ProductController());
    Get.put(ProductSaleController());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ProductSaleController productSaleController = Get.find<ProductSaleController>();
    BusinessController find = Get.find<BusinessController>();
    return  Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(leading: back(),backgroundColor: backgroundColor,elevation: 0.3,
      title: Row(children: [
        
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading2(text: translatedText("Products", "Bidhaa")),
   

          ],
        ))
      ],) 
      ,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          
          children: [
                      const SizedBox(height: 20,),

           ClipRRect(
                borderRadius: BorderRadius.circular(15),
                 child: Container(
                  color: mutedBackground,
                  child: Padding(
                   padding: const EdgeInsets.all(20),
                   child: Column
                   (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    headingText(text:translatedText("Add new products", "Weka bidhaa mpya") ,),
                    const SizedBox(height: 5,),
                    
                    mutedText(text: translatedText("Add, edit and delete products here", "Ongeza, futa, au badilisha taarifa za bidhaa")),
                    const SizedBox(height: 20,),
                    customButton(text:translatedText("Add product", "Ongeza bidhaa") ,onClick: (){
                      Get.to(()=>AddProduct());
                    })
                    
                   ],),
                 ),),
               ),
               const SizedBox(height: 20,),
               heading2(text: translatedText("Products list", "Orodha ya bidhaa zote")),
               const SizedBox(height: 20),
                 GetX<ProductController>(
                init: ProductController(),
                 builder: (find) {
                   return find.products.isEmpty ?noData():  Column(children:find.products.map((product) => Padding(
                     padding: const EdgeInsets.only(bottom: 15),
                     child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          color: mutedBackground,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                  setState(() {
                                      if(productId == product.id){
                                        productId = "";
                                      }else{
                                      productId = product.id;
                                      }
                                    });
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Row(children:  [
                                      ClipOval(
                                      child: Container(height: 50,width: 50,child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl:product.image),),
                                    ),
                                    const SizedBox(width: 10,),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                        heading2(text: product.name,fontSize: 14),
                                        mutedText(text: "${translatedText("Created at", "Imewekwa")} ${formatDate(product.createdAt.toDate())}"),
                                      ],),
                                    ),
                                                ],),
                                  ),
                                ),
                                
                                             AnimatedSize(
                                              duration: const Duration(milliseconds: 200),
                                              child: productId == product.id ? Column(
                                                children: [
                                                  const SizedBox(height: 10,),            
                                                   expandedItem(title:translatedText("Change visibility", "Bidilisha uonekanaji"), iconData:Icons.remove_red_eye,onClick:  (){
                                                            Get.bottomSheet(SingleChildScrollView(
                                                              child: ClipRRect(
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
                                                                    heading2(text: "Change visibility"),
                                                                    Obx(
                                                                     ()=>Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        mutedText(text: "Make product public"),
                                                                        Switch(value: product.isPublic.value,activeColor: primaryColor, onChanged: (value){
                                                                          product.isPublic.value = value;
                    
                                                                          find.updateProduct(product.id, {"isPublic":value});
                                                                        })
                                                                      ],),
                                                                    ),
                                                                                                                    SizedBox(height: 20,),
                                                                  ],),
                                                                ),),
                                                              ),
                                                            ));
                                                  }),     
                                                   expandedItem(title:translatedText("Product features", "Sifa za bidhaa"), iconData:Icons.list,onClick:  (){
                                                      find.selectedProduct.value = product;
                                                      Get.bottomSheet(bottomSheetTemplate(widget: Container(child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                        heading2(text: "Product features"),
                                                        SizedBox(height: 20,),
                                                        Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children:product.properties.map((item) =>Padding(
                                                              padding: const EdgeInsets.only(bottom: 10),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(15),
                                                                child: Container(
                                                                color: backgroundColor,
                                                                width: double.infinity,
                                                                child: Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                                                                child: paragraph(text: "${item["title"]}:  ${item["value"]}" ),
                                                                                )),
                                                              ),
                                                            )).toList(),),
                                                      ],),)));
                                                  }),     
                                                  expandedItem(title:translatedText("Product stock", "Mzigo wa bidhaa"), iconData:Icons.add_box,onClick:  (){
                                                      find.selectedProduct.value = product;
                                                      Get.to(()=>const ProductStock());
                                                  }),
                                                   expandedItem(title:translatedText("Product sales", "Mauzo ya bidhaa"),iconData: Icons.report,onClick:  (){
                                                      productSaleController.selectedProduct.value = product;
                                                      Get.to(()=>const ProductsSalesMain());
                                                  },elevation: 0),  

                                                  expandedItem(title:translatedText("Edit product details", "Badili taarifa"), iconData:Icons.edit,onClick:  (){
                                                      find.selectedProduct.value = product;
                                                      Get.to(()=> EditProduct());
                                                  }),
                                                   expandedItem(title:translatedText("Delete product","Futa bidhaa"),iconData: Icons.cancel,onClick:  (){
                                                      confirmDelete(context,onClick: (){
                                                        find.deleteProduct(product.id);
                                                      },onSuccess: (){
                                                        successNotification(translatedText("Product is deleted successfully", "Umefanikiwa kufuta"));
                                                      });
                                                  },elevation: 0),                                                                             
                                                ],
                                              ):Container(),
                                            )
                              ],
                            ),
                            
                          ),),
                      ),
                   ) ).toList());
                 }
               )
        ],)
      ),);
  }
}