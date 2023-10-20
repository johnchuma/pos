// ignore_for_file: unused_import, implementation_imports

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pos/controllers/Product_controller.dart';
import 'package:pos/controllers/app_controller.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/clients_controller.dart';
import 'package:pos/controllers/register_controller.dart';
import 'package:pos/models/client.dart';
import 'package:pos/pages/clients_page.dart';
import 'package:pos/pages/private_chat_room.dart';
import 'package:pos/pages/dashboard_page.dart';
import 'package:pos/pages/community_page.dart';
import 'package:pos/pages/settings_page.dart';
import 'package:pos/pages/worker_dashboard.dart';
import 'package:pos/utils/notifications.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/text_form.dart';
import 'package:pos/widgets/translatedText.dart';

import '../utils/colors.dart';
import '../widgets/avatar.dart';
import '../widgets/heading2_text.dart';

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
  @override
  void initState() {
    Get.put(BusinessController());
    Get.put(ClientsController());

 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
      future: authController.findMyInfo(),
      builder: (context,snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Scaffold(
            backgroundColor: backgroundColor,
            body: Center(child: CircularProgressIndicator(color: textColor,),),);
        }
        Client client = snapshot.requireData;
        appController.language.value = client.language;
        appController.isMainDashboardSelected.value = client.selectedDashboard == "main"?true:false;
        appController.isAdmin.value = client.role == "admin" ? true:false;
        return  client.password != "" && appController.accessGranted.value == false?
          Scaffold(
              backgroundColor: backgroundColor,
              appBar: AppBar(backgroundColor: backgroundColor,elevation: 0.3,
             
              ),
              body: SingleChildScrollView(
                child: AnimatedSize(
                  duration: Duration(milliseconds: 300),
                  child: Stack(
                    children: [
                      Container(
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
                                
                            heading2(text: translatedText("Enter password to continue", "Weka neno la siri kuendelea")),
                            mutedText(text: translatedText("To access the app you will have to enter passcode", "Kutumia mfumo weka neno la siri"),textAlign: TextAlign.center),
                            SizedBox(height: 20,),
                               TextForm(hint: translatedText("Enter your password", "Ingiza neno la siri"),isPassword: true,textEditingController: passwordController),
                           
                            ],
                          ),
                           
                            
                           
              
                              ],),
                      ),),
                      Positioned(
                        bottom: 20,left: 20,right: 20,
                        child:   customButton(text:translatedText( "Continue", "Endelea"),onClick: (){
                                if(client.password == passwordController.text){
                                  setState(() {
                                  appController.accessGranted.value = true;
                                    
                                  });
                                  successNotification(translatedText("Access granted!", "Imefanikiwa"));
                
                                }else{
                                  
                                  failureNotification(translatedText("Wrong password", "Neno la siri sio sahihi"));
                                  
                                }
                              }),)
                    ],
                  ),
                ),
              ),)
          
          : Scaffold( 
        bottomNavigationBar: Container(
          color: backgroundColor,
          child:   BottomNavigationBar(
          backgroundColor: Colors.transparent,
          landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
          selectedLabelStyle: const TextStyle(color: Colors.black),
          unselectedLabelStyle: const TextStyle(color: Colors.grey),
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Ionicons.people_sharp), // Example different icon and color
              label: '',
            ),
             BottomNavigationBarItem(
              icon: Icon(Ionicons.chatbox), // Example different icon and color
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Ionicons.settings), // Example different icon and color
              label: '',
            ),
          ],
          selectedItemColor:textColor, // Set the color for the selected item
          unselectedItemColor: mutedColor.withOpacity(0.4), // Set the color for unselected items
          currentIndex: selectedTab, // You can set the current index here
          elevation: 0,
          iconSize: 25,
        
          onTap: (int index) {
          setState(() {
          selectedTab = index;
          });
          },
          ),
        )
        ,
            body: Scaffold(
            backgroundColor: backgroundColor,
            body:[  Obx(()=>appController.isMainDashboardSelected.value?DashboardPage():WorkerDashboardPage()),InsightsPage(),appController.isAdmin.value ?ClientsPage():PrivateChatRoom(),SettingsPage()][selectedTab] ,));
        
      }
    );
  }
}
