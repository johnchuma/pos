import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';

Widget businessItem(business){
  return Padding(
                         padding: const EdgeInsets.only(bottom: 10),
                         child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              color: backgroundColor2,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                   Padding(
                                     padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                     child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        height: 250,
                                        width: double.infinity,
                                        child: CachedNetworkImage(imageUrl: business.image,fit: BoxFit.cover,)),
                                                                     ),
                                   ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                      
                                    heading2(text: business.name,),
                                    mutedText(text: business.description,maxLines: 1),
                                        const SizedBox(height: 20,),
                                  
                                      ],
                                    ),
                                  ),
                                ],),
                              ),),
                          ),
                       );
}