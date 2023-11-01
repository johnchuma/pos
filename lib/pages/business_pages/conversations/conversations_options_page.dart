
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
import 'package:pos/controllers/unread_messages_controller.dart';
import 'package:pos/pages/business_pages/business_to_supplier_chat_page.dart';
import 'package:pos/pages/business_pages/conversations/businesses_conversations.dart';
import 'package:pos/pages/business_pages/conversations/clients_conversation.dart';
import 'package:pos/pages/business_pages/conversations/product_requests_from_clients.dart';
import 'package:pos/pages/business_pages/conversations/supplier_orders_page.dart';
import 'package:pos/pages/business_pages/video_player.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/file_picker.dart';
import 'package:pos/utils/format_date.dart';
import 'package:pos/widgets/avatar.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/expanded_item.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/menu_item.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/pill.dart';
import 'package:pos/widgets/text_form.dart';
import 'package:pos/widgets/translatedText.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../models/message_model.dart';


class ConversationsOptionsPage extends StatefulWidget {
 
   ConversationsOptionsPage({super.key});
  @override
  State<ConversationsOptionsPage> createState() => _ConversationsOptionsPageState();
}

class _ConversationsOptionsPageState extends State<ConversationsOptionsPage> {
   final _formKey = GlobalKey<FormState>();

   TextEditingController nameController = TextEditingController();
   TextEditingController descriptionController = TextEditingController();
   BusinessController businessController = Get.find<BusinessController>();
  int currentPage= 0;
  var path = "";
  bool loading = false;
  List relatedTo = [];
  Rx<List<Message>> unreadClientMessages = Rx<List<Message>>([]);
  Rx<List<Message>> unreadOrderMessages = Rx<List<Message>>([]);
  Rx<List<Message>> unreadRequestMessages = Rx<List<Message>>([]);


  @override
  void initState() {
    unreadClientMessages.bindStream(UnreadMessagesController().getUnreadMessages(messageType: "clientBusiness",to: businessController.selectedBusiness.value?.id));
    unreadRequestMessages.bindStream(UnreadMessagesController().getUnreadMessages(messageType: "productRequest",to: businessController.selectedBusiness.value?.id));
    unreadOrderMessages.bindStream(UnreadMessagesController().getUnreadMessages(messageType: "order",to: businessController.selectedBusiness.value?.id));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: back(),
        elevation: 0.3,
        backgroundColor: backgroundColor,
        title: heading2(text:translatedText("Conversations options", "Machaguo ya aina za Jumbe")),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
        //  menuItem(title: "Conversations with businesses",onTap: (){
        //   Get.to(()=>BusinessesConversation());
        //  }),
        if(businessController.selectedBusiness.value?.role == "supplier") Obx(()=> menuItem(title: "Product orders",trailing:unreadOrderMessages.value.length <1?Container():  ClipOval(
                              child: Container(
                                color: Colors.red,
                                height: 20,
                                width: 20,
                                child: Center(child: Text("${unreadOrderMessages.value.length}",style: TextStyle(color: textColor),)),),
                            ),  onTap: (){
            Get.to(()=>const SupplierOrdersPage());
           }),
        ),
         Obx(
           ()=> menuItem(title: "Product requests",
           trailing:unreadRequestMessages.value.length < 1?Container():ClipOval(
                              child: Container(
                                color: Colors.red,
                                height: 20,
                                width: 20,
                                child: Center(child: Text("${unreadRequestMessages.value.length}",style: TextStyle(color: textColor),)),),
                            ),
           onTap: (){
            Get.to(()=>const ProductRequestsFromClients());
           }),
         ),
          Obx(()=>
           menuItem(title: "Chat with clients",
           trailing:unreadClientMessages.value.length <1?Container():  ClipOval(
                            child: Container(
                              color: Colors.red,
                              height: 20,
                              width: 20,
                              child: Center(child: Text("${unreadClientMessages.value.length}",style: TextStyle(color: textColor),)),),
                          ),
                          
                           onTap: (){
            Get.to(()=> ClientsConversation());
                   }),
          ),
        ],),
      ),
    
    );
  }
}