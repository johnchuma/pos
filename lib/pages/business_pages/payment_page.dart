
// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_string_interpolations
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/Product_controller.dart';
import 'package:pos/controllers/app_controller.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/business_subscription_controller.dart';
import 'package:pos/controllers/register_controller.dart';
import 'package:pos/pages/business_pages/subscribe_now_page.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/file_picker.dart';
import 'package:pos/utils/format_date.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/bottomsheet_template.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/text_form.dart';
import 'package:pos/widgets/translatedText.dart';


class PaymentsPage extends StatefulWidget {
 
   PaymentsPage({super.key});
  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
   final _formKey = GlobalKey<FormState>();
   TextEditingController amountController = TextEditingController();
   TextEditingController descriptionController = TextEditingController();
   BusinessController businessController = Get.find<BusinessController>();
   AuthController authController  = Get.find();
   AppController appController = Get.find();
  var path = "";
  bool loading = false;
  List relatedTo = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: back(),
        elevation: 0.3,
        backgroundColor: backgroundColor,
        title: heading2(text:translatedText("Payments history", "Taarifa za malipo"),fontSize: 20),
        actions: [
          // if(appController.isAdmin.value)
          GestureDetector(
            onTap: (){
              Get.bottomSheet(bottomSheetTemplate(widget: Column(children: [
                heading2(text: "Add payment"),
                SizedBox(height: 10,),
                TextForm(hint: "Amount paid",textEditingController: amountController,color: backgroundColor),
                customButton(text: "Add payment",onClick: (){
                  BusinessSubscriptionController().addBusinessSubscription(double.parse(amountController.text)).then((value)  {
                    Get.back();
                  });
                })
              ],)));
            },
            child: Icon(Icons.add,size: 30,color: textColor,)),
          SizedBox(width: 20)],
      ),
      body: SingleChildScrollView(
        child: GetX<BusinessSubscriptionController>(
          init: BusinessSubscriptionController(),
          builder: (find) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                                                children: [
                                                  SizedBox(height: 20,),
                                                  Column(children: find.businessesSubscriptions.map((item){
                                                    return Container(child: Padding(
                                                      padding: const EdgeInsets.only(bottom: 15,left: 10),
                                                      child: Row(children: [
                                                        Container(
                                                          height: 25,
                                                          child: Image.asset("assets/credit-card_726488.png")),
                                                          SizedBox(width: 20,),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                          heading2(text: "You paid ${item.amount} TZS",fontSize: 18),
                                                          mutedText(text: "at ${formatDate(item.createdAt.toDate())}"),
                                                          
                                                          ],)
                                                      ],),
                                                    ),);
                                                  }).toList(),),
                                                  SizedBox(height: 20,),
                                                  
                                                ],
                                              ),
            );
          }
        )
      ),
    );
  }
}