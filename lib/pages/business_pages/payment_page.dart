
// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_string_interpolations
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/Product_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/business_subscription_controller.dart';
import 'package:pos/controllers/register_controller.dart';
import 'package:pos/pages/business_pages/subscribe_now_page.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/file_picker.dart';
import 'package:pos/utils/format_date.dart';
import 'package:pos/widgets/back.dart';
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
   TextEditingController nameController = TextEditingController();
   TextEditingController descriptionController = TextEditingController();
   BusinessController businessController = Get.find<BusinessController>();
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
        title: heading2(text:translatedText("Payments details", "Taarifa za malipo")),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
          mutedText(text: translatedText("My businesses", "Biashara zangu"),fontSize: 13),
              const SizedBox(height: 20,),
               GetX<BusinessSubscriptionController>(
                init: BusinessSubscriptionController(),
                 builder: (find) {
                   return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:find.businesses.map((business) => GestureDetector(
                    onTap: (){
                      if( find.selectedBusiness.value == business){
                        find.selectedBusiness.value = null;
                      }else{
                     find.selectedBusiness.value = business;
                      }
                    },
                     child: Padding(
                       padding: const EdgeInsets.only(bottom: 10),
                       child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            color: mutedBackground,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children:  [
                                     ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: SizedBox(height: 40,width: 40,child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl:business.image),),
                                  ),SizedBox(width: 10,),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                      heading2(text: business.name,fontSize: 13),
                                      mutedText(text:translatedText("Click to view more", "Bonyeza kuona zaidi"),maxLines: 2)
                                    ],),
                                  ),
                                  const SizedBox(width: 20,),
                                   Column(
                                     children: [
                                       ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                         child: Padding(
                                           padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 8),
                                           child: FutureBuilder(
                                                future: businessController.calculateRemainedSubscriptionDays(business: business),
                                                builder: (context,snapshot) {
                                                  if(snapshot.connectionState == ConnectionState.waiting){
                                                    return Container();
                                                  }
                                                  int days = snapshot.requireData;
                                                  return Container(
                                                    
                                                    child: heading2(text: translatedText("${days} days left", "Zimebaki siku ${days}"),color:mutedColor,fontSize: 12),);
                                                }
                                              ),
                                         ),
                                       ),
                                      //  mutedText(text: "Remained",fontSize: 13,color: mutedColor.withOpacity(0.5))
                                     ],
                                   )
                                              ],),
                                  AnimatedSize(
                                    duration: Duration(milliseconds: 300),
                                    child: find.selectedBusiness.value != business?Container(): Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                 SizedBox(height: 20,),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Container(
                                                color: Colors.green.withOpacity(0.05),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                                  child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                                    mutedText(text: translatedText("To avoid inconviniences, you are advised to pay at least 10 days before your subscriptions ends, subscription fee per month is 10,000TZS", "Kuepuka kadhaa, tunakushauri kulipia siku kumi kabla ya muda wa kutumia haujaisha, ada ya kutumia kwa mwezi ni 10,000 TZS"))
                                                    
                                                    ,GestureDetector(
                                                      onTap: (){
                                                        Get.bottomSheet(SubscribeNowPage());
                                                      },
                                                      child: heading2(text: translatedText("Pay now", "Lipia sasa"),color: Colors.orange[900]))
                                                                                            ],),
                                                ),),
                                    ),
                                 SizedBox(height: 20,),

                                        Row(
                                          children: [
                                            heading2(text: translatedText("Payment history", "Malipo ya nyuma"),fontSize: 13),
                                          ],
                                        ),
                                        
                                        SizedBox(height: 10,),
                                        Column(
                                          children: [
                                            
                                            Column(children: business.businesSubscriptions.map((item){
                                              return Container(child: Padding(
                                                padding: const EdgeInsets.only(bottom: 10,left: 10),
                                                child: Row(children: [
                                                  Container(
                                                    height: 25,
                                                    child: Image.asset("assets/credit-card_726488.png")),
                                                    SizedBox(width: 20,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                    heading2(text: "You paid ${item.amount} TZS",fontSize: 13),
                                                    mutedText(text: "at ${formatDate(item.createdAt.toDate())}"),
                                                    
                                                    ],)
                                                ],),
                                              ),);
                                            }).toList(),),
                                            SizedBox(height: 20,),
                                            
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),),
                        ),
                     ),
                   ) ).toList());
                 }
               )
           
          ],),
        ),
      ),
    );
  }
}