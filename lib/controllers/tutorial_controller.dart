
// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/models/tutorial.dart';

class TutorialController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
        Rx<List<Tutorial>> tutorialsReceiver = Rx<List<Tutorial>>([]);
        List<Tutorial> get tutorials => tutorialsReceiver.value;
        AuthController authController = Get.find<AuthController>();
        BusinessController businessController = Get.find<BusinessController>();
        Stream<List<Tutorial>> getTutorials() {
          return firestore
              .collection("tutorials")
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async{
               List<Tutorial> tutorials = [];
                  for (var element in querySnapshot.docs) {
                  Tutorial tutorial = Tutorial.fromDocumentSnapshot(element);
                  tutorials.add(tutorial);
                }
            return tutorials;    
          });
        }


  

     
       
        @override
        void onInit() {
        tutorialsReceiver.bindStream(getTutorials());
          super.onInit();
        }
}