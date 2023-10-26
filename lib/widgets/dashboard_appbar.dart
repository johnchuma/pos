import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/app_controller.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/avatar.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/translatedText.dart';

PreferredSizeWidget dashboardAppbar(context,{title}){
AuthController auth = Get.find<AuthController>();
AppController appController = Get.find<AppController>();
String language = appController.language.value;
  return AppBar(
          leading: Container(),
          leadingWidth: 10,
          title: heading2(text: title??language == "ENG"?"My businesses":"Biashara zangu"),
          backgroundColor: backgroundColor,
          elevation: 0.3,
        );
}