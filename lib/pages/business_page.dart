import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pos/controllers/app_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/conversation_controller.dart';
import 'package:pos/controllers/customer_controller.dart';
import 'package:pos/controllers/sell_controller.dart';
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
import 'package:pos/pages/business_pages/view_pages/customers_page.dart';
import 'package:pos/pages/business_pages/view_pages/debts_page.dart';
import 'package:pos/pages/business_pages/view_pages/payouts_page.dart';
import 'package:pos/pages/business_pages/view_pages/poster_requests.dart';
import 'package:pos/pages/business_pages/workers_page.dart';
import 'package:pos/pages/settings_page.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/enter_password.dart';
import 'package:pos/widgets/expanded_item.dart';
import 'package:pos/widgets/forbidden.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/menu_item.dart';
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
    Get.put(CustomerController());
    super.initState();
  }
   

  
@override
  void dispose() {
    super.dispose();
  }

  TextEditingController passwordController = TextEditingController();
  AppController appController = Get.find<AppController>();
  BusinessController businessController = Get.find();
  Rx<String> selectedItem =Rx<String>("");
    

  @override
  Widget build(BuildContext context) {
    var permissions = [];
    if(businessController.selectedStaffRegister != null ){
        permissions = businessController.selectedStaffRegister!.permissions;
    }
  

    return Scaffold(
      drawer: Drawer(child: Container(child: SettingsPage(),),),
                appBar: AppBar(title: heading2(text: businessController.selectedBusiness.value?.name,maxLines: 1),backgroundColor: backgroundColor,
                elevation: 0.3,
                leading: Builder(
                  builder: (context) {
                    return GestureDetector(
                      onTap: (){
                        Scaffold.of(context).openDrawer();
                      },
                      child: Icon(Icons.menu,color: textColor,));
                  }
                ),
                ),
      body:   Obx(
        ()=> find.canAccessRegister.value == false && businessController.selectedStaffRegister != null&&
         businessController.selectedStaffRegister?.password != "" ? enterPassword(context,find)
                      :
                      SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child:  Column(
                            children: [

                          if(permissions!.contains("Sell products") || find.selectedStaffRegister?.register == null  )  
                          menuItem(title:translatedText("My register", "Dirisha la mauzo"),onTap: (){
                            if(find.selectedStaffRegister?.register == null){
                              Get.bottomSheet(forbiddenMessage(title: "You can not sell products",message: "You have to be assigned to a register to sell products"));
                            }
                            else{
                              Get.to(()=>SaleProducts());
                            }
                            }, subtitle:translatedText("Sell products on your register here", "Uza bidhaa kwenye dirisha lako la mauzo")),
        
                            
                                     if(permissions.contains("Manage products") || find.selectedStaffRegister?.register == null)    
                                     menuItem(title: translatedText("Products", "Bidhaa"),
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
                                     
                       if(permissions.contains("Manage registers") || find.selectedStaffRegister?.register == null)   
                                     
                                      menuItem(title: translatedText("Registers","Madirisha ya mauzo"),
                            onTap: (){
                              Get.to(()=>const RegistersPage());
                            },
                            subtitle:translatedText("Add, delete, update registers details here", "Ongeza, futa au rekebisha taarifa hapa")),
                          if(permissions.contains("Request posters") || find.selectedStaffRegister?.register == null)   
                            menuItem(title: translatedText("Posters requests","Maagizo ya matangazo"),
                            onTap: (){
                              Get.to(()=> PosterRequests());
                            },
                            subtitle:translatedText("See posters requests", "Ona maagizo ya matangazo")),
                             permissions.contains("Manage staffs") == true || find.selectedStaffRegister?.register == null? menuItem(title:translatedText("Staffs", "Wafanyakazi"),
                                onTap: (){
                                  Get.to(()=>const WorkersPage());
                                },
                                subtitle: translatedText("Add, delete and manage staffs here", "Ongeza, futa au rekebisha taarifa hapa")):Container(),
                            
                          
                          if(permissions.contains("Manage suppliers") || find.selectedStaffRegister?.register == null)  
                          menuItem(title:translatedText("Suppliers", "Wasambazaji") ,
                            onTap: (){
                              Get.to(()=>const SuppliersPage());
                            },
                            subtitle:  translatedText("Add, delete and manage suppliers here", "Ongeza, futa au rekebisha taarifa hapa")
                          ),
          
                          if(permissions.contains("Manage customers") || find.selectedStaffRegister?.register == null)  
                           menuItem(title:translatedText("Customers", "Wateja") ,
                            onTap: (){
                              Get.to(()=>const CustomersPage());
                            },
                            subtitle:  translatedText("Add, delete and manage customers here", "Ongeza, futa au rekebisha taarifa hapa")
                          ),
          
                          if(permissions.contains("Manage debts") || find.selectedStaffRegister?.register == null)  
                          menuItem(title:translatedText("Debts", "Madeni") ,
                            onTap: (){
                              // print("Debts page");
                              Get.to(()=>const DebtsPage());
                            },
                            subtitle:  translatedText("Add, delete and manage suppliers here", "Ongeza, futa au rekebisha taarifa hapa")
                          ),
          
                         if(permissions.contains("Manage payouts") || find.selectedStaffRegister?.register == null)  
                          menuItem(title:translatedText("Payouts", "Malipo") ,
                            onTap: (){
                              // print("Payouts page");
                              Get.to(()=>const PayoutsPage());
                            },
                            subtitle:  translatedText("Add, delete and manage suppliers here", "Ongeza, futa au rekebisha taarifa hapa")
                          ),
                              if(permissions.contains("Check in & out") || find.selectedStaffRegister?.register == null) 
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
                          if(permissions.contains("Manage orders") || find.selectedStaffRegister?.register == null) 
                            menuItem(title:translatedText("Orders", "Agiza bidhaa"),
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
                           
                                     if(permissions.contains("View reports") || find.selectedStaffRegister?.register == null)   
                                     
                                     menuItem(title: translatedText("Reports", "Ripoti mbalimbali"),
                            onTap: (){
                              Get.to(()=>ReportsOptionsPage());
                            },
                            subtitle: translatedText("View reports here", "Ona ripoti mbalimbali")),
                               if(permissions.contains("View settings") || find.selectedStaffRegister?.register == null)
        
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
      ));
                  
              
           
    
  }
}