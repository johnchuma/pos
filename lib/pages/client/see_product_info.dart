import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/controllers/public_products_controller.dart';
import 'package:pos/models/product.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/appbar.dart';
import 'package:pos/widgets/avatar.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/chat_item.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/heading_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/pill.dart';

class ProductInfo extends StatefulWidget {
 ProductInfo({super.key});

  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
 PublicProductsController productController = Get.find<PublicProductsController>();
 @override
  void initState() {
    Product product =productController.selectedProduct!;
    BusinessController().getBusiness(product.businessId).then((value) {
 product.business.value = value;
 productController.selectedProductBusiness.value = value;
    });
    super.initState();
  }
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    Product product =productController.selectedProduct!;
  
    return  Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(leading: back(), elevation: 0, backgroundColor: backgroundColor,title: Obx(
          ()=> productController.selectedProductBusiness.value == null? Container():  Row(
              children: [
                avatar(image: productController.selectedProductBusiness.value?.image,size: 30),
                SizedBox(width: 10,),
                Expanded(child: heading2(text:"From ${productController.selectedProductBusiness.value?.name}",maxLines: 1)),
              ],
            ),
        ),),
      body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: mutedBackground,

              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                         height: 400,
                        width: double.infinity,
                        child: CachedNetworkImage(imageUrl: product.image,fit: BoxFit.cover,)),
                    ),
          SizedBox(height: 20,),

                    Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: heading2(text: product.name,maxLines: 1)),
              paragraph(text: "${product.sellingPrice} TZS")
            ],
          ),
          SizedBox(height: 5,),
          Row(children: [Icon(Icons.star,color: Colors.orange,),Icon(Icons.star,color: Colors.orange,),Icon(Icons.star,color: Colors.orange,),Icon(Icons.star,color: Colors.orange,),Icon(Icons.star,color: Colors.orange,), SizedBox(width: 10,),mutedText(text: "(best quality)")],),
         SizedBox(height: 10,),
          Wrap(children: product.properties.map((item) =>pill(text: "${item["title"]}: ${item["value"]}") ).toList(),),  
         
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
           ClipRRect(
            borderRadius: BorderRadius.circular(20),
             child: Container(
              color: mutedBackground,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                mutedText(text: "You can chat with the owner of this product for more informations and clarifications"),
                SizedBox(height: 10,),
                         customButton(text: "Chat with owner"),
              
              
                         ],),
              ),),
           ),
        SizedBox(height: 20,),
        ClipRRect(
            borderRadius: BorderRadius.circular(20),
             child: Container(
              color: mutedBackground,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heading2(text: "More products"),
                  SizedBox(height: 10,),
                    Container(
                      height: 250,
                      child: FutureBuilder(
                          future: productController.getSpecificBusinessPublicProducts(businessId: product.businessId),
                        builder: (context,snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return Center(child: CircularProgressIndicator());
                          }
                          List<Product> products = snapshot.requireData;
                          return GridView.count(crossAxisCount: 3,
                                    padding: const EdgeInsets.only(top: 5),
                                    mainAxisSpacing: 10,crossAxisSpacing: 10,
                                    children:products.map((item) => GestureDetector(
                                      onTap: (){
                                        setState(() {
                                           productController.selectedProduct = item;
                                        });
                                          _scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve:Curves.easeIn);
                         
                                      },
                                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(child: CachedNetworkImage(imageUrl: item.image,fit: BoxFit.cover,),)),
                                    )).toList() ,);
                        }
                      ),
                    )
              
              
                         ],),
              ),),
           ),
        SizedBox(height: 20,)
      
        ],),
      ),
    ),);
  }
}