import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/models/register.dart';
import 'package:pos/models/staff_registers.dart';
import 'package:pos/pages/business_page.dart';
import 'package:pos/pages/home_page.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/appbar.dart';
import 'package:pos/widgets/menu_item.dart';

class SelectRegister extends StatelessWidget {
  const SelectRegister({super.key});

  @override
  Widget build(BuildContext context) {
    BusinessController businessController = Get.find();
    return  Scaffold(
      appBar: appbar(title: "Select register"),
      body: FutureBuilder(
        future: businessController.getStaffRegisters(),
        builder: (context,snapshot) {
          if(snapshot.connectionState ==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(color: mutedColor,),);
          }
          List<StaffRegister?> registers = snapshot.requireData;
          if(registers.isEmpty){
            Future.delayed(Duration(milliseconds: 100),(){
            businessController.selectedStaffRegister = null;
            Get.back();
            Get.to(()=>BusinessPage());
            });
          }
          else if(registers.length ==1){
             Future.delayed(Duration(milliseconds: 100),(){
            businessController.selectedStaffRegister = registers.first;
            Get.back();
            Get.to(()=>BusinessPage());
            });
          }
          

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(children: registers.map((item) =>menuItem(
              onTap: (){
               businessController.selectedStaffRegister = item;
              Get.to(()=>BusinessPage());
              },
              title:item?.register?.title,subtitle: item?.register?.description )).toList(),),
          );
        }
      ),);
  }
}