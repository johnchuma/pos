
// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/controllers/stock_controller.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/text_form.dart';


class AddStock extends StatefulWidget {
 
   AddStock({super.key});
  @override
  State<AddStock> createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {
   final _formKey = GlobalKey<FormState>();

   TextEditingController amountController = TextEditingController();
   TextEditingController buyingPriceController = TextEditingController();
   TextEditingController sellingPriceController = TextEditingController();
  
   ProductController find = Get.find<ProductController>();
  @override
  void initState() {
 
    super.initState();
  }

  DateTime? selectedDate = DateTime.now();
  var imageFile;
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
        title: heading2(text: "Add stock"),
      ),
      body:  SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
                children: [    
                Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         mutedText(text: "Stock amount (Quantity*)"),
                  const SizedBox(height: 10,),
                   TextForm(hint: "Enter stock amount",
                   textEditingController: amountController,
                   textInputType: TextInputType.number,
                   lines: 1),
                   const SizedBox(height: 10,),
                mutedText(text: "Buying price for each"),
                  const SizedBox(height: 10,),
                   TextForm(hint: "Enter buying price ",
                   textEditingController: buyingPriceController,
                   textInputType: TextInputType.number,
                   lines: 1),
                   const SizedBox(height: 10,),
                 mutedText(text: "Selling price for each"),
                  const SizedBox(height: 10,),
                   TextForm(hint: "Enter selling price",
                   textEditingController: sellingPriceController,
                   textInputType: TextInputType.number,
                   lines: 1),
                   const SizedBox(height: 10,),
                 
                  ],)),
                   const SizedBox(height: 20,),
                 
                   customButton(text: "Add stock", loading: loading, onClick: (){
                   
                      if(_formKey.currentState!.validate()){
                         setState(() {
                         loading = true;
                       });
                      StockController().addStock(amountController.text, buyingPriceController.text, sellingPriceController.text) .then((value) {
                        Get.back();
                      });}
                   }),      
                   const SizedBox(height: 30,),
          
              ],),
            ),
         
      ),
    );
  }
}