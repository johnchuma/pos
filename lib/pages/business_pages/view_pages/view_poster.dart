import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/models/poster_request.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/download_image.dart';
import 'package:pos/utils/dynamic_links.dart';
import 'package:pos/utils/notifications.dart';
import 'package:pos/widgets/appbar.dart';
import 'package:share_plus/share_plus.dart';

class ViewPoster extends StatelessWidget {
  PosterRequest request;
   ViewPoster(this.request,{super.key});
   Rx<bool> downloading =false.obs;
   Rx<bool> gettingLink =false.obs;

  @override
  Widget build(BuildContext context) {
    
    return  Scaffold(
      backgroundColor: backgroundColor,
      appBar: appbar(title:"",actions: [GestureDetector(
        onTap: ()async{
          downloading.value = true;
          // print(Image(image:))
        downloadImage(request.posterImage).then((value){
        print(value);
         successNotification("Image downloaded");   
          downloading.value = false;

        });
        },
        child: Obx(()=> downloading.value?Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Container(
                            height: 20,width: 20,
                            child: CircularProgressIndicator(color: textColor,)),
        ):Icon(Icons.download,color: mutedColor,))),SizedBox(width: 20,), 

                GestureDetector(
                        onTap: (){
                          gettingLink.value = true;
                         shareImage(request.posterImage).then((value) {
                           gettingLink.value = false;
                         });
                        },
                        child: Obx(()=> gettingLink.value?Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                          child: Container(
                            height: 20,width: 20,
                            child: CircularProgressIndicator(color: textColor,)),
                        ):Icon(Icons.share,size: 20,color: mutedColor,))),
          
          SizedBox(width: 20,)] ),
      body: Center(child: CachedNetworkImage(imageUrl: request.posterImage),),);
  }
}