import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/retailer_order_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/controllers/sales_controller.dart';
import 'package:pos/models/product.dart';
import 'package:pos/pages/business_pages/add_to_cart.dart';
import 'package:pos/pages/business_pages/product_stock.dart';
import 'package:pos/pages/business_pages/select_supplier.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/expanded_item.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';

class PickProductsToOrder extends StatefulWidget {
  const PickProductsToOrder({super.key});

  @override
  State<PickProductsToOrder> createState() => _PickProductsToOrderState();
}

class _PickProductsToOrderState extends State<PickProductsToOrder> {
  bool expanded = false;
  String productId = "";
  double orderAmount = 1; 
  bool loading = false;
  @override
  void initState() {
    Get.put(ProductController());
    Get.put(RetailerOrderController());

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    BusinessController businessController = Get.find<BusinessController>();
    RetailerOrderController retailerOrderController = Get.find<RetailerOrderController>();

    return  Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: Obx(
        ()=> retailerOrderController.searchKeyword.value.isEmpty || retailerOrderController.onCartSupplierOrders.value.length == 0 ?Container(): FloatingActionButton(
          backgroundColor: Colors.transparent,
          onPressed:(){
          retailerOrderController.searchKeyword.value = "";
        },child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [primaryColor,primaryColor2])),child: Padding(
            padding: const EdgeInsets.all(16),
            child: Badge(child: Icon(Icons.shopping_bag),label: Text(retailerOrderController.onCartSupplierOrders.value.length.toString(),style: TextStyle(color: Colors.white,fontSize: 8),)),
          ),),
        ),),
      ),
      appBar: AppBar(leading: back(),backgroundColor: backgroundColor,elevation: 0.3,
      title: Row(children: [
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading2(text: "Pick products to order"),
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
              color:mutedBackground,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  cursorColor: primaryColor,
                  
                  onChanged: (value){
                    retailerOrderController.searchKeyword.value =value;
                  },
                  decoration:  InputDecoration(
                  icon: Icon(Icons.search,color: mutedColor),
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: mutedColor,fontSize: 15),
                  hintText: "Search for products"),
                style:  TextStyle(fontSize: 15,color: textColor)),
              )),
           ),
             
             
                 GetX<RetailerOrderController>(
                init: RetailerOrderController(),
                 builder: (find) {
                   return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                     children: [

                     AnimatedSize(
                      duration: Duration(milliseconds: 300),
                       child: Container(child: find.onCartSupplierOrders.value.isEmpty ?Container(): find.searchKeyword.value.isNotEmpty?Container(): Column(
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
                                                heading2(text: "Order products list",color: Colors.white),
                                              ],
                                            ),
                                            mutedText(text: "here are the products in this order",color: Colors.white70),
                                            SizedBox(height: 20,),
                                                  
                                            AnimatedSize(
                                              duration: Duration(milliseconds: 300),
                                              child: Container(
                                                child: Column(children: find.onCartSupplierOrders.value.map((product) => 
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 10),
                                                  child: Container(
                                                      child: Row(
                                                       crossAxisAlignment: CrossAxisAlignment.center,
                                                       children: [
                                                       ClipRRect(
                                                         borderRadius: BorderRadius.circular(15),
                                                         child: Container(width: 80,height: 80,child: CachedNetworkImage(imageUrl:product.image,fit: BoxFit.cover, ),)),
                                                  
                                                   const SizedBox(width: 20,),
                                                   Expanded(
                                                     child: Column(
                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                       children: [
                                                        heading2(text: product.name,fontSize:18,color: Colors.white),
                                                       mutedText(text: "Amount: ${product.onCartAmount}",color: Colors.white70),
                                                       SizedBox(height: 20,),
                                                     
                                                     ],),
                                                   ),
                                                   GestureDetector(
                                                    onTap: (){
                                                      setState(() {
                                                      find.onCartSupplierOrders.value.removeWhere((element) => element.id == product.id);
                                                      double amount = 0.0;
                                                      for (var product in find.onCartSupplierOrders.value) {
                                                        amount = amount + (product.onCartAmount*product.sellingPrice);
                                                      }
                                                      find.totalCartAmount.value = amount;
                                                      });
                                                    },
                                                    child: Icon(Icons.remove_circle,color:Colors.white54,))
                                                                           ])
                                                  ),
                                                )
                                                ).toList(),),
                                              ),
                                            ),
                                           
                                           
                                            SizedBox(height: 20,),
                                           
                                            customButton(text: "Continue",textColor: Colors.white, loading:loading, onClick: (){
                                             Get.bottomSheet(SelectOrderSupplier());
                                                                                   
                                            })
                                          ],
                                        
                                          ),
                               ),),
                             ),
                           ],
                         )),
                     ),
                       SizedBox(height: 20,),
                       GetX<ProductController>(
                        init: ProductController(),
                         builder: (find2) {
                           return Column(children:find2.productsWithStock.where((element) => element.name.toLowerCase().contains(find.searchKeyword.value.toLowerCase())).map((product) => Padding(
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
                                                heading2(text: product.name,fontSize:18),
                                                mutedText(text: "${product.availableStock} in stock"),
                                              ],),
                                            ),
                                            Icon(Icons.add_rounded,color: mutedColor.withOpacity(0.5),)
                                                        ],),
                                          ),
                                        ),
                                        
                                        AnimatedSize(
                                              duration: const Duration(milliseconds: 200),
                                              child: productId == product.id ? Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 20,),                      
                                                  heading2(text: "Product order amount",fontSize: 14,color: textColor),
                                                  const SizedBox(height: 20,),                      

                                                           Row(children: [
                      GestureDetector(
                        onTap: (){
                           setState(() {
                            if(orderAmount >1){
                              orderAmount--;
                            }
                          });
                        },
                        child: ClipOval(
                          child: Container(
                            color: mutedColor,
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: Icon(Icons.remove,color: Colors.black,size: 30,),
                            )),
                        ),
                      ),
                      SizedBox(width: 10,),
                      heading2(text: "$orderAmount",),
                      SizedBox(width: 10,),
                       GestureDetector(
                        onTap: (){
                          setState(() {
                           orderAmount++;
                          });
                        },
                         child: ClipOval(
                          child: Container(
                            color: mutedColor,
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: Icon(Icons.add,color: Colors.black,size: 30,),
                            )),
                                             ),
                       ),
    
                    ],)              ,
SizedBox(height: 20,),
                    customButton(text:"Add to the order list",onClick: (){
                      product.onCartAmount = orderAmount;
                    List<Product> products =  find.onCartSupplierOrders.value;
                    products.add(product);
                    find.onCartSupplierOrders.value = [];
                    find.onCartSupplierOrders.value = products;
                    setState(() {
                      productId = "";
                      orderAmount = 1;
                    });
                    })                   
                                                  
                                                ],
                                              ):Container(),
                                            )
                                                   
                                      ],
                                    ),
                                    
                                  ),),
                              ),
                           ) ).toList());
                         }
                       ),
                     ],
                   );
                 }
               )
        ],)
      ),);
  }
}