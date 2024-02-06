// ignore_for_file: unused_import, implementation_imports

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:pos/controllers/Product_controller.dart';
import 'package:pos/controllers/app_controller.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/clients_controller.dart';
import 'package:pos/controllers/conversation_controller.dart';
import 'package:pos/controllers/register_controller.dart';
import 'package:pos/controllers/unread_messages_controller.dart';
import 'package:pos/models/business.dart';
import 'package:pos/models/client.dart';
import 'package:pos/models/staff_registers.dart';
import 'package:pos/pages/add_business.dart';
import 'package:pos/pages/business_page.dart';
import 'package:pos/pages/checking_for_payment.dart';
import 'package:pos/pages/clients_page.dart';
import 'package:pos/pages/private_chat_room.dart';
import 'package:pos/pages/dashboard_page.dart';
import 'package:pos/pages/community_page.dart';
import 'package:pos/pages/public_page.dart';
import 'package:pos/pages/select_register.dart';
import 'package:pos/pages/settings_page.dart';
import 'package:pos/pages/worker_dashboard.dart';
import 'package:pos/utils/notifications.dart';
import 'package:pos/widgets/appbar.dart';
import 'package:pos/widgets/business_item.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/text_form.dart';
import 'package:pos/widgets/translatedText.dart';

import '../models/message_model.dart';
import '../utils/colors.dart';
import '../widgets/avatar.dart';
import '../widgets/heading2_text.dart';
import "package:timeago/timeago.dart" as timeago;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTab = 0;
   AppController appController = Get.find<AppController>();
   TextEditingController passwordController = TextEditingController();
   AuthController authController =Get.find<AuthController>();
   Rx<List<Message>> unreadMessages = Rx<List<Message>>([]);
  @override
  void initState() {
    unreadMessages.bindStream(UnreadMessagesController().getUnreadMessages(messageType: "clientAdmin",to: authController.auth.currentUser?.email));
    Get.put(BusinessController());
    Get.put(ClientsController());
  
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
  ClientsController clientsController = Get.find();
    return  FutureBuilder(
      future: authController.findMyInfo(),
      builder: (context,snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Scaffold(
            backgroundColor: backgroundColor,
            body: Center(child: CircularProgressIndicator(color: textColor,),),);
        }
        Client client = snapshot.requireData;
        authController.me.value = client;
        clientsController.selectedClient.value = client;
        appController.language.value = client.language;
        appController.isMainDashboardSelected.value = client.selectedDashboard == "main"?true:false;
        appController.isAdmin.value = client.role == "admin" ? true:false;
        return GetX<BusinessController>(
          init: BusinessController(),
          builder: (find) {
    
            return StreamBuilder(
                        stream: find.getStaffBusinesses(),
                        builder: (context,snapshot) {
                          if(snapshot.connectionState==ConnectionState.waiting){
                            return Scaffold(backgroundColor: backgroundColor,body: Center(child: CircularProgressIndicator(color:textColor,),),);
                          }
                          List<Business> businesses = snapshot.requireData;
                return find.loading.value?Scaffold(
                  backgroundColor: backgroundColor,
                  body: Center(child: CircularProgressIndicator(color: textColor,))): find.businesses.isEmpty && businesses.isEmpty?Scaffold(body:
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    heading2(text: "Register your business",fontSize: 30,textAlign: TextAlign.center),
                    SizedBox(height: 10,),
                    mutedText(text: "Let's register your business to get started, you can register more than one business",
                    textAlign: TextAlign.center),
                    SizedBox(height: 20,),
                    customButton(text: "Add business",onClick: (){
                      Get.to(()=>AddBusiness());
                    })
                  ],),
                ),):  Scaffold(
                      backgroundColor: backgroundColor,
                      appBar: AppBar(title: heading2(text: "Select business"),
                      leading: Container(),
                      leadingWidth: 5,
                      backgroundColor: backgroundColor,
                      elevation: 0.3,
                      actions: [
                        GestureDetector(
                          onTap: (){
                            
                          Get.to(()=>AddBusiness());
                          },
                          child: Icon(Icons.add,color: mutedColor,size: 30,)) 
                    ,SizedBox(width: 20,)]),
                        body: StreamBuilder(
                          stream: find.businessesReceiver.stream,
                          builder: (context,snapshot) {
                            return SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                child: Column(children: [
                              
                                //my businesses
                                ...find.businesses.map((item) => businessItem(item, find)).toList(),
                                
                                  //Staff busniesses;
                                ...businesses.map((item)=>businessItem(item, find)).toList(),
                                ],),
                              ),
                            );
                          }
                        ),
                );
          }
        );
              }
            ) ;
          }
        );
        
      
  }
}
