import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';

import 'package:pos/controllers/register_controller.dart';
import 'package:pos/controllers/staff_register_controller.dart';
import 'package:pos/controllers/worker_controller.dart';
import 'package:pos/models/business.dart';
import 'package:pos/models/staff_registers.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/delete_confirmation.dart';
import 'package:pos/utils/file_picker.dart';
import 'package:pos/utils/find_location.dart';
import 'package:pos/utils/notifications.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/text_form.dart';
import 'package:pos/widgets/translatedText.dart';

class BusinessSettings extends StatefulWidget {
  const BusinessSettings({super.key});

  @override
  State<BusinessSettings> createState() => _BusinessSettingsState();
}

class _BusinessSettingsState extends State<BusinessSettings> {  
BusinessController businessController = Get.find<BusinessController>();
TextEditingController phoneController = TextEditingController();
TextEditingController nameController = TextEditingController();
TextEditingController descriptionController = TextEditingController();
TextEditingController addressController = TextEditingController(); 
double? latitude ;
double? longitude;
bool loading = false;
bool loading2 = false;
 var imageFile;
  var path = "";
  var networkImage = "";
@override
  void initState() {
    Business business = businessController.selectedBusiness.value!;

    if(business.latitude !=0){
        latitude = business.latitude;
        longitude = business.longitude;
    }
  
    nameController.text = business.name;
    descriptionController.text = business.description;
    phoneController.text = business.phone;
    addressController.text = business.address;

    networkImage = business.image;

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    Business business = businessController.selectedBusiness.value!;
    return Scaffold(
       backgroundColor: backgroundColor,
      appBar: AppBar(leading: back(),backgroundColor: backgroundColor,elevation: 0.3,
      title: Row(children: [
       
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading2(text: "Business settings"),
        

          ],
        ))
      ],) 
      ,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  paragraph(text: translatedText("Product image", "Weka picha ya bidhaa") ),
                    path != "" || networkImage != "" ? GestureDetector(
                      onTap: (){
                        setState(() {
                          path = "";
                          networkImage = "";
                        });
                      },
                      child: Icon(Icons.cancel,size: 20,color: textColor.withOpacity(0.5),)):Container()
                    ],
                  ),
                  SizedBox(height: 10,),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      color: mutedBackground,
                      height: 250,
                      width: double.infinity,
                      child:  Padding(
                        padding: const EdgeInsets.all(0),
                        child: path != "" 
                        ? Image.file(imageFile,fit: BoxFit.cover)
                        : networkImage != ""? CachedNetworkImage(imageUrl: networkImage,fit: BoxFit.cover,):  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){
                                  pickImageFromGalley().then((value) {
                                    if(value != null){
                                      setState(() {
                                        imageFile = File.fromUri(Uri.file(value.path));
                                      path = value.path;
                                      });
                                      
                                    }
                                  });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Icon(Icons.camera,size: 30,color: textColor.withOpacity(0.4),),
                                  ),
                                  mutedText(text: "Gallery")
                                ],
                              ),
                            ),
                            SizedBox(width: 50,),
                            GestureDetector(
                              onTap: (){
                                  pickImageFromCamera().then((value) {
                                    if(value != null){
                                      setState(() {
                                        imageFile = File.fromUri(Uri.file(value.path));
                                      path = value.path;
                                      });
                                      
                                    }
                                  });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Icon(Icons.add_a_photo,size: 30,color: textColor.withOpacity(0.4),),
                                  ),
                                  mutedText(text: "Camera")
                                ],
                              ),
                            ),
                          ],
                        )
                    )),
                  ),
             SizedBox(height: 20,),

                paragraph(text: "Business name"),
             SizedBox(height: 5,),
      
             TextForm(hint: "Enter business name",textEditingController: nameController,onChanged:(value){
              business.name = value;
             }),
             SizedBox(height: 10,),
             paragraph(text: "Business phone number"),
             SizedBox(height: 5,),
      
             TextForm(hint: "Business phone number",textEditingController: phoneController,onChanged:(value){
              business.phone = value;
             }),
             
             SizedBox(height: 10,),
             paragraph(text: "Business address"),
             SizedBox(height: 5,),
      
             TextForm(hint: "Eg. Dar es salaam, Makumbusho",textEditingController: addressController,onChanged:(value){
              business.address = value;
             }),
             SizedBox(height: 10,),
             paragraph(text: "Address coordinates"),
             SizedBox(height: 5,),
             ClipRRect(
              borderRadius: BorderRadius.circular(15),
               child: Container(
                color: mutedBackground,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                     business.latitude != 0? Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          heading2(text:"Longitude: ${business.longitude}" ,fontSize: 13),
                          heading2(text:"Latitude: ${business.latitude}" ,fontSize: 13),
                        ],
                      ),
                    ):  mutedText(text: "Are you on the business location, if yes you can click button bellow to pick the business coordinates"),
                 
                 SizedBox(height: 10,),
                  
                     customButton(text: business.latitude != 0?"Refresh":"Find coordinates",loading: loading, color: Colors.green[500],onClick: (){
                      setState(() {
                        loading= true;
                      });
                      findCurrentLocation().then((value) {
                       
                          if(value != null){
                       setState(() {
                           business.latitude = value.latitude!;
                           business.longitude = value.longitude!;
                           loading = false;
                         
                       });
                           businessController.updateBusiness(data: {"longitude":value.longitude,"latitude":value.latitude});
                       
                       }
                       
                        
                       
      
                      });
                     })
                    ],
                  ),
                )),
             ),
             SizedBox(height: 20,),

              paragraph(text: "Business description"),
             SizedBox(height: 5,),
      
             TextForm(hint: "Description",lines: 4, textEditingController: descriptionController,onChanged:(value){
              business.description = value;
             }),
             SizedBox(height: 10,),
             SizedBox(height: 30,),
           customButton(text: "Update details",loading: loading2, onClick: ()async{
            {
                
                 setState(() {
                   loading2= true;
                 });
                 var image = "";
                 if(path != ""){
                     image  = await  AuthController().getImageLink(imageFile);
                 }       
               var data = {
                  "name":business.name,
                  "phone":business.phone,
                  "address":business.address,
                  "description":business.description,
                  "image":path == ""?business.image:image
                 };
                 businessController.updateBusiness(data:data).then((value) {
                     setState(() {
                   loading2= false;
                 });
                 successNotification("Updated successfully");
                 });
            }
           }),
           SizedBox(height: 10,),
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
             children: [
               GestureDetector(
                onTap: (){
                  confirmDelete(context,onClick: (){
                    businessController.deleteBusiness(business.id);
                  },onSuccess: (){
                    Get.back();
                    Get.back();
                    Get.back();
                    
      
                    successNotification("Business is deleted successfully");
                  });
                },
                child: heading2(text: "Delete business",fontSize: 13,color: Colors.red[500])),
             ],
           )
          ],),
        ),
      ),
    );
  }
}