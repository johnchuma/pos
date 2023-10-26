
import 'package:pos/controllers/app_controller.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/clients_controller.dart';
import 'package:pos/controllers/supplier_controller.dart';
import 'package:pos/models/Message_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import 'package:pos/models/business.dart';

class NotificationController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
    AuthController authContoller = Get.find<AuthController>();
    ClientsController clientController = Get.find<ClientsController>();
    AppController appController = Get.find<AppController>();
    BusinessController businessController = Get.find<BusinessController>();
  
        Rx<List<Message?>> messagesReceiver = Rx<List<Message?>>([]);
        List<Message?> get messages => messagesReceiver.value;
         String? userId;
        
      Stream<List<Message>> getMessages (){
                      return firestore
                    .collection("private_messages")
                    .where("to", isEqualTo: businessController.selectedBusiness.value?.id)
                    .where("readBy", isEqualTo: 1)
                    .snapshots().map((QuerySnapshot messagesSnapshot)  {
                      List<Message> messages = [];
                       for (var doc in messagesSnapshot.docs) {
                        Message message = Message.fromDocumentSnapshot(doc);
                        messages.add(message);
                      }
                      return messages;
                    });
                      
                } 

             Stream<List<Message>> getUnreadOrderMessages (orderId){
                      return firestore
                    .collection("private_messages")
                    .where("referenceId",isEqualTo:orderId)
                    .where("to", isEqualTo: businessController.selectedBusiness.value?.id)
                    .where("readBy", isEqualTo: 1)
                    .snapshots().map((QuerySnapshot messagesSnapshot)  {
                      List<Message> messages = [];
                       for (var doc in messagesSnapshot.docs) {
                        Message message = Message.fromDocumentSnapshot(doc);
                        messages.add(message);
                      }
                      return messages;
                    });
                      
                } 
                     

        @override
  void onInit() {
    messagesReceiver.bindStream(getMessages());
    super.onInit();
  }
}