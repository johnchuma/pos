import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/controllers/public_products_controller.dart';
import 'package:pos/controllers/sales_controller.dart';
import 'package:pos/controllers/supplier_controller.dart';
import 'package:pos/models/product.dart';
import 'package:pos/pages/business_pages/add_to_cart.dart';
import 'package:pos/pages/business_pages/product_stock.dart';
import 'package:pos/pages/client/see_product_info.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/money_format.dart';
import 'package:pos/utils/notifications.dart';
import 'package:pos/widgets/avatar.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/expanded_item.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/translatedText.dart';

class SupplierPublicProducts extends StatefulWidget {
  const SupplierPublicProducts({super.key});

  @override
  State<SupplierPublicProducts> createState() => _SupplierPublicProductsState();
}

class _SupplierPublicProductsState extends State<SupplierPublicProducts> {
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
 PublicProductsController publicProductController = Get.find<PublicProductsController>();

    return  Scaffold(
      backgroundColor: backgroundColor,
     appBar: AppBar(leading: back(),backgroundColor: backgroundColor,elevation: 0.3,
      title: Row(children: [
        avatar(image: businessController.selectedSupplier.value!.image,size: 40),
        SizedBox(width: 20,),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading2(text: translatedText(businessController.selectedSupplier.value!.name, "Uza bidhaa hapa")),
         

          ],
        ))
      ],) 
      ,
      actions: [GestureDetector(
                                      onTap: (){
                                         Get.bottomSheet(SingleChildScrollView(
                                           child: ClipRRect(
                                             borderRadius: const BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
                                             child: Container(
                                              color:mutedBackground ,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                                child: Column(children: [
                                                   const SizedBox(height: 10,),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [ClipRRect(
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: Container(width: 80,height: 5,color: backgroundColor,))],),
                                                      SizedBox(height: 20,),
                                                  Container(
                                                    height: 100,
                                                    child: Image.asset("assets/8674921-removebg-preview.png")),
                                                  SizedBox(height: 20,),
                                                
                                                  heading2(text: "Confirm adding this business as your supplier",textAlign: TextAlign.center),
                                                  mutedText(text: "You are advised to contact the owner fo the business first so that you may all agree to do business together.",textAlign: TextAlign.center),
                                                  SizedBox(height: 20,),
                                                 
                                                  customButton(text: "Confirm",onClick: (){
                                                    SupplierController().addSupplier(businessController.selectedSupplier.value?.id);
                                                    
                                                    Get.back();
                                                    Get.back();
                                                    Get.back();


                                                    successNotification("Supplier is added successfully");
                                                    setState(() {
                                                      
                                                    });
                                                          
                                                    
                                                  }),
                                                  SizedBox(height: 10,),
                                                  GestureDetector(
                                                    onTap: (){
                                                      Get.back();
                                                    },
                                                    child: heading2(text: "cancel",fontSize: 13,color: mutedColor.withOpacity(0.7)))
                                              ,
                                                   const SizedBox(height: 30,),
                                              
                                                ],),
                                              ),
                                             ),
                                           ),
                                         ));
                                      },
                                      child: Icon(Icons.add,color: mutedColor,size: 30,)),
                                      SizedBox(width: 30,)
                                      ],
      ),
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
                    setState(() {
                    productController.searchKeyword.value = value;
                      
                    });
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

               
                       SizedBox(height: 20,),
                       StreamBuilder(
                        stream: find.getSupplierPublicProducts(),
                         builder: (context,snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return CircularProgressIndicator(color: textColor,);
                          }
                          List<Product> products = snapshot.requireData;
                           return Column(children:products.where((product)=>product.name.toLowerCase().contains(find.searchKeyword.value.toLowerCase())).map((product) => Padding(
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
                                      publicProductController.selectedProduct = product;
                                          Get.to(()=>ProductInfo());
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
                                                mutedText(text: "Click to view more")
                                                
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
                                                             Get.bottomSheet(AddToCart());
                                                          }),
                                                                                                                                      
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