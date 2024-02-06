import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/clients_controller.dart';
import 'package:pos/controllers/conversation_controller.dart';
import 'package:pos/controllers/public_products_controller.dart';
import 'package:pos/controllers/unread_messages_controller.dart';
import 'package:pos/models/product.dart';
import 'package:pos/pages/client/client_business_chat_page.dart';
import 'package:pos/pages/client/see_product_info.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/money_format.dart';
import 'package:pos/widgets/avatar.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/no_data.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/translatedText.dart';
import 'package:timeago/timeago.dart' as timeago;


class MoreOffersProducts extends StatelessWidget {
   MoreOffersProducts({super.key});
   BusinessController businessController = Get.find<BusinessController>();
ClientsController clientsController = Get.find<ClientsController>();

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
        backgroundColor: backgroundColor,
      appBar: AppBar(leading: back(),backgroundColor: backgroundColor,elevation: 0.3,
      title: Row(children: [
        
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading2(text:translatedText("Offer products", "Maulizo ya bidhaa")),
          

          ],
        ))
      ],) 
      ,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GetBuilder<PublicProductsController>(
                init: PublicProductsController(),
                builder: (find) {
                  return Column(
                    children: [
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
                style:  TextStyle(fontSize:15,color: textColor)),
              )),
           ),
           SizedBox(height: 20,),
             
                      FutureBuilder(
                        future: find.getOfferPriceProducts(limit: 100),
                        builder: (context,snapshot) {
                          if(snapshot.connectionState ==ConnectionState.waiting){
                            return Center(child: CircularProgressIndicator(color: textColor,),);
                          }
                          List<Product> products  = snapshot.requireData;
                          return products.length ==0 ?noData():Expanded(
                            child: Obx(
                              ()=> ListView(children: products.where((item) =>item.name.toLowerCase().contains(find.searchKeyword.value.toLowerCase())).map((product) =>Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: GestureDetector(
                                  onTap: (){
                                    find.selectedProduct = product;
                                    Get.to(ProductInfo());
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      color: mutedBackground,
                                      child:Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Container(
                                            height: 90,
                                            width: 90,
                                            child: CachedNetworkImage(imageUrl: product.image,fit: BoxFit.cover,)),
                                        ),
                                        SizedBox(width: 20,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            paragraph(text: product.name,fontSize: 15),
                                         mutedText(text: moneyFormat(product.offerPrice)+"TZS",fontSize:15)
                                                                  
                                          ],
                                        ),
                                                                    ],),
                                      ) ,),
                                  ),
                                ),
                              ) ).toList(),),
                            ),
                          );
                        }
                      ),
                    ],
                  );
                }
              ),
      ),
    );
  }
}