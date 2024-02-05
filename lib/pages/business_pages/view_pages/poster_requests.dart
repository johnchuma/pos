import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/poster_request_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/controllers/worker_controller.dart';
import 'package:pos/pages/add_worker.dart';
import 'package:pos/pages/business_pages/product_stock.dart';
import 'package:pos/pages/business_pages/view_pages/view_poster.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/delete_confirmation.dart';
import 'package:pos/utils/notifications.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/expanded_item.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/heading_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/no_data.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/translatedText.dart';
import 'package:timeago/timeago.dart' as timeago;

class PosterRequests extends StatefulWidget {
  const PosterRequests({super.key});

  @override
  State<PosterRequests> createState() => _PosterRequestsState();
}

class _PosterRequestsState extends State<PosterRequests> {
  bool expanded = false;
  String requestId = "";
  @override
  void initState() {
    Get.put(ProductController());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    BusinessController find = Get.find<BusinessController>();
    return  Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(leading: back(),backgroundColor: backgroundColor,elevation: 0.3,
      title: Row(children: [
        
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading2(text:translatedText("Poster requests", "Madirisha ya mauzo")),
          ],
        ))
      ],) 
      ,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
              
          //  ClipRRect(
          //       borderRadius: BorderRadius.circular(15),
          //        child: Container(
          //         color: mutedBackground,
          //         child: Padding(
          //          padding: const EdgeInsets.all(20),
          //          child: Column
          //          (
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //           headingText(text: translatedText("Add new request", "Ongeza dirisha jipya"),),
          //           const SizedBox(height: 5,),
          //           mutedText(text: translatedText("Add, remove and manage requests", "Ongeza, futa au boresha dirisha jipya")),
          //           const SizedBox(height: 20,),
          //           customButton(text: translatedText("Add request", "Ongeza dirisha"),onClick: (){
          //             Get.to(()=>AddRequest());
          //           }) 
          //          ],),
          //        ),),
          //      ),
       
               const SizedBox(height: 10),
                 GetX<PosterRequestController>(
                init: PosterRequestController(),
                 builder: (find) {
                   return find.posterrequests.isEmpty ?noData(): Column(children:find.posterrequests.map((request) => Padding(
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
                                    if(request.completed){
                                      Get.to(()=>ViewPoster(request));
                                    }
                                    else{
                                     setState(() {
                                      if(requestId == request.id){
                                       requestId = "";
                                      }else{
                                       requestId = request.id;
                                      }
                                     });
                                    }
                                 
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Row(children:  [
                                     
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                        heading2(text: request.request,fontSize: 14),
                                        mutedText(text:timeago.format(request.createdAt.toDate())),
                                       
                                      ],),
                                    ),
                                   if(request.completed) Container(
            height: 25,
            child: Image.asset("assets/check_6785304.png"),),
                                                ],),
                                  ),
                                ),
                                 AnimatedSize(
                                              duration: const Duration(milliseconds: 200),
                                              child:requestId == request.id ? Column(
                                                children: [
                                                  // const SizedBox(height: 10,),                      
                                                  if(request.completed)   expandedItem(title:translatedText("View poster", "Boresha taarifa za dirisha"), iconData:Icons.remove_red_eye, onClick:  (){ 
                                                      Get.to(()=>ViewPoster(request)); 
                                                  }),
                                                 if(request.completed == false)  expandedItem(title:translatedText("Delete request", "Futa dirisha"), iconData:Icons.delete, onClick:  (){
                                                    confirmDelete(context,onClick:  (){
                                                        find.deletePosterRequest(request.id);
                                                    },onSuccess: (){
                                                      successNotification(translatedText("Request is deleted successfully", "Umefanikiwa kufuta dirisha") );
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