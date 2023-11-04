import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/conversation_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/controllers/public_products_controller.dart';
import 'package:pos/models/business.dart';
import 'package:pos/models/conversation.dart';
import 'package:pos/models/product.dart';
import 'package:pos/pages/client/client_business_chat_page.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/dynamic_links.dart';
import 'package:pos/utils/launch_google_map.dart';
import 'package:pos/utils/money_format.dart';
import 'package:pos/widgets/appbar.dart';
import 'package:pos/widgets/avatar.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/bottomsheet_template.dart';
import 'package:pos/widgets/chat_item.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/heading_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/pill.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool loading = false;
  BusinessController businessController = Get.find<BusinessController>();
  ScrollController _scrollController = ScrollController();
  Rx<bool> gettingLink = Rx<bool>(false);
  @override
  Widget build(BuildContext context) {
    Product product =productController.selectedProduct!;
    

    return  GetBuilder<ConversationController>(
      init: ConversationController(),
      builder: (conversationController) {
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(leading: back(), elevation: 0, backgroundColor: backgroundColor,title: Obx(
              ()=> productController.selectedProductBusiness.value == null? Container():  GestureDetector(
                onTap: (){
                  Business business = productController.selectedProductBusiness.value!;
                  Get.bottomSheet(bottomSheetTemplate(widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(20),
                    //   child: Container(
                    //     height: 200,
                    //     width: double.infinity,
                    //     child: CachedNetworkImage(imageUrl:business.image,fit: BoxFit.cover,),),
                    // ),
                    SizedBox(height: 20,),
                    heading2(text: business.name),
                    mutedText(text: business.description),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        heading2(text: "Our location",color: primaryColor2),
                        GestureDetector(
                          onTap: (){
                            launchGoogleMaps(latitude: business.latitude,longitude: business.longitude);
                          },
                          child: mutedText(text: "View on map"))

                      ],
                    ),
                    Row(
                      children: [
                        paragraph(text: business.address,),
                      ],
                    ),
                    SizedBox(height: 20,),
                    customButton(text: "Call us",onClick: (){
                      launchUrl(Uri.parse("tel: ${business.phone}"));
                    })
                  ],)));
                },
                child: Row(
                    children: [
                      avatar(image: productController.selectedProductBusiness.value?.image,size: 30),
                      SizedBox(width: 10,),
                      Expanded(child: heading2(text:"${productController.selectedProductBusiness.value?.name}",maxLines: 1)),
                     SizedBox(width: 10,),
                      GestureDetector(
                        onTap: (){
                          gettingLink.value = true;
                          getDynamicLink(title: product.name,description: "Price: ${moneyFormat(product.sellingPrice)} TZS, click to chat with seller",image: product.image,productId: product.id ).then((value) {
                            Share.share(value);
                            gettingLink.value = false;
                          });
                        },
                        child: Obx(()=> gettingLink.value?Container(
                          height: 20,width: 20,
                          child: CircularProgressIndicator(color: textColor,)):Icon(Icons.share,size: 20,))),
                     SizedBox(width: 15,),
              
                    ],
                  ),
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
                            width: double.infinity,
                            height: 300,
                            child: CachedNetworkImage(imageUrl: product.image,fit: BoxFit.cover,)),
                        ),
              SizedBox(height: 20,),

                        Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: heading2(text: product.name,maxLines: 1)),
                  paragraph(text: "${moneyFormat(product.sellingPrice)} TZS")
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
                    mutedText(text: "You can chat with the owner of this product for more informations about this product"),
                    SizedBox(height: 10,),
                             customButton(text: "Chat with owner",loading: loading, onClick: ()async{
                               businessController.selectedBusiness.value = productController.selectedProductBusiness.value;
                               setState(() {
                                 loading = true;
                               });
                               Conversation conversation = await conversationController.createClientBusinessConversation();
                              conversationController.selectedConversation.value= conversation;
                               setState(() {
                               loading = false;
                               });
                               Get.to(()=>ClientBusinessChatPage(true));
                             }),
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
    );
  }
}