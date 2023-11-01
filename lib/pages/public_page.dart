import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/conversation_controller.dart';
import 'package:pos/controllers/product_request_controller.dart';
import 'package:pos/controllers/public_products_controller.dart';
import 'package:pos/controllers/unread_messages_controller.dart';
import 'package:pos/pages/admin/unapproved_product_requests.dart';
import 'package:pos/pages/business_pages/request_product.dart';
import 'package:pos/pages/client/conversations_with_businesses.dart';
import 'package:pos/pages/client/see_product_info.dart';
import 'package:pos/pages/my_product_requests.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/avatar.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/dashboard_appbar.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
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
      appBar:AppBar(title: heading2(text: "Explore"), 
      leading: Container(),
      leadingWidth: 1,
      backgroundColor: backgroundColor,elevation: 0.3,
       actions: [
            SizedBox(width:20,),
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
                                avatar(image: auth.user?.photoURL,size: 100),
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
                        child: heading2(text:translatedText("Sign out", "Toka kwenye account yako"),color: Colors.red,fontSize: 14)),
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
      body: GetX<PublicProductsController>(
        init: PublicProductsController(),
        builder: (find) {
          return Container(
            child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              Expanded(child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: GridView.count(crossAxisCount: 2,
                padding: const EdgeInsets.only(top: 10),
                mainAxisSpacing: 15,crossAxisSpacing: 15,
                children:find.products.map((item) => GestureDetector(
                  onTap: (){
                    find.selectedProduct = item;
                    Get.to(()=>ProductInfo());
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(child: CachedNetworkImage(imageUrl: item.image,fit: BoxFit.cover,),)),
                )).toList() ,),
              )),
            SizedBox(height: 20,),
            Row(children: [
           unreadMessages.value.length>0?   GestureDetector(
                onTap: (){
                  Get.to(()=>ConversationsWithBusinesses());
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: mutedBackground,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                      child: Center(child: Row(
                        children: [
                          heading2(text: "View messages ",fontSize: 15),
                          
                          Row(
                            children: [
                              SizedBox(width: 5,),
                              ClipOval(
                          child: Container(
                            color: Colors.red,
                            height: 20,
                            width: 20,
                            child: Center(child: Text("${unreadMessages.value.length}",style: TextStyle(color: textColor),)),),
                        ),
                            ],
                          ),
                          
                        ],
                      )),
                    )),
                ),
              ):Expanded(
                child: GestureDetector(
                  onTap: (){
                    Get.to(()=>ConversationsWithBusinesses());
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: mutedBackground,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                        child: Center(child: heading2(text: "View messages ",fontSize: 15)),
                      )),
                  ),
                ),
              ),
              SizedBox(width: 20,),
             productRequestMessages.value.length>0?   GestureDetector(
                onTap: (){
                    Get.to(()=>MyProductRequests());
                 
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                      decoration: BoxDecoration(gradient: LinearGradient(colors: [primaryColor,primaryColor2])),
                    
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                      child: Center(child: Row(
                        children: [
                          heading2(text: "Request offers",fontSize: 15),
                          
                          Row(
                            children: [
                              SizedBox(width: 5,),
                              ClipOval(
                          child: Container(
                            color: Colors.red,
                            height: 20,
                            width: 20,
                            child: Center(child: Text("${productRequestMessages.value.length}",style: TextStyle(color: textColor),)),),
                        ),
                            ],
                          ),
                          
                        ],
                      )),
                    )),
                ),
              ): Expanded(
                child: GestureDetector(
                  onTap: (){
                    Get.to(()=>MyProductRequests());
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(gradient: LinearGradient(colors: [primaryColor,primaryColor2])),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
                        child: Center(child: heading2(text: "Request offers",fontSize: 14)),
                      ),),
                  )),
              )
            ],),
            SizedBox(height: 10,)
            ],),
          ),);
        }
      ),);
  }
}