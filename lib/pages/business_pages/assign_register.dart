import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

import 'package:pos/controllers/register_controller.dart';
import 'package:pos/controllers/staff_register_controller.dart';
import 'package:pos/controllers/worker_controller.dart';
import 'package:pos/models/staff_registers.dart';
import 'package:pos/utils/colors.dart';

import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/text_form.dart';

class AssignRegister extends StatefulWidget {
  const AssignRegister({super.key});

  @override
  State<AssignRegister> createState() => _AssignRegisterState();
}

class _AssignRegisterState extends State<AssignRegister> {  
RegisterController  registerController =  Get.find<RegisterController>();
StaffsController staffsController = Get.find<StaffsController>();
TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GetX<StaffRegistersController>(
      init: StaffRegistersController(),
      builder: (find) {
      
        return SingleChildScrollView(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const SizedBox(height: 10,),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(width: 80,height: 5,color: primaryColor.withOpacity(0.2),))],),
                  const SizedBox(height: 20,),
                  heading2(text: "Assign registers to a staff member"),
                  const SizedBox(height: 10,),
                  Column(children: registerController.registers.map((item){
                 
                          find.selectedStaffRegisterIds.value = find.staffRegisters.map((item) => item.registerId).toList();
                    
                    return Container(child: Column(
                    children: [
                      Row(children: [
                        Checkbox(
                          activeColor: Colors.green,
                          focusColor: mutedColor,
                          value: find.staffRegisters.map((item) => item.registerId).toList().contains(item.id)?true:false, onChanged: (value){
                          if(value == true){  
                               var list = find.selectedStaffRegisterIds.value ;
                               list.add(item.id);
                               find.selectedStaffRegisterIds.value = [];
                               find.selectedStaffRegisterIds.value = list;
                               find.assignRegisterToStaff(item.id);
                          }
                          else{
                            List<StaffRegister> staffRegisters = find.staffRegisters.where((staffRegister) => staffRegister.registerId ==item.id).toList();
                              find.deleteStaffRegister(staffRegisters.first.id);
                          }
                        }),
                        paragraph(text: item.title)
                      ],),
                  find.staffRegisters.map((item) => item.registerId).toList().contains(item.id) == false? Container():
                    
                    Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  SizedBox(height: 20,),
        
                  heading2(text: "Give permissions",fontSize: 14),
                  SizedBox(height: 10,),
                  Wrap(children: ["Sell product","Manage products","View reports","Manage stuff","Create orders","Manage suppliers","Manage registers"].map((permission) => 
                  GestureDetector(
                    onTap: (){
                    
                      StaffRegister staffRegister = find.staffRegisters.where((element) =>element.registerId == item.id ).first;
                      var currentpermissions = staffRegister.permissions;
                      if(find.staffRegisters.where((element) =>  find.selectedStaffRegisterIds.value.contains(element.registerId)).first.permissions.contains(permission)){
                      currentpermissions.removeWhere((element) => element == permission);
                      }
                      else{
                      currentpermissions.add(permission);
                      }
                      var data ={"permissions":currentpermissions};
                        find.updateStaffRegisterDoc(staffRegister.id, data);    

                    },
                    child:  Padding(
                      padding: const EdgeInsets.only(right: 10,bottom: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          color:  find.staffRegisters.where((staffRegister) => staffRegister.registerId ==item.id).toList().first.permissions.contains(permission)==true?primaryColor:backgroundColor,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: heading2(text: permission, color: find.staffRegisters.where((staffRegister) => staffRegister.registerId ==item.id).toList().first.permissions.contains(permission)==false?textColor:Colors.white,fontSize: 12,),
                          ),),
                      ),
                    ),
                  )).toList(),),
                  SizedBox(height: 20,),
                  heading2(text: "Staff password",fontSize: 14),
                  const SizedBox(height: 10,),
                  TextForm(hint: "Create password",color: backgroundColor,isPassword: !find.showPassword.value,suffixIcon: GestureDetector(
                    onTap: (){
                      find.showPassword.value = !find.showPassword.value;
                    },
                    child: Icon(find.showPassword.value? Icons.visibility_off:Icons.visibility,color: mutedColor,)), onChanged: (value){
                  
                       StaffRegister staffRegister = find.staffRegisters.where((element) =>element.registerId == item.id ).first;
                   find.updateStaffRegisterDoc(staffRegister.id, {"password":value});
                  }, initialValue: find.staffRegisters.where((staffRegister) => staffRegister.registerId ==item.id).toList().first.password ),
                    ],),
                      const SizedBox(height: 10,),
               
                    ],
                  ));}).toList(),),
                  const SizedBox(height: 20,),

        
                ],),
              ),
            )),
        );
      }
    );
  }
}