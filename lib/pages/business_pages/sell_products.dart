import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/controllers/sales_controller.dart';
import 'package:pos/pages/business_pages/add_to_cart.dart';
import 'package:pos/pages/business_pages/product_stock.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/money_format.dart';
import 'package:pos/utils/notifications.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/expanded_item.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/translatedText.dart';

class SaleProducts extends StatefulWidget {
  const SaleProducts({super.key});

  @override
  State<SaleProducts> createState() => _SaleProductsState();
}

class _SaleProductsState extends State<SaleProducts> {
  bool expanded = false;
  String productId = "";
  bool loading = false;
  @override
  void initState() {
    Get.put(ProductController());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    BusinessController businessController = Get.find<BusinessController>();
    ProductController productController = Get.find<ProductController>();
    return  Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: Obx(
        ()=> productController.searchKeyword.value.isEmpty || productController.onCartProducts.value.length == 0 ?Container(): FloatingActionButton(
          backgroundColor: Colors.transparent,
          onPressed:(){
          productController.searchKeyword.value = "";
        },child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [primaryColor,primaryColor2])),child: Padding(
            padding: const EdgeInsets.all(16),
            child: Badge(child: Icon(Icons.shopping_bag),label: Text(productController.onCartProducts.value.length.toString(),style: TextStyle(color: Colors.white,fontSize: 8),)),
          ),),
        ),),
      ),
      appBar: AppBar(leading: back(),backgroundColor: backgroundColor,elevation: 0.3,
      title: Row(children: [
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading2(text: translatedText("Sell products", "Uza bidhaa hapa")),
         

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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  cursorColor: primaryColor,
                  onChanged: (value){
                    productController.searchKeyword.value = value;
                  },
                
                  decoration:  InputDecoration(
                  icon: Icon(Icons.search,color: mutedColor,),
                  border: InputBorder.none,
                 hintStyle: TextStyle(color: mutedColor),
                  hintText: translatedText("Search products here", "Tafuta bidhaa hapa")),
                style:  TextStyle(fontSize: 13,color: mutedColor)),
              )),
           ),
             
             
                 GetX<ProductController>(
                init: ProductController(),
                 builder: (find) {
                   return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                     children: [

                     AnimatedSize(
                      duration: Duration(milliseconds: 300),
                       child: Container(child: find.onCartProducts.value.isEmpty ?Container():   find.searchKeyword.value.isNotEmpty ?Container():  Column(
                           children: [
                                    const SizedBox(height: 20,),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                               child: Container(
                               color: mutedBackground,
                                child: Padding(
                                 padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                 child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                heading2(text: translatedText("Selected products", "Bidhaa zilizochaguliwa"),color: Colors.white),
                                               
                   
                                              ],
                                            ),
                                            mutedText(text:translatedText("Here is the list of selected products", "Orodha ya bidhaa zilizochaguliwa"),color: Colors.white70),
                                            SizedBox(height: 20,),
                     
                                            AnimatedSize(
                                              duration: Duration(milliseconds: 300),
                                              child: Container(
                                                child: Column(children: find.onCartProducts.value.map((product) => 
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 10),
                                                  child: Container(
                                                      child: Row(
                                                       crossAxisAlignment: CrossAxisAlignment.center,
                                                       children: [
                                                       ClipRRect(
                                                         borderRadius: BorderRadius.circular(15),
                                                         child: Container(width: 80,height: 80,child: CachedNetworkImage(imageUrl:product.image,fit: BoxFit.cover, ),)),
                                                  
                                                   SizedBox(width: 20,),
                                                   Expanded(
                                                     child: Column(
                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                       children: [
                                                        heading2(text: product.name,fontSize: 14,color: Colors.white),
                                                       mutedText(text: "${translatedText("Price", "Bei")}: ${(moneyFormat(product.sellingPrice*product.onCartAmount))} TZS",color: Colors.white70),
                                                      if(product.discount> 0.0)
                                                       Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                         children: [
                                                           mutedText(text: "${translatedText("Discount", "Punguzo")}: ${product.discount} TZS",color: Colors.white70),
                                                       mutedText(text: "${translatedText("Final offer", "Bei ya mwisho")}: ${moneyFormat((product.sellingPrice*product.onCartAmount)-product.discount)} TZS",fontSize: 13,color: Colors.white),
                                                        
                                                         ],
                                                       ),


                                                      //  SizedBox(height: 20,),
                                                     
                                                     ],),
                                                   ),
                                                   GestureDetector(
                                                    onTap: (){
                                                      setState(() {
                                                      find.onCartProducts.value.removeWhere((element) => element.id == product.id);
                                                      double amount = 0.0;
                                                      for (var product in find.onCartProducts.value) {
                                                        amount = amount + ((product.onCartAmount*product.sellingPrice)-product.discount);
                                                      }
                                                      find.totalCartAmount.value = amount;
                                                      });
                                                    },
                                                    child: Icon(Icons.remove_circle,color:Colors.white70,))
                                                                           ])
                                                  ),
                                                )
                                                ).toList(),),
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                mutedText(text: translatedText("Total price", "Jumla ya gharama"),color: Colors.white70),
                                               heading2(text: "${moneyFormat(find.totalCartAmount.value)} TZS",color: Colors.white)
                                              ],
                                            ),
                                            SizedBox(height: 20,),
                     
                                            customButton(text:translatedText("Sell", "Uza bidhaa"), loading:loading, onClick: (){
                                              setState(() {
                                                loading = true;
                                              });
                                            
                                              SaleController().addSale().then((value) {
                                              find.onCartProducts.value = [];
                                              successNotification(translatedText("Sold successfully", "Bidhaa zimiuzwa kikamilifu"));
                                              setState(() {
                                                loading = false;
                                              });
                                              });
                                            })
                                          ],
                                        
                                          ),
                               ),),
                             ),
                           ],
                         )),
                     ),
                       SizedBox(height: 20,),
                       Column(children:find.productsWithStock.where((product)=>product.name.toLowerCase().contains(find.searchKeyword.value.toLowerCase())).map((product) => Padding(
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
                                          child: SizedBox(height: 50,width: 50,child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl:product.image),),
                                        ),
                                        const SizedBox(width: 10,),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                            heading2(text: product.name,fontSize: 14),
                                            mutedText(text: "${product.availableStock} in stock"),
                                          ],),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                          mutedText(text: "selling price",fontSize: 12,color: textColor.withOpacity(0.4)),
                                          heading2(text: "${moneyFormat(product.sellingPrice)}TZS",fontSize: 13),
                                        ],),
                                                    ],),
                                      ),
                                    ),
                                    
                                    
                                                 AnimatedSize(
                                                  duration: const Duration(milliseconds: 200),
                                                  child: productId == product.id ? Column(
                                                    children: [
                                                      const SizedBox(height: 10,),                      
                                                      expandedItem(title:"Add to shopping cart", iconData:Icons.add_shopping_cart,onClick:  (){
                                                          find.selectedProduct.value = product;
                                                          find.selectedProduct.value.availableStock.value --;
                                                         Get.bottomSheet(AddToCart());
                                                      }),
                                                                                                                                  
                                                    ],
                                                  ):Container(),
                                                )
                                  ],
                                ),
                                
                              ),),
                          ),
                       ) ).toList()),
                     ],
                   );
                 }
               )
        ],)
      ),);
  }
}