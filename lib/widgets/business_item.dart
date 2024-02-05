import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/pages/checking_for_payment.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import "package:timeago/timeago.dart" as timeago;

Widget businessItem(item,find){
  return Padding(
                           padding: const EdgeInsets.symmetric(vertical: 10),
                           child: GestureDetector(
                            onTap: (){
                              find.selectedBusiness.value = item;
                              Get.to(()=>CheckingForPayment());
                            },
                             child: Container(child: Row(
                               children: [
                               
                                 Expanded(
                                   child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Container(
                                          height: 200,
                                          width: double.infinity,
                                          child: CachedNetworkImage(imageUrl: item.image,fit: BoxFit.cover,)),
                                      ),
                                      SizedBox(height: 10,),
                                      heading2(text:item.name,fontSize: 18 ),
                                    mutedText(text: timeago.format(item.createdAt.toDate()))
                                    ],
                                   ),
                                 ),
                               ],
                             ),),
                           ),
                         );
}