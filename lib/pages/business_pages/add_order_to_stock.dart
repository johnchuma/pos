
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/controllers/stock_controller.dart';
import 'package:pos/controllers/retailer_order_controller.dart';
import 'package:pos/models/Stock.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/text_form.dart';

class AddorderToStock extends StatefulWidget {
  const AddorderToStock({super.key});

  @override
  State<AddorderToStock> createState() => _AddorderToStockState();
}

class _AddorderToStockState extends State<AddorderToStock> {  

TextEditingController passwordController = TextEditingController();
  RetailerOrderController find = Get.find<RetailerOrderController>();
  ProductController productController = Get.find<ProductController>();
  Rx<bool> show =Rx<bool>(true);
  Rx<bool> loading = Rx<bool>(false);
  
  double? buyingPrice= 0;
  double? sellingPrice = 0;
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
            child: Container(
              color: mutedBackground,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FutureBuilder(
                  future: StockController().getLastAddedProductStock(find.selectedProductOrder.value!.product.value!.id),
                  builder: (context,snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator(color: textColor,),);
                    }
                    Stock? stock = snapshot.requireData;
                    buyingPrice = stock?.buyingPrice;
                    sellingPrice = stock?.sellingPrice;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    
                    const SizedBox(height: 10,),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(width: 80,height: 5,color: backgroundColor,))],),
                      const SizedBox(height: 20,),
                      heading2(text: "Add delivered products to stock",textAlign:TextAlign.start ),
                      const SizedBox(height: 10,),
                     
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          color: Colors.green.withOpacity(0.1),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Obx(
                                    ()=> Checkbox(value: show.value,activeColor: Colors.green, onChanged: (value){
                                         
                                            show.value = value!;
                                         
                                    }),
                                  ),
                                  Expanded(child: mutedText(text: "Use previous buying price of ${stock?.buyingPrice} TZS and selling price of ${stock?.sellingPrice} TZS ",fontSize:15))
                                ],),
                              AnimatedSize(
                                duration: Duration(milliseconds: 300),
                                child: Obx(
                                  ()=> show.value?Container():Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          paragraph(text: "Buying price"),
                                          SizedBox(height: 10,),
                                        TextForm(hint: "Buying price",initialValue: buyingPrice.toString(),onChanged: (value){
                                          buyingPrice = double.tryParse(value);
                                        }),
                                        paragraph(text: "Selling price"),
                                        SizedBox(height: 10,),
                                        TextForm(hint: "Selling price",initialValue: sellingPrice.toString(),onChanged: (value){
                                          sellingPrice = double.tryParse(value);
                                        }),
                                
                                        ],
                                      ),
                                    ),
                                ),
                              ),
                            
                              ],
                              
                            ),
                          ),
                        ),
                      ),
                                           
                      
                      const SizedBox(height: 20,),
                     Obx(
                       ()=> customButton(text: "Add to stock",loading: loading.value,onClick: (){
                           productController.selectedProduct.value = find.selectedProductOrder.value!.product.value!;
                          loading.value = true;
                        
                           StockController().addStock(find.selectedProductOrder.value?.amount.value.toString(), buyingPrice.toString(), sellingPrice.toString()).then((value) {
                        
                       if(find.selectedSupplierOrder.value!.areAllProductsDelivered()){
                         find.updateSupplierProducts(find.selectedSupplierOrder.value?.id,data: {
                            "isClosed":true
                          });
                       };
                          
                          
                          loading.value = false;
                          Get.back();
                           });
                          }),
                     ),
                      const SizedBox(height: 20,),
                    ],);
                  }
                ),
              ),
            )),
        );
     
  }
}