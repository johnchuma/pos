import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget avatar({double?size,image}){
  return ClipOval(child: Container(height: size??50,width: size??50,color: Colors.grey,child: CachedNetworkImage(
    fit: BoxFit.cover,
    imageUrl: image??"https://us.123rf.com/450wm/warrengoldswain/warrengoldswain1108/warrengoldswain110800263/10191136-amanzingly-high-detailed-portrait-of-an-african-face-must-see-at-full-size.jpg"),));
}