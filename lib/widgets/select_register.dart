import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/app_controller.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/models/register.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/translatedText.dart';

selectRegister(context,BusinessController find,{alwaysShow}){
  AppController appController = Get.find<AppController>();
  
   find.getStaffRegisters().then((registers){
      if(alwaysShow??find.selectedRegister.value == null){
        if(registers.isNotEmpty){
             if(alwaysShow??registers.length >1){
              Get.defaultDialog(
                title: "",
                backgroundColor: mutedBackground,
                titlePadding: EdgeInsets.all(0),
                barrierDismissible: false,
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                 radius: 15,
                content: Container(
                  width: MediaQuery.of(context).size.width,
                
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    heading2(text: translatedText("Select your register", "Chagua dirisha lako la mauzo")),
                  const SizedBox(height: 5,),

                 if(appController.isMainDashboardSelected.value)   Row(children: [
                    Obx(
                      ()=> Checkbox(
            fillColor: MaterialStateColor.resolveWith((states) =>Colors.white ),
                              splashRadius: 50,
                              activeColor: Colors.green,
                              hoverColor: primaryColor,
                              checkColor: Colors.black,
                              focusColor: Colors.black,
                        value:find.selectedRegister.value ==null?true:false, onChanged: (value){   
                        find.selectedRegister.value = null;
                        Get.back();

                   
                      }),
                    ),
                    mutedText(text:  "None")
                  ],),
                  const SizedBox(height: 5,),

                  Column(children: registers.map((Register item)=> Row(children:[
                    Obx(
                      ()=> Checkbox(
                      activeColor: primaryColor,
                        value:find.selectedRegister.value ==null?false:find.selectedRegister.value?.id == item.id?true:false, onChanged: (value){   
                        find.selectedRegister.value = item;
                     find.canAccessRegister.value = false;
                    

                        Get.back();
                   
                      }),
                    ),
                    mutedText(text: item.title)
                  ],)).toList(),),
                      SizedBox(height: 10,),
                 
                              ],),
                ));
           }
           else{
            find.selectedRegister.value = registers.first;
           }
         }
      
      }
        
     } );
}