import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/controllers/product_sales_controller.dart';
import 'package:pos/pages/business_pages/add_pages/add_products_from_sample_store.dart';
import 'package:pos/pages/business_pages/add_pages/create_poster_request.dart';
import 'package:pos/pages/business_pages/add_product.dart';
import 'package:pos/pages/business_pages/edit_pages/edit_product.dart';
import 'package:pos/pages/business_pages/edit_pages/product_settings.dart';
import 'package:pos/pages/business_pages/product_sales_main.dart';
import 'package:pos/pages/business_pages/product_stock.dart';
import 'package:pos/pages/business_pages/view_pages/view_image.dart';
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
  // BusinessController find = Get.find<BusinessController>();
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(leading: back(),backgroundColor: backgroundColor,elevation: 0.3,
      title: Row(children: [
        
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading2(text: translatedText("Products", "Bidhaa")),
   

          ],
        )),
        GestureDetector(
          onTap: (){
            Get.to(()=>AddProduct());
          },
          child: Icon(Icons.add,size: 30,color: mutedColor,))
      ],) 
      ,),
      body: GetX<ProductController>(
                init: ProductController(),
                 builder: (find) {
                   return  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              
              children: [
                          const SizedBox(height: 20,),
    ClipRRect(
            borderRadius: BorderRadius.circular(15),
             child: Container(
              color: mutedBackground,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  cursorColor: primaryColor,
                  onChanged: (value){
                    find.searchKeyword.value = value;
                  },
                
                  decoration:  InputDecoration(
                  icon: Icon(Icons.search,color: mutedColor,),
                  border: InputBorder.none,
                 hintStyle: TextStyle(color: mutedColor),
                  hintText: translatedText("Search products here", "Tafuta bidhaa hapa")),
                style:  TextStyle(fontSize: 15,color: mutedColor)),
              )),
           ),
              
                   const SizedBox(height: 10),
                     find.products.isEmpty ?noData():  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Column(children:find.products.where((element) => element.name.toLowerCase().contains(find.searchKeyword.value.toLowerCase())).map((product) => Padding(
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
                                            //   ClipOval(
                                            //   child: Container(height: 50,width: 50,child: CachedNetworkImage(
                                            //     fit: BoxFit.cover,
                                            //     imageUrl:product.image),),
                                            // ),
                                            const SizedBox(width: 10,),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                heading2(text: product.name,fontSize:18),
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
                                                     
                                                           GestureDetector(
                                                            onTap: (){
                                                              Get.to(()=>ViewImage(product.image,));
                                                            },
                                                             child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(10),
                                                              child: Container(child: CachedNetworkImage(imageUrl: product.image,fit: BoxFit.cover,),height: 200,width: double.infinity,)),
                                                           )
                                                         , 
                                                          const SizedBox(height: 10,),            
                                                         
                                                         expandedItem(title:translatedText("Product stock", "Mzigo wa bidhaa"), iconData:Icons.add,onClick:  (){
                                                              find.selectedProduct.value = product;
                                                              Get.to(()=>const ProductStock());
                                                          }),
                                                           expandedItem(title:translatedText("Product sales", "Mauzo ya bidhaa"),iconData: Icons.bar_chart,onClick:  (){
                                                               ProductSaleController productSaleController = Get.find<ProductSaleController>();
                                                              productSaleController.selectedProduct.value = product;
                                                          
                                                              Get.to(()=>const ProductsSalesMain());
                                                          },elevation: 0),  

                                                        
                                                          expandedItem(title:translatedText("Product features", "Sifa za bidhaa"), iconData:Icons.remove_red_eye,onClick:  (){
                                                              find.selectedProduct.value = product;
                                                              Get.bottomSheet(bottomSheetTemplate(widget: Container(child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                heading2(text: "Product features"),
                                                                SizedBox(height: 20,),
                                                                product.properties.length  <1 ?noData(): Column(
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
                                                                        child: Expanded(child: paragraph(text: "${item["title"]}:  ${item["value"]}" )),
                                                                                        )),
                                                                      ),
                                                                    )).toList(),),
                                                              ],),)));
                                                          }),
                                                         
                                                          expandedItem(title:translatedText("Product settings", "Mipangilia ya bidhaa"), iconData:Icons.settings,onClick:  (){
                                                              find.selectedProduct.value = product;
                                                              Get.to(()=> ProductSettings());
                                                          }),
                                                          expandedItem(title:translatedText("Order product poster", "Agiza tangazo la bidhaa"), iconData:Icons.image,onClick:  (){
                                                              find.selectedProduct.value = product;
                                                              Get.to(()=> CreatePosterRequest());
                                                          }),
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
                           ) ).toList()),
                         ],
                       )
                     
            ],)
          );
        }
      ),);
  }
}