// ignore_for_file: avoid_unnecessary_containers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/clients_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/controllers/staff_sales_controller.dart';
import 'package:pos/controllers/register_controller.dart';
import 'package:pos/controllers/worker_controller.dart';
import 'package:pos/pages/add_worker.dart';
import 'package:pos/pages/business_pages/assign_register.dart';
import 'package:pos/pages/business_pages/staff_sales_main.dart';
import 'package:pos/pages/business_pages/view_pages/boss_view_staff_attendance.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/delete_confirmation.dart';
import 'package:pos/utils/format_date.dart';
import 'package:pos/utils/notifications.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/expanded_item.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/heading_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/no_data.dart';
import 'package:pos/widgets/translatedText.dart';

class WorkersPage extends StatefulWidget {
  const WorkersPage({super.key});

  @override
  State<WorkersPage> createState() => _WorkersPageState();
}

class _WorkersPageState extends State<WorkersPage> {
  bool expanded = false;
  String staffId = "";
  @override
  void initState() {
    Get.put(ProductController());
    Get.put(RegisterController());
    Get.put(StaffsController());
    Get.put(StaffSaleController());

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    BusinessController find = Get.find<BusinessController>();
    StaffSaleController staffSaleController = Get.find<StaffSaleController>();
    ClientsController clientsController = Get.find<ClientsController>();
  
    return  Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(leading: back(),backgroundColor: backgroundColor,elevation: 0.3,
      title: Row(children: [
       
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading2(text: translatedText("Business staffs", "Wafanyakazi") ),
            

          ],
        )),
        GestureDetector(
          onTap: (){
                      Get.to(()=>AddWorker());
          },
          child: Icon(Icons.add,size: 30, color: mutedColor,))
      ],) 
      ,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          
          children: [
            SizedBox(height: 20,),
                 GetX<StaffsController>(
                init: StaffsController(),
                 builder: (find) {
                   return find.staffs.isEmpty ?noData(): Column(children:find.staffs.map((staff) => Padding(
                     padding: const EdgeInsets.only(bottom: 15),
                     child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          color: mutedBackground,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                  setState(() {
                                    if(staffId == staff.id){
                                       staffId = "";
                                      }else{
                                       staffId = staff.id;
                                      }
                                    });
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Row(children:  [
                                      ClipOval(
                                      child: SizedBox(height: 50,width: 50,child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl:staff.details.profileImageUrl),),
                                    ),
                                    const SizedBox(width: 10,),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                        heading2(text: staff.details.name,fontSize: 18),
                                        mutedText(text:  "${translatedText("Created", "Ameongezwa")} ${formatDate(staff.createdAt.toDate())}"),
                                       
                                      ],),
                                    ),
                                                ],),
                                  ),
                                ),
                                 AnimatedSize(
                                              duration: const Duration(milliseconds: 200),
                                              child:staffId == staff.id ? Column(
                                                children: [
                                                  const SizedBox(height: 10,),                      
                                                  expandedItem(title:translatedText("Assign a register", "Husianisha na dirisha la mauzo"), iconData:Icons.table_restaurant, onClick:  (){ 
                                                     find.selectedStaff.value = staff;
                                                    Get.bottomSheet(Container(child: const AssignRegisterPage(),)); 
                                                  }),
                                                
                                                   expandedItem(title:translatedText("Worker's sales", "Mauzo ya mfanyakazi"), iconData:Icons.bar_chart, onClick:  (){
                                                    staffSaleController.selectedStaff.value = staff;
                                                    Get.to(()=>const StaffSalesMain());
                                                  },elevation: 0),  
                                                   expandedItem(title:translatedText("Worker's attendance", "Maudhurio ya mfanyakazi"), iconData:Icons.note, onClick:  (){
                                                    clientsController.selectedStaff.value = staff.details;
                                                    Get.to(()=>const BossViewStaffAttendance());
                                                  },elevation: 0),  
                                               
                                               
                                                   expandedItem(title:translatedText("Remove worker", "Ondoa mfanyakazi"), iconData:Icons.delete, onClick:  (){
                                                      confirmDelete(context,onClick: (){
                                                        find.deleteStaff(staff.id);
                                                      },onSuccess: (){
                                                        successNotification(translatedText("Removed successfully", "Imefanikuwa kufutwa"));
                                                      });
                                                  },elevation: 0),                                                                          
                                                ],
                                              ):Container(),
                                            )
                                         
                              ],
                            ),
                            
                          ),),
                      ),
                   ) ).toList());
                 }
               )
        ],)
      ),);
  }
}