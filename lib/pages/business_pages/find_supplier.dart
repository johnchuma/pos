
// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/explore_suppliers_controller.dart';
import 'package:pos/controllers/stock_controller.dart';
import 'package:pos/controllers/store_controller.dart';
import 'package:pos/controllers/supplier_controller.dart';
import 'package:pos/controllers/retailer_order_controller.dart';
import 'package:pos/models/business.dart';
import 'package:pos/pages/business_pages/business_to_supplier_chat_page.dart';
import 'package:pos/pages/business_pages/view_pages/supplier_public_products.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/find_location.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/pill.dart';
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
    var imageFile;
  var path = "";
  bool loading = false;
  List relatedTo = [];
  BusinessController businessController =Get.find<BusinessController>();
  String? category;

  @override
  void initState() {
    RetailerOrderController retailerOrderController = Get.put(RetailerOrderController());
  category =  businessController.selectedBusiness.value!.category;
    super.initState();
  }

   DateTime? selectedDate = DateTime.now();

  
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
            future: find.findSuppliersRelatedToMyStore(category: category),
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
                      SizedBox(height: 0,),
                       GetX<StoreController>(
                init: StoreController(),
                builder: (find) {
                  return Container(
                   
                    height: 45,
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: find.stores.map((item) =>
                         pill(active: category == item.name,text: item.name,onClick: (){
                          setState(() {
                           category = item.name;          
                          });
                         }),
                       ).toList(),),
                    ),
                  );
                }
              ),
              SizedBox(height: 20,),
                      Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                        children: businesses.map((supplier) => Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: GestureDetector(
                            onTap: (){
                            
                                      businessController.selectedSupplier.value = supplier;
                                      Get.to(()=>SupplierPublicProducts());
                              
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                color: mutedBackground,
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
                                                                      mutedText(text: supplier.description,maxLines: 1),
                                    SizedBox(height: 5,),
                                         supplier.latitude != 0 && businessController.selectedBusiness.value?.latitude!= 0? Row(
                                           children: [
                                            Icon(Icons.map,color: mutedColor,size: 20,),
                                            SizedBox(width: 5,),
                                             mutedText(text: "${distanceBetweenTwoCoordinates(lat1: supplier.latitude,long1:supplier.longitude,lat2: businessController.selectedBusiness.value?.latitude,long2: businessController.selectedBusiness.value?.longitude)}"),
                                           ],
                                         ):Container()
                                                                                            , mutedText(text: supplier.address),
                          
                                                                      
                                           
                                    
                                          
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 0,),
                                        //   GestureDetector(
                                        // onTap: (){
                                        //    Get.bottomSheet(SingleChildScrollView(
                                        //      child: ClipRRect(
                                        //        borderRadius: const BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
                                        //        child: Container(
                                        //         color:mutedBackground ,
                                        //         child: Padding(
                                        //           padding: const EdgeInsets.symmetric(horizontal: 20),
                                        //           child: Column(children: [
                                        //              const SizedBox(height: 10,),
                                        //             Row(
                                        //               mainAxisAlignment: MainAxisAlignment.center,
                                        //               children: [ClipRRect(
                                        //                 borderRadius: BorderRadius.circular(10),
                                        //                 child: Container(width: 80,height: 5,color: backgroundColor,))],),
                                        //                 SizedBox(height: 20,),
                                        //             Container(
                                        //               height: 100,
                                        //               child: Image.asset("assets/8674921-removebg-preview.png")),
                                        //             SizedBox(height: 20,),
                                                  
                                        //             heading2(text: "Confirm adding this business as your supplier",textAlign: TextAlign.center),
                                        //             mutedText(text: "You are advised to contact the owner fo the business first so that you may all agree to do business together.",textAlign: TextAlign.center),
                                        //             SizedBox(height: 20,),
                                                   
                                        //             customButton(text: "Confirm",onClick: (){
                                        //               SupplierController().addSupplier(supplier.id);
                                                      
                                        //               Get.back();
                                        //               Get.back();
                          
                                        //               setState(() {
                                                        
                                        //               });
                                                            
                                                      
                                        //             }),
                                        //             SizedBox(height: 10,),
                                        //             GestureDetector(
                                        //               onTap: (){
                                        //                 Get.back();
                                        //               },
                                        //               child: heading2(text: "cancel",fontSize: 13,color: mutedColor.withOpacity(0.7)))
                                        //         ,
                                        //              const SizedBox(height: 30,),
                                                
                                        //           ],),
                                        //         ),
                                        //        ),
                                        //      ),
                                        //    ));
                                        // },
                                        // child: Icon(Icons.add_circle,color: mutedColor,size: 30,))
                                        ],
                                      ),
                                    ),
                                  //  SizedBox(height: 20,)
                                  ],
                                                      ),
                                ) ,),
                            ),
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