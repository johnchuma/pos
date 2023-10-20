
// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos/controllers/Product_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/register_controller.dart';
import 'package:pos/controllers/suppliers_conversations_controller.dart';
import 'package:pos/controllers/tutorial_controller.dart';
import 'package:pos/pages/business_pages/business_to_supplier_chat_page.dart';
import 'package:pos/pages/business_pages/video_player.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/file_picker.dart';
import 'package:pos/utils/format_date.dart';
import 'package:pos/widgets/avatar.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/pill.dart';
import 'package:pos/widgets/text_form.dart';
import 'package:pos/widgets/translatedText.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;


class BusinessConversationsPage extends StatefulWidget {
 
   BusinessConversationsPage({super.key});
  @override
  State<BusinessConversationsPage> createState() => _BusinessConversationsPageState();
}

class _BusinessConversationsPageState extends State<BusinessConversationsPage> {
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
        title: heading2(text:translatedText("Conversations", "Jumbe")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          SizedBox(
            height: 55,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
              pill(text: translatedText("With businesses", "Kutoka kwa wateja"),active: true),
              pill(text: translatedText("About orders", "Kutoka kwa wateja")),
              pill(text: translatedText("With Clients", "Kutoka kwa wateja")),
                
            ],),
          ),
          SizedBox(height: 10,),
          GetX<SuppliersConversationsController>(
            init: SuppliersConversationsController(),
            builder: (find) {
              return Expanded(child: ListView(children: find.suppliers.map((item) => 
              GestureDetector(
                onTap: (){
                  find.updateAllNewConversations(item!);
                 businessController.selectedSender.value = item;
                  Get.to(()=>const BusinessToSupplierChatPage());
                  
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      color: Colors.white,
                      child: 
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [avatar(image: item?.image),
                      const SizedBox(width: 14,),
                       Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            heading2(text:item?.name,fontSize: 15),
                        item?.messages.value.isEmpty == true ?mutedText(text: "No new messages for now"):
                         Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             paragraph(text: item?.messages.value.first.message,maxLines: 1),
                             mutedText(text: timeago.format(item!.messages.value.first.createdAt.toDate()),fontSize: 12)
                           ],
                         ),
                          ],
                        ),   
                      ),
                    if(item?.messages.value.isNotEmpty == true)  ClipOval(child: Container(width: 25,height: 25,color: primaryColor,  child: Center(child: paragraph(text: item!.messages.value.length.toString(),color: Colors.white,fontSize: 11)),))
                      ],),
                    )
                    
                    ,),
                  ),
                ),
              )).toList(),));
            }
          )
        ],),
      ),
    
    );
  }
}