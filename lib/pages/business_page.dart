import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pos/controllers/app_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/conversation_controller.dart';
import 'package:pos/controllers/supplier_controller.dart';
import 'package:pos/controllers/unread_messages_controller.dart';
import 'package:pos/models/poster_request.dart';
import 'package:pos/models/product_request.dart';
import 'package:pos/pages/business_pages/add_pages/create_poster_request.dart';
import 'package:pos/pages/business_pages/conversations/conversations_options_page.dart';
import 'package:pos/controllers/notification_controller.dart';
import 'package:pos/controllers/private_chat_controller.dart';
import 'package:pos/controllers/product_variants_controller.dart';
import 'package:pos/models/staff_registers.dart';
import 'package:pos/pages/business_pages/business_settings.dart';
import 'package:pos/pages/business_pages/options_pages/reports_options_page.dart';
import 'package:pos/pages/business_pages/orders_page.dart';
import 'package:pos/pages/business_pages/products_page.dart';
import 'package:pos/pages/business_pages/products_settings.dart';
import 'package:pos/pages/business_pages/registers_page.dart';
import 'package:pos/pages/business_pages/sell_products.dart';
import 'package:pos/pages/business_pages/staff_attendance.dart';
import 'package:pos/pages/business_pages/suppliers_page.dart';
import 'package:pos/pages/business_pages/view_pages/poster_requests.dart';
import 'package:pos/pages/business_pages/workers_page.dart';
import 'package:pos/pages/private_chat_room.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/notifications.dart';
import 'package:pos/widgets/appbar.dart';
import 'package:pos/widgets/avatar.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/expanded_item.dart';
import 'package:pos/widgets/forbidden.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/menu_item.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/select_register.dart';
import 'package:pos/widgets/text_form.dart';
import 'package:pos/widgets/translatedText.dart';


import '../models/message_model.dart';

class BusinessPage extends StatefulWidget {
  const BusinessPage({super.key});

  @override
  State<BusinessPage> createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> {
   ConversationController conversationController = Get.find<ConversationController>();
    BusinessController find = Get.find<BusinessController>();
    Rx<bool> loading  = Rx<bool>(false);
  Rx<List<Message>> unreadOrderMessages = Rx<List<Message>>([]);

   @override
  void initState() {
Get.put(ProductVariantsController());
Get.put(SupplierController());
    unreadOrderMessages.bindStream(UnreadMessagesController().getUnreadMessages(messageType: "order",to: find.selectedBusiness.value?.id));
    selectRegister(context, find);
    super.initState();
  }
   

  
@override
  void dispose() {
  //  find.selectedRegister.value = null;
  print("Disposing selected registers");
   find.selectedBusiness.value = null;
   find.selectedRegister.value = null;
   
    super.dispose();
  }

  TextEditingController passwordController = TextEditingController();
  AppController appController = Get.find<AppController>();
  Rx<String> selectedItem =Rx<String>("");
  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> find.noAccess.value?Scaffold(
        backgroundColor: backgroundColor,
        appBar: appbar(title: "No access"),
        body: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Container(
                            height: 100,
                            child: Image.asset("assets/cancel_753345.png")),
                          SizedBox(height: 20,),
                          heading2(text:"Sorry, your subscription is over",textAlign: TextAlign.center ),
                          mutedText(text:"Please pay to continue using this app",textAlign: TextAlign.center ),
                          SizedBox(height: 40,),
                        customButton(text: "I want to pay ",loading: loading.value, onClick: (){
                  loading.value = true;
                   PrivateChatController().sendMessage("Hello, Customer Service Team,I need assistance with processing a payment for ${find.selectedBusiness.value?.name}. Could you please help me? Thank you in advance.").then((value) {
                         Get.back();
                          Get.to(()=>PrivateChatRoom(false));
                  loading.value = false;
                        
                         });
                }),
              
                ],),
          ),
        ),): FutureBuilder(
          future: find.getStaffRegister(),
          builder: (context,snapshot) {
          
            if(snapshot.connectionState == ConnectionState.waiting){
              return Scaffold(
              backgroundColor: backgroundColor,
              body:Center(child: CircularProgressIndicator(color: textColor,),)
              );
            }
            StaffRegister? staffRegister;
         
            List? permissions  = [];
            if(snapshot.hasData){
            staffRegister = snapshot.requireData;
            permissions = [];
            permissions =   staffRegister?.permissions;
            }
          
             find.calculateRemainedSubscriptionDays().then((value){
                  if(value <1){
                    find.noAccess.value = true;
                  }else{
                  if(value<5){
                    if(find.canAccessRegister.value == true){
                    paymentRemainder(context,find,loading,value);
                    }
                  }}   
                });
            return Obx(
              ()=>  find.canAccessRegister.value == false && staffRegister != null && staffRegister.password != "" ?   Scaffold(
                backgroundColor: backgroundColor,
                appBar: AppBar(leading: back(),backgroundColor: backgroundColor,elevation: 0.3,
               
                ),
                body: SingleChildScrollView(
                  child: AnimatedSize(
                    duration: Duration(milliseconds: 300),
                    child: Container(
                      height: MediaQuery.of(context).size.height-100,
                      child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Column(
                          children: [
                            Image.asset("assets/icons8-fingerprint-accepted-94.png"),
                            SizedBox(height: 20,),
                              
                          heading2(text: "Enter password to continue"),
                          mutedText(text: "To access register you have to enter the password gived by your boss",textAlign: TextAlign.center),
                              
                          SizedBox(height: 20,),
                             TextForm(hint: "Enter your password",isPassword: true,textEditingController: passwordController),
                         
                          ],
                        ),
                          
                            customButton(text: "Continue",onClick: (){
                              if(staffRegister?.password == passwordController.text){
                                find.canAccessRegister.value = true;
                                setState(() {
                                successNotification("Access granted!");
                                });
                  
                              }else{
                                
                                failureNotification("Wrong password");
                                
                              }
                            })
                            ],),
                    ),),
                  ),
                ),):  Scaffold(
                backgroundColor: backgroundColor,
                appBar: AppBar(leading: back(),backgroundColor: backgroundColor,elevation: 0.3,
                title: GestureDetector(
                  onTap: (){
                     selectRegister(context, find, alwaysShow: true);
                  },
                  child: Row(children: [
                    avatar(image: find.selectedBusiness.value?.image,size: 35,),
                    const SizedBox(width: 10,),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        heading2(text: find.selectedBusiness.value?.name),
                         Obx(()=> find.selectedRegister.value == null?Container(): mutedText(text:"${translatedText("You are in", "Upo kwenye")} ${find.selectedRegister.value == null?"":find.selectedRegister.value?.title}"))
                      ],
                    ))
                  ],),
                ) 
                ,),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child:  Column(
                        children: [
                          SizedBox(height: 20,),
                        GetX<NotificationController>(
                          init: NotificationController(),
                          builder: (find) {
                            return GestureDetector(
                              onTap: (){
                                   Get.to(()=>ConversationsOptionsPage());
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  color: backgroundColor2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(children: [
                                    Stack(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Stack(
                                              children: [
                                               Container(
                                        height: 75,
                                        child: Image.asset("assets/9276421-removebg-preview.png")),
                                                   find.messages.length <1 ?Container(): Positioned(
                                                      right: 5,
                                                      top: 5,
                                                      child: ClipOval(
                                                      child: Container(
                                                        height: 25,
                                                        width: 25,
                                                        color: Colors.red,child: Center(child: paragraph(text: find.messages.length.toString(),color: Colors.white,fontSize: 11)),),
                                                    ),
                                                    )
                                              ],
                                            ),
                                          ],
                                        ),
                                        
                                      ],
                                    ),
                                      // SizedBox(height: 10,),
                                    heading2(text: "Check your messages"),
                                    mutedText(text: "Click here to check messages",color: mutedColor),
                                    
                                                        ],),
                                  ),),
                              ),
                            );
                          }
                        ),
                      
                      if(permissions!.contains("Sell products") || find.selectedRegister.value == null  )  
                      menuItem(title:translatedText("My register", "Dirisha la mauzo"),onTap: (){
                        if(find.selectedRegister.value == null){
                          Get.bottomSheet(forbiddenMessage(title: "You can not sell products",message: "You have to be assigned to a register to sell products"));
                        }
                        else{
                          Get.to(()=>SaleProducts());
                        }
                        }, subtitle:translatedText("Sell products on your register here", "Uza bidhaa kwenye dirisha lako la mauzo")),
    
                        
                                 if(permissions.contains("Manage products") || find.selectedRegister.value == null)    
                                 Obx(
                                   ()=>menuItem(title: translatedText("Products", "Bidhaa"),
                                                     onTap: (){
                                                      Get.to(()=>ProductsPage());
                                                        // if(selectedItem.value == "products"){
                                                        //    selectedItem.value = "";
                                                        // }
                                                        // else{
                                                        // selectedItem.value = "products";
                                                        // }
                                                   
                                                     },
                                                     expandable: selectedItem.value == "products" ,expandedItem: Column(children: [
                                                             const SizedBox(height: 10,),
                                                             expandedItem(title: "view products",iconData: Icons.remove_red_eye,onClick: (){
                                                              Get.to(()=>ProductsPage());
                                                             }),
                                                             expandedItem(title: "Products settings",iconData: Icons.settings,onClick: (){
                                                              Get.to(()=>ProductsSettings());
                                                             }),
                                                             
                                                            ],),
                                                     subtitle:translatedText("Add, delete, update products details here", "Ongeza, futa au rekebisha taarifa hapa")),
                                 ),
                                 if(permissions.contains("Manage registers") || find.selectedRegister.value == null)   
                                 
                                  menuItem(title: translatedText("Registers","Madirisha ya mauzo"),
                        onTap: (){
                          Get.to(()=>const RegistersPage());
                        },
                        subtitle:translatedText("Add, delete, update registers details here", "Ongeza, futa au rekebisha taarifa hapa")),
                      if(permissions.contains("Request posters") || find.selectedRegister.value == null)   
                                 
                        menuItem(title: translatedText("Posters requests","Maagizo ya matangazo"),
                        onTap: (){
                          Get.to(()=> PosterRequests());
                        },
                        subtitle:translatedText("See posters requests", "Ona maagizo ya matangazo")),
                      Obx(()
                        => permissions?.contains("Manage staffs") == true || find.selectedRegister.value == null? menuItem(title:translatedText("Staffs", "Wafanyakazi"),
                          onTap: (){
                            Get.to(()=>const WorkersPage());
                          },
                          subtitle: translatedText("Add, delete and manage staffs here", "Ongeza, futa au rekebisha taarifa hapa")):Container(),
                      ),
                      
                      if(permissions.contains("Manage suppliers") || find.selectedRegister.value == null)  
                      menuItem(title:translatedText("Suppliers", "Wasambazaji") ,
                        onTap: (){
                          Get.to(()=>const SuppliersPage());
                        },
                        subtitle:  translatedText("Add, delete and manage suppliers here", "Ongeza, futa au rekebisha taarifa hapa")),
                          if(permissions.contains("Check in & out") || find.selectedRegister.value == null) 
                          menuItem(title:translatedText("Staff attendance", "Mahudhurio ya mfanyakazi") ,
                        onTap: (){
                          if(find.selectedBusiness.value?.latitude == 0){
                            Get.bottomSheet(forbiddenMessage(title: "You can not use this feature",message: "Because this business did not register its location yet, register the business location on business settings first to start using"));
                          }
                          else{
                          Get.to(()=>StaffAttendance());
                          }
                        },
                        subtitle: translatedText("Daily Check in and out here", "Rekodi mahudhurio yako ya kila siku")),
                      if(permissions.contains("Manage orders") || find.selectedRegister.value == null) 
                       Obx(
                         ()=> menuItem(title:translatedText("Orders", "Agiza bidhaa"),
                         trailing: unreadOrderMessages.value.length <1?Container():  ClipOval(
                            child: Container(
                              color: Colors.red,
                              height: 20,
                              width: 20,
                              child: Center(child: Text("${unreadOrderMessages.value.length}",style: TextStyle(color: textColor),)),),
                          ),
                          onTap: (){
                            Get.to(()=>OrdersPage());
                          },
                          subtitle:  translatedText("Create and manage orders here", "Agiza bidhaa kutoka kwa wasambazaji wako") ),
                       ),
                                 if(permissions.contains("View sales reports") || find.selectedRegister.value == null)   
                                 
                                 menuItem(title: translatedText("Reports", "Ripoti mbalimbali"),
                        onTap: (){
                          Get.to(()=>ReportsOptionsPage());
                        },
                        subtitle: translatedText("View reports here", "Ona ripoti mbalimbali")),
                           if(permissions.contains("View settings") || find.selectedRegister.value == null)
    
                           menuItem(title:translatedText("Business settings", "Mipangilio") ,
                        onTap: (){
                          Get.to(()=>BusinessSettings());
                        },
                        subtitle: translatedText("Update business settings here", "Weka/Rekebisha mipangilio hapa") ),
                        const SizedBox(height: 20,),
                        ],
                      ),
                    ),
                  ),
                ),
            );
          }
        ),
    );
  }
}