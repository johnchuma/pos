
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/attendance_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/controllers/register_controller.dart';
import 'package:pos/controllers/worker_controller.dart';
import 'package:pos/models/business.dart';
import 'package:pos/pages/add_worker.dart';
import 'package:pos/pages/business_pages/add_register.dart';
import 'package:pos/pages/business_pages/product_stock.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/delete_confirmation.dart';
import 'package:pos/utils/find_location.dart';
import 'package:pos/utils/format_date.dart';
import 'package:pos/utils/notifications.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/expanded_item.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/heading_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/no_data.dart';
import 'package:pos/widgets/paragraph.dart';

class StaffAttendance extends StatefulWidget {
  const StaffAttendance({super.key});

  @override
  State<StaffAttendance> createState() => _StaffAttendanceState();
}

class _StaffAttendanceState extends State<StaffAttendance> {
  bool expanded = false;
  String registerId = "";
  bool loading = false;
  bool loading2 = false;
  String selectedAttendance = "";
  @override
  void initState() {
    Get.put(ProductController());
    super.initState();
  }
    BusinessController find = Get.find<BusinessController>();

  @override
  Widget build(BuildContext context) {
    Business business = find.selectedBusiness.value;
    return  Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(leading: back(),backgroundColor: backgroundColor,elevation: 0.3,
      title: Row(children: [
       
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading2(text: "Staff attendance"),
        

          ],
        ))
      ],) 
      ,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          
          children: [
                      const SizedBox(height: 20,),

           ClipRRect(
                borderRadius: BorderRadius.circular(15),
                 child: Container(
                  color: mutedBackground,
                  child: Padding(
                   padding: const EdgeInsets.all(20),
                   child: Column
                   (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    headingText(text: "Welcome today",),
                    const SizedBox(height: 5,),
                    mutedText(text: "Check in or out  by clicking below"),
                    const SizedBox(height: 20,),
                    customButton(text: "Check in",loading: loading, onClick: (){
                      setState(() {
                        loading = true;
                      });
                      findCurrentLocation().then((value) {
                        if(value != null){
                         double distance= Geolocator.distanceBetween(business.latitude, business.longitude, value.latitude!, value.longitude!);
                       
                       if(distance <100 && distance>0){
                        AttendanceController().checkIn().then((value) {
                        successNotification("Checked in successfully");
                        });

                       }
                       else{
                        failureNotification("Sorry! you are not around, you can not check In");
                       }
                      
                        setState(() {
                        loading = false;
                      });
                        }
                      });
                    }) 
                   ],),
                 ),),
               ),
               const SizedBox(height: 20,),
               heading2(text: "Attendance report"),
               const SizedBox(height: 20),
                 GetX<AttendanceController>(
                init: AttendanceController(),
                 builder: (find) {
                   return find.attendances.isEmpty ?noData(): Column(children:find.attendances.map((attendance) => Padding(
                     padding: const EdgeInsets.only(bottom: 15),
                     child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                  // setState(() {
                                  //   if(registerId == register.id){
                                  //      registerId = "";
                                  //     }else{
                                  //      registerId = register.id;
                                  //     }
                                  //   });
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Row(children:  [
                                     
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                        heading2(text: formatDateHumans(attendance.createdAt.toDate()),fontSize: 14),
                                        
                                        Row(
                                          children: [
                                           mutedText(text: "Checked in at ${getDateTime(attendance.checkInTime.toDate())}"),
                                          
                                          ],
                                        ),
                                       if(attendance.checkOutTime != null)  Row(
                                          children: [
                                          mutedText(text: "Checked out at ${getDateTime(attendance.checkOutTime.toDate())}"),
                                          
                                          ],
                                        ),
                                      ],),
                                    ),

                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                        loading2 = true;
                                        selectedAttendance = attendance.id;

                                      });
                                      findCurrentLocation().then((value) {
                                        if(value != null){
                                        double distance= Geolocator.distanceBetween(business.latitude, business.longitude, value.latitude!, value.longitude!);
                                      
                                      if(distance <100 && distance>0){
                                        AttendanceController().checkOut(attendance.id).then((value) {
                                        successNotification("Checked out successfully");
                                        });

                                      }
                                      else{
                                        failureNotification("Sorry! you are not around, you can not check In");
                                      }
                                      
                                        setState(() {
                                        loading2 = false;
                                        // selectedAttendance = attendance.id;

                                      });}});
                                      },
                                      child: Container(
                                        width: 80,
                                        child: Center(
                                          child: attendance.checkOutTime != null?Container(): loading2 && selectedAttendance == attendance.id?Container(
                                            height: 25,
                                            width: 25,
                                            child: CircularProgressIndicator(color: primaryColor,)): Container(
                                              child: heading2(text: "Check out",color: primaryColor,fontSize: 13)),
                                        ),
                                      ))
                                                ],),
                                  ),
                                ),
                                 
                                
                                         
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