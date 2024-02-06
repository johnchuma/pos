import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/conversation_controller.dart';
import 'package:pos/controllers/product_request_controller.dart';
import 'package:pos/controllers/public_products_controller.dart';
import 'package:pos/controllers/unread_messages_controller.dart';
import 'package:pos/models/product.dart';
import 'package:pos/models/store.dart';
import 'package:pos/pages/admin/unapproved_product_requests.dart';
import 'package:pos/pages/business_pages/conversations/clients_conversation.dart';
import 'package:pos/pages/business_pages/request_product.dart';
import 'package:pos/pages/client/conversations_with_businesses.dart';
import 'package:pos/pages/client/more_category_products.dart';
import 'package:pos/pages/client/more_offer_products.dart';
import 'package:pos/pages/client/search_public_products.dart';
import 'package:pos/pages/client/see_product_info.dart';
import 'package:pos/pages/my_product_requests.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/money_format.dart';
import 'package:pos/utils/notifications.dart';
import 'package:pos/widgets/avatar.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/dashboard_appbar.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/top_icon.dart';
import 'package:pos/widgets/translatedText.dart';

import '../controllers/auth_controller.dart';
import '../models/message_model.dart';

class PublicPage extends StatefulWidget {
  const PublicPage({super.key});

  @override
  State<PublicPage> createState() => _PublicPageState();
}

class _PublicPageState extends State<PublicPage> {
AuthController auth = Get.find<AuthController>();
Rx<List<Message>> unreadMessages = Rx<List<Message>>([]);
Rx<List<Message>> productRequestMessages = Rx<List<Message>>([]);

@override
  void initState() {    
    Get.put(PublicProductsController());
    unreadMessages.bindStream(UnreadMessagesController().getUnreadMessages(messageType: "clientBusiness",to: auth.auth.currentUser?.email));
    productRequestMessages.bindStream(UnreadMessagesController().getUnreadMessages(messageType: "productRequest",to: auth.auth.currentUser?.email));
    Get.lazyPut(()=>ConversationController());
  
    super.initState();
  }

  @override
  void dispose() {
    
    super.dispose();
  }
  BusinessController businessController = Get.find<BusinessController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar:AppBar(title: heading2(text: "Explore",), 
      leading: Container(),

      leadingWidth: 1,
      backgroundColor: backgroundColor,elevation: 0.3,
       actions: [
         Obx(
                                                            ()=> GestureDetector(
                                                              onTap: (){
                                                                Get.to(()=>MyProductRequests());
                                                              },
                                                              child: Stack(
                                                                  children: [
                                                                    topIcon(
                                                                      // backgroundColor: ,
                                                                      padding: 0,
                                                                      widget: Icon(Icons.help,color: mutedColor,size: 20,)),
                                 
                                                                    if(productRequestMessages.value.length>0) Positioned(
                                                                      right: 0,
                                                                        top:0,
                                                                      child: ClipOval(
                                                                                    child: Container(
                                                                                      color: Colors.red,
                                                                                      
                                                                                      height: 20,
                                                                                      width: 20,
                                                                                      child: Center(child: Text("${productRequestMessages.value.length}",style: TextStyle(color: textColor),)),),
                                                                                  ),
                                                                    ),
                                                                  ],
                                                                ),
                                                            ),
                                                            ),
                                                            SizedBox(width: 10,),
         Obx(
                                        ()=> GestureDetector(
                                          onTap: (){
                                          Get.to(()=>ConversationsWithBusinesses());
                                                    
                                          },
                                          child: Stack(
                                            children: [
                                              topIcon(
                                                padding: 0,
                                                widget: Icon(Icons.notifications,color: mutedColor,size:20,)),
                                             if(unreadMessages.value.length>0)  
                                             Positioned(
                                                  right: 0,
                                                  top:0,
                                                  child: ClipOval(
                                          child: Container(
                                            color: Colors.red,
                                            height: 20,
                                            width: 20,
                                            child: Center(child: Text("${unreadMessages.value.length}",style: TextStyle(color: textColor),)),),
                                        ),
                                                ),
                                             
                                            ],
                                          ),
                                        ),
                                      ),
                                                            SizedBox(width: 10,),

        GestureDetector(
          onTap: (){
            Get.to(()=>SearchPublicProducts());
          },
          child: Icon(Icons.search,size: 20,color: mutedColor,)),
        SizedBox(width: 5,),
     
            SizedBox(width:10,),
            Padding(
            padding: const EdgeInsets.only(right: 20,top: 13,bottom: 13),
            child: GestureDetector(
              onTap: (){
                    Get.defaultDialog(
                      title: "",
                      backgroundColor: mutedBackground,                   
                      titleStyle: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: textColor),
                      titlePadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),                
                      content: Container(width: MediaQuery.of(context).size.width,              
                    child: Column(children: [                 
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                avatar(image: auth.user?.photoURL,size: 60),
                                 SizedBox(height: 10,),
                                    heading2(text: auth.user?.displayName),
                                    mutedText(text: auth.user?.email)],),
                                ),
                                
                              ],),
                               SizedBox(height: 20,),
                          

                      GestureDetector(
                        onTap: (){
                          Get.back();
                          AuthController().logout();
                        },
                        child: heading2(text:translatedText("Sign out", "Toka kwenye account yako"),color: Colors.red,fontSize:18)),
                               SizedBox(height: 10,),

                            ],
                          ),
    
                        ),
                        ),
                      ),
                
                    
                    ],),
                    ));
               },
              child: ClipOval(
                child: SizedBox(height: 30,width: 30,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: auth.auth.currentUser!.photoURL!),),
              ),
            ),
          )
          
          ],
      ),
      body: GetBuilder<PublicProductsController>(
        init: PublicProductsController(),
        builder: (find) {
          return SingleChildScrollView(
            child: Container(
              child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: FutureBuilder(
                    future:find.getCategoriesAndTheirProducts() ,
                    builder: (context,snapshot) {
                       if(snapshot.connectionState == ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator(color: Colors.white,));
                        }
                      List<Store> categories = snapshot.requireData;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    SizedBox(height: 20,),
                    Container(
                      height: 80,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children:categories.map((item) =>  GestureDetector(
                          onTap: (){
                             find.selectedCategory = item.name;
                              find.searchKeyword.value = "";
                              Get.to(()=>MoreCategoryProducts());
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Container(
                              width: 60,
                              child: Column(
                                      children: [
                                        ClipOval(
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            child: avatar(image: item.image,)),
                                        ),
                                        SizedBox(height: 10,),
                                        paragraph(text: item.name.replaceAll("store", ""),fontSize:15,maxLines: 1,color: mutedColor)
                                                    
                                      ],
                                    ),
                            ),
                          ),
                        )).toList())),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: heading2(text: "Beichee products"),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      height: 400,
                      child: FutureBuilder(
                        future: find.getOfferPriceProducts(),
                        builder: (context,snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return Center(child: CircularProgressIndicator(color: Colors.white,));
                          }
                          List<Product> products  = snapshot.requireData;
                          return CarouselSlider(
                                items: products.map((product) => GestureDetector(
                                  onTap: (){
                                    find.selectedProduct = product;
                                    Get.to(()=>ProductInfo());
                                  },
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Container(
                                          height: 400,
                                          width: double.infinity,
                                          child: CachedNetworkImage(imageUrl: product.image,fit: BoxFit.cover,),)),
                                      Container(height: 400,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                                   Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Expanded(child: heading2(text: product.name,maxLines: 1)),
                                                        paragraph(text: "${moneyFormat(product.sellingPrice)} TZS")
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(children: [
                                                    Icon(Icons.star,color: Colors.orange,size: 16,),
                                                    Icon(Icons.star,color: Colors.orange,size: 16,),
                                                    Icon(Icons.star,color: Colors.orange,size: 16,),
                                                    Icon(Icons.star,color: Colors.orange,size: 16,),
                                                    Icon(Icons.star,color: Colors.orange,size: 16,), SizedBox(width: 10,),mutedText(text: "(best quality)")],),
                                                   SizedBox(height: 10,),
                                                    // Wrap(children: product.properties.map((item) =>pill(text: "${item["title"]}: ${item["value"]}") ).toList(),),  
                                              
                                          ],),
                                      ),
                                      decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent,backgroundColor.withOpacity(0.9)],begin: Alignment.topCenter,end: Alignment.bottomCenter)),)
                                   
                                    ],
                                  ),
                                )).toList(),
                                options: CarouselOptions(
                                    height: 400,
                                    aspectRatio: 16/9,
                                    viewportFraction: 0.9,
                                    initialPage: 0,
                                    enableInfiniteScroll: true,
                                    reverse: false,
                                    enlargeStrategy: CenterPageEnlargeStrategy.scale,
                                    autoPlay: true,
                                    
                                    autoPlayInterval: Duration(seconds: 3),
                                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enlargeCenterPage: true,
                                    enlargeFactor: 0.3,
                                    // onPageChanged: callbackFunction,
                                    scrollDirection: Axis.horizontal,
                                )
                              );
                        }
                      ),
                    ),
                 
                  ],);
                }
              ),
            ),),
          );
        }
      ),);
  }
}