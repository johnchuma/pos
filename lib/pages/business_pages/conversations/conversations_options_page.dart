
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
import 'package:pos/pages/business_pages/conversations/businesses_conversations.dart';
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
         menuItem(title: "Conversations with businesses",onTap: (){
          Get.to(()=>BusinessesConversation());
         }),
         menuItem(title: "Product orders",onTap: (){
          Get.to(()=>const SupplierOrdersPage());
         }),
         menuItem(title: "Product requests",onTap: (){
          Get.to(()=>const ProductRequestsFromClients());
         }),
        ],),
      ),
    
    );
  }
}