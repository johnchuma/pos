
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
import 'package:pos/models/product.dart';
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
import 'package:pos/utils/money_format.dart';
import 'package:pos/widgets/avatar.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/bottomsheet_template.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/expanded_item.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/heading_text.dart';
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
         menuItem(title: "Inventory report",onTap: (){
          Get.bottomSheet(bottomSheetTemplate(widget: Padding(
            padding: const EdgeInsets.all(20),
            child: StreamBuilder(
              stream: ProductController().getProductsWithStock(),
              builder: (context,snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator(color: textColor,)),
                  );
                }
                List<Product> products = snapshot.requireData;
                double totalStock = 0.0;
                double totalStockValue = 0.0;
                double estimatedProfit = 0.0;
                double estimatedSales = 0.0;
                for (var item in products) {
                  totalStock = totalStock + item.availableStock.value;
                  totalStockValue = totalStockValue + (item.availableStock*item.buyingPrice);
                  estimatedProfit = estimatedProfit + ((item.availableStock*item.sellingPrice)-(item.availableStock*item.buyingPrice));
                  estimatedSales = estimatedSales + ((item.availableStock*item.sellingPrice));

                }
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    headingText(text: "Stock count",color: primaryColor2),
                    headingText(text: totalStock.toString(),fontSize: 30),
                    SizedBox(height: 20,),
                    headingText(text: "All stocks value",color: primaryColor2),
                    headingText(text: moneyFormat(totalStockValue)+"TZS",fontSize: 30),
                    SizedBox(height: 20,),
                    
                    headingText(text: "Estimated sales",color: primaryColor2),
                    headingText(text: moneyFormat(estimatedSales)+"TZS",fontSize: 30),
                    SizedBox(height: 20,),
                    
                    headingText(text: "Estimated profit",color: primaryColor2),
                    headingText(text: moneyFormat(estimatedProfit)+"TZS",fontSize: 30),

                          
                  ],),
                );
              }
            ),
          )));
        }),
        ],),
      ),
    
    );
  }
}