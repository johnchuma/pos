
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
import 'package:pos/pages/business_pages/view_pages/low_level_products.dart';
import 'package:pos/pages/business_pages/view_pages/out_of_stock_products.dart';
import 'package:pos/pages/sales_report_main.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/file_picker.dart';
import 'package:pos/utils/format_date.dart';
import 'package:pos/widgets/avatar.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/expanded_item.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/menu_item.dart';
import 'package:pos/widgets/translatedText.dart';
import '../../../models/message_model.dart';


class ReportsOptionsPage extends StatefulWidget {
 
   ReportsOptionsPage({super.key});
  @override
  State<ReportsOptionsPage> createState() => _ReportsOptionsPageState();
}

class _ReportsOptionsPageState extends State<ReportsOptionsPage> {
   final _formKey = GlobalKey<FormState>();

   TextEditingController nameController = TextEditingController();
   TextEditingController descriptionController = TextEditingController();
   BusinessController businessController = Get.find<BusinessController>();
  int currentPage= 0;
  var path = "";
  bool loading = false;
  List relatedTo = [];
 


  @override
  void initState() {

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
        title: heading2(text:translatedText("Reports options", "Machaguo ya aina za Jumbe")),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
        menuItem(title: "Sales reports",onTap: (){
          Get.to(()=>SalesReportOptions());
        }),
        menuItem(title: "Products with low stock level",onTap: (){
          Get.to(()=>LowStockLevelProducts());
        }),

        menuItem(title: "Out of stock products",onTap: (){
          Get.to(()=>OutOfStockProducts());
        }),
        ],),
      ),
    
    );
  }
}