import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/utils/notifications.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/text_form.dart';
TextEditingController passwordController = TextEditingController();
BusinessController businessController = Get.find();

Widget enterPassword(context,find){
  return SingleChildScrollView(
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
                                if( businessController.selectedStaffRegister?.password == passwordController.text){
                                  find.canAccessRegister.value = true;
                                  
                                  successNotification("Access granted!");
                                  
                    
                                }else{
                                  
                                  failureNotification("Wrong password");
                                  
                                }
                              })
                              ],),
                      ),)));
}