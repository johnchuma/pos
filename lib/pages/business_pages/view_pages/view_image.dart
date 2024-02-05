import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/appbar.dart';

class ViewImage extends StatelessWidget {
  String image;
   ViewImage(this.image,{super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: backgroundColor,appBar: appbar(title: ""),body: Center(child:CachedNetworkImage(imageUrl: image) ,),);
  }
}