import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/debt_controller.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/delete_confirmation.dart';
import 'package:pos/utils/notifications.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/expanded_item.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/no_data.dart';
import 'package:pos/widgets/translatedText.dart';
import 'package:timeago/timeago.dart' as timeago;

class DebtsPage extends StatefulWidget {
  const DebtsPage({super.key});

  @override
  State<DebtsPage> createState() => _DebtsPageState();
}

class _DebtsPageState extends State<DebtsPage> {
  bool expanded = false;
  String debtId = "";
  @override
  void initState() {
    // Get.put(ProductController());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    BusinessController find = Get.find<BusinessController>();
    return  Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(leading: back(),backgroundColor: backgroundColor,elevation: 0.3,
      title: Row(children: [
        
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading2(text:translatedText("Debts", "Madeni")),
          

          ],
        ))
      ],) 
      ,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
                GetX<DebtController>(
                init: DebtController(),
                 builder: (find) {
                   return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                           ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        color: mutedBackground,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            cursorColor: primaryColor,
                            onChanged: (value){
                              find.searchKeyword.value = value;
                            },
                            decoration:  InputDecoration(
                            icon: Icon(Icons.search,color: mutedColor),
                            border: InputBorder.none,
                          hintStyle: TextStyle(color: mutedColor),
                            hintText: translatedText("Search name here", "Tafuta debt hapa")),
                          style:  TextStyle(fontSize: 13,color: mutedColor)),
                        )),
                       ),
                       SizedBox(height: 10),
                       find.debts.isEmpty ?noData(): Column(children:find.debts.where((item) => item.name.toLowerCase().contains(find.searchKeyword.value.toLowerCase())).map((debt) => Padding(
                         padding: const EdgeInsets.only(bottom: 15),
                         child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              color: mutedBackground,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                      setState(() {
                                        if(debtId == debt.id){
                                           debtId = "";
                                          }else{
                                           debtId = debt.id;
                                         }
                                        });
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Row(children:  [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                              heading2(text: debt.name,fontSize:18),
                                              mutedText(text:timeago.format(debt.createdAt.toDate())),
                                            ]),
                                          ),
                                        ],),
                                      ),
                                    ),
                                     AnimatedSize(
                                                  duration: const Duration(milliseconds: 200),
                                                  child:debtId == debt.id ? Column(
                                                    children: [
                                                      const SizedBox(height: 10,),                      
                                                      expandedItem(title:translatedText("Edit debt", "Boresha taarifa za dirisha"), iconData:Icons.edit, onClick:  (){   
                                                      //  find.selectedDebt.value = debt;
                                                      //  Get.to(()=>UpdateDebt());
                                                      
                                                      }),
                                                       expandedItem(title:translatedText("Delete debt", "Futa dirisha"), iconData:Icons.delete, onClick:  (){
                                                        confirmDelete(context,onClick:  (){
                                                            // find.deleteDebt(debt.id);
                                                        },onSuccess: (){
                                                          successNotification(translatedText("Deleted successfully", "Umefanikiwa kufuta") );
                                                        });
                                                      },elevation: 0), 
                                                     
                                                    ],
                                                  ):Container(),
                                                )
                                             
                                  ],
                                ),
                                
                              ),),
                          ),
                       ) ).toList()),
                     ],
                   );
                 }
               )
        ],)
      ),);
  }
}