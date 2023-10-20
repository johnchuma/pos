
// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/explore_suppliers_controller.dart';
import 'package:pos/controllers/stock_controller.dart';
import 'package:pos/controllers/supplier_controller.dart';
import 'package:pos/controllers/supplier_order_controller.dart';
import 'package:pos/models/business.dart';
import 'package:pos/pages/business_pages/business_to_supplier_chat_page.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/text_form.dart';


class FindSupplier extends StatefulWidget {
 
   FindSupplier({super.key});
  @override
  State<FindSupplier> createState() => _FindSupplierState();
}

class _FindSupplierState extends State<FindSupplier> {
   final _formKey = GlobalKey<FormState>();

   TextEditingController nameController = TextEditingController();
   TextEditingController addressController = TextEditingController();
   TextEditingController descriptionController = TextEditingController();
   TextEditingController phone1Controller = TextEditingController();
   TextEditingController phone2Controller = TextEditingController();
   TextEditingController phone3Controller = TextEditingController();
   

  @override
  void initState() {
    SupplierOrderController supplierOrderController = Get.put(SupplierOrderController());

    super.initState();
  }

   DateTime? selectedDate = DateTime.now();

   var imageFile;
  var path = "";
  bool loading = false;
  List relatedTo = [];
  BusinessController businessController =Get.find<BusinessController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: back(),
        elevation: 0.3,
        backgroundColor: backgroundColor,
        title: heading2(text: "Find suppliers"),
      ),
      body: GetBuilder<ExploreSuppliersController>(
        init: ExploreSuppliersController(),
        builder: (find) {
          return FutureBuilder(
            future: find.findSuppliersRelatedToMyStore(),
            builder: (context,snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(color: textColor,));
              }
              List<Business> businesses = snapshot.requireData;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                   
                      Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                        children: businesses.map((supplier) => Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              color: Colors.white,
                              child:Padding(
                                padding: const EdgeInsets.all(0),
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        height: 250,
                                        width: double.infinity,
                                        child: CachedNetworkImage(imageUrl: supplier.image,fit: BoxFit.cover,)),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              heading2(text: supplier.name),
                                                                    mutedText(text: supplier.description),
                                                                     SizedBox(height: 10,),
                                    Row(
                                                                  
                                      children: [
                                     Row(
                                       children: [
                                  
                                         Icon(Icons.remove_red_eye,size: 23,color: mutedColor.withOpacity(0.3),),                
                                         heading2(text: " view product",fontSize: 12,color: textColor.withOpacity(0.5))
                                                                   
                                       ],
                                     ),
                                     SizedBox(width: 10,),
                                      GestureDetector(
                                        onTap: (){
                                          businessController.selectedSender.value = supplier;
                                            Get.to(()=>BusinessToSupplierChatPage());
                                        },
                                        child: Row(
                                         children: [
                                          
                                           Icon(Icons.chat_bubble,size: 20,color: mutedColor.withOpacity(0.3),),                
                                           heading2(text: " Chat with us",fontSize: 12,color: textColor.withOpacity(0.5))
                                                                     
                                         ],
                                                                           ),
                                      ),
                                                          
                                    ],)
                                        
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 0,),
                                        GestureDetector(
                                      onTap: (){
                                         Get.bottomSheet(SingleChildScrollView(
                                           child: ClipRRect(
                                             borderRadius: const BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
                                             child: Container(
                                              color: Colors.white,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                                child: Column(children: [
                                                   const SizedBox(height: 10,),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [ClipRRect(
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: Container(width: 80,height: 5,color: primaryColor.withOpacity(0.2),))],),
                                                      SizedBox(height: 20,),
                                                  Container(
                                                    height: 100,
                                                    child: Image.asset("assets/8674921-removebg-preview.png")),
                                                  SizedBox(height: 20,),
                                                
                                                  heading2(text: "Confirm adding this business as your supplier",textAlign: TextAlign.center),
                                                  mutedText(text: "You are advised to contact the owner fo the business first so that you may all agree to do business together.",textAlign: TextAlign.center),
                                                  SizedBox(height: 20,),
                                                 
                                                  customButton(text: "Confirm",onClick: (){
                                                    SupplierController().addSupplier(supplier.id);
                                                    
                                                    Get.back();
                                                    setState(() {
                                                      
                                                    });
                                                          
                                                    
                                                  }),
                                                  SizedBox(height: 10,),
                                                  GestureDetector(
                                                    onTap: (){
                                                      Get.back();
                                                    },
                                                    child: heading2(text: "cancel",fontSize: 13,color: mutedColor.withOpacity(0.7)))
                                              ,
                                                   const SizedBox(height: 30,),
                                              
                                                ],),
                                              ),
                                             ),
                                           ),
                                         ));
                                      },
                                      child: Icon(Icons.add_circle,color: primaryColor,size: 30,))
                                      ],
                                    ),
                                  ),
                                 SizedBox(height: 20,)
                                ],
                                                    ),
                              ) ,),
                          ),
                        )).toList()),
                    ],
                  ),
                ),
              );
            }
          );
        }
      ),
    );
  }
}