import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/models/product.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/text_form.dart';


class AddToCart extends StatefulWidget {
  const AddToCart({super.key});

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {  
ProductController  productController =  Get.find<ProductController>();
  bool addDiscount =  false;
  double onCartAmount = 1;
  @override
  Widget build(BuildContext context) {
    var product = productController.selectedProduct.value;
    return  SingleChildScrollView(
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
                  const SizedBox(height: 20,),
                  heading2(text: "Add to cart"),
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(width: 100,height: 100,child: CachedNetworkImage(imageUrl:product.image,fit: BoxFit.cover, ),)),
                SizedBox(width: 20,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     heading2(text: product.name),
                    mutedText(text: "Price: ${product.sellingPrice*onCartAmount} TZS"),
                    SizedBox(height: 10,),
                   Row(children: [
                      GestureDetector(
                        onTap: (){
                           setState(() {
                            if(onCartAmount >1){
                               onCartAmount--;
                            }
                          });
                        },
                        child: ClipOval(
                          child: Container(
                            color:mutedColor,
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: Icon(Icons.remove,color: Colors.black,),
                            )),
                        ),
                      ),
                      SizedBox(width: 10,),
                      heading2(text: "$onCartAmount",),
                      SizedBox(width: 10,),
                       GestureDetector(
                        onTap: (){
                          setState(() {
                            if(product.availableStock-onCartAmount>0){
                               onCartAmount++;
                            }
                          });
                        },
                         child: ClipOval(
                          child: Container(
                            color:mutedColor,
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: Icon(Icons.add,color: Colors.black,),
                            )),
                                             ),
                       ),
    
                    ],)
                  ],),
                ),
                 
                 
                       
                  
                  ],),
                  
                  const SizedBox(height: 20,),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      color: Colors.green.withOpacity(0.5),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(children: [
                            Checkbox(value: addDiscount, activeColor: Colors.green, onChanged: (value){
                              setState(() {
                                addDiscount = value!;
                              });
                            }),
                            paragraph(text: "Sell with discount")
                                        ],),
                      
                       AnimatedSize(
                        duration: Duration(milliseconds: 300),
                        child: addDiscount ? TextForm(hint: "Add discount",textInputType: TextInputType.number, onChanged: (value){
                         print(value);
                         String value1= value;
                         if(value == ""){
                           value1 = "0";
                         }
                          product.discount = double.tryParse(value1)!;
                        }):Container()),
                      
                          ],
                        ),
                      ),),
                  ),

                  const SizedBox(height: 20,),
    
                  customButton(text: "Add to cart",onClick: (){
                    product.onCartAmount = onCartAmount;
                    List<Product> newCartProducts = [];
                    newCartProducts = productController.onCartProducts.value;
                    newCartProducts.add(product);
                    productController.onCartProducts.value = [];
                    productController.totalCartAmount = productController.totalCartAmount + (product.onCartAmount*product.sellingPrice) - product.discount;
                    productController.onCartProducts.value = newCartProducts;
                    Get.back();
                  }),
                  
                  const SizedBox(height: 20,),
                  
                ],),
              ),
            )),
    );
      
    
  }
}