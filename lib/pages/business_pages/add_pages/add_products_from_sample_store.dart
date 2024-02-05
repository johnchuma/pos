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

class AddProductsFromSampleStore extends StatefulWidget {
  const AddProductsFromSampleStore({super.key});

  @override
  State<AddProductsFromSampleStore> createState() => _AddProductsFromSampleStoreState();
}

class _AddProductsFromSampleStoreState extends State<AddProductsFromSampleStore> {
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
 List<Product> products = [];
  Rx<bool> loading  = Rx<bool>(false);
    return  Scaffold(
      backgroundColor: backgroundColor,
     appBar: AppBar(leading: back(),backgroundColor: backgroundColor,elevation: 0.3,
      title: Row(children: [
      
        SizedBox(width: 10,),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading2(text: translatedText("Pick products", "Add products")),
          ],
        ))
      ],) 
  
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: [
              Container(
              height: MediaQuery.of(context).size.height-50,
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
                            FutureBuilder(
                              future: find.getSampleBusinessProduct(),
                               builder: (context,snapshot) {
                                if(snapshot.connectionState == ConnectionState.waiting){
                                  return Center(child: CircularProgressIndicator(color: textColor,));
                                }
                               products  = snapshot.requireData;
                                 return Column(children:products.where((product) => find.products.map((e) => e.name).contains(product.name) == false).where((product)=>product.name.toLowerCase().contains(find.searchKeyword.value.toLowerCase())).map((product) => Padding(
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
                                                  find.copyProduct(product).then((value) => successNotification("Product is added successfully"));
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
                                                      mutedText(text: "Click to add this product")
                                                      
                                                    ],),
                                                  ),
                                                  Icon(Icons.add,color: mutedColor,)
                                                              ],),
                                                ),
                                              ),
                                              
                                              
                                                           
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
              ],),
            ),
            Positioned(
              bottom: 20,
              right: 0,
              left: 0,
              child: Obx(()=> customButton(text: "Add all products here",loading: loading.value,onClick: ()async{
                            loading.value = true;
                            for (var product in products) {
                              await productController.copyProduct(product);
                            }
                            successNotification("Products are added successfully");
                            setState(() {
                            loading.value = false;
                            });
              })))
          ],
        )
      ),);
  }
}