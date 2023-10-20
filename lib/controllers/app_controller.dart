import 'package:get/get.dart';

class AppController extends GetxController{
  Rx<bool> isMainDashboardSelected = Rx<bool>(true);
  Rx<bool> accessGranted = Rx<bool>(false);
  Rx<bool> isAdmin = Rx<bool>(false);
  Rx<String> language = Rx<String>("ENG");

}