import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/payout_controller.dart';
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

class PayoutsPage extends StatefulWidget {
  const PayoutsPage({super.key});

  @override
  State<PayoutsPage> createState() => _PayoutsPageState();
}

class _PayoutsPageState extends State<PayoutsPage> {
  bool expanded = false;
  String payoutId = "";
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
            heading2(text:translatedText("Payouts", "Malipo ya kidogo kidogo")),
          

          ],
        ))
      ],) 
      ,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
                GetX<PayoutController>(
                init: PayoutController(),
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
                            icon: Icon(Icons.search,color: mutedColor,),
                            border: InputBorder.none,
                          hintStyle: TextStyle(color: mutedColor),
                            hintText: translatedText("Search name here", "Tafuta payout hapa")),
                          style:  TextStyle(fontSize:15,color: mutedColor)),
                        )),
                       ),
                       SizedBox(height: 10),
                       find.payouts.isEmpty ?noData(): Column(children:find.payouts.where((item) => item.name.toLowerCase().contains(find.searchKeyword.value.toLowerCase())).map((payout) => Padding(
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
                                        if(payoutId == payout.id){
                                           payoutId = "";
                                          }else{
                                           payoutId = payout.id;
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
                                            heading2(text: payout.name,fontSize:18),
                                            mutedText(text:timeago.format(payout.createdAt.toDate()) ),
                                           
                                          ],),
                                        ),
                                        ],),
                                      ),
                                    ),
                                     AnimatedSize(
                                                  duration: const Duration(milliseconds: 200),
                                                  child:payoutId == payout.id ? Column(
                                                    children: [
                                                      const SizedBox(height: 10,),                      
                                                      expandedItem(title:translatedText("Edit payout", "Boresha taarifa za dirisha"), iconData:Icons.edit, onClick:  (){   
                                                      //  find.selectedPayout.value = payout;
                                                      //  Get.to(()=>UpdatePayout());
                                                      
                                                      }),
                                                       expandedItem(title:translatedText("Delete payout", "Futa dirisha"), iconData:Icons.delete, onClick:  (){
                                                        confirmDelete(context,onClick:  (){
                                                            // find.deletePayout(payout.id);
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