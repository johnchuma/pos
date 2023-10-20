
import 'package:get/get.dart';
import 'package:pos/controllers/app_controller.dart';

String translatedText(String english,String swahili){
AppController appController = Get.find<AppController>();
String language = appController.language.value;
return language == "ENG"?english:swahili;
  

}