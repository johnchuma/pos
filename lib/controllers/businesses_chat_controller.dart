// ignore_for_file: avoid_print

import 'package:pos/controllers/app_controller.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/clients_controller.dart';
import 'package:pos/controllers/supplier_controller.dart';
import 'package:pos/models/Message_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/models/business.dart';

class BusinessToSupplierChatController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
    AuthController authContoller = Get.find<AuthController>();
    ClientsController clientController = Get.find<ClientsController>();
    AppController appController = Get.find<AppController>();
    
    BusinessController businessController = Get.find<BusinessController>();
        Rx<List<Message?>> messageReceiver = Rx<List<Message?>>([]);
        List<Message?> get messages => messageReceiver.value;
        
         String? userId;
        Stream<List<Message>> getMessages() {
             var ids = [];
             ids.add(businessController.selectedBusiness.value?.id);
             ids.add(businessController.selectedSender.value.id);
             ids.sort();
          return firestore
              .collection("private_messages").where("chatMembers",isEqualTo: ids).where("referenceId",isEqualTo: "").orderBy("createdAt",descending: true)
              .snapshots() 
              .asyncMap((QuerySnapshot querySnapshot) async {
                  List<Message> messages = [];
                  for (var element in querySnapshot.docs) {
                   Message message = Message.fromDocumentSnapshot(element);
                   messages.add(message);
                  }
                  return  messages;
          });
        }

        Future<void> deleteMessage(id) async {
        try {
          await firestore.collection("private_messages").doc(id).delete();
        } catch (e) {
          Get.snackbar("Error", e.toString(), backgroundColor: Colors.grey);
        }
      }
    
      Future<void> sendMessage (message)async{
          try {
            var array =[businessController.selectedBusiness.value?.id,businessController.selectedSender.value.id];
            array.sort();
            var id = Timestamp.now().toDate().toString();
              await  firestore.collection("private_messages").doc(id).set({
              "id":id,
              "message":message,
              "name":businessController.selectedBusiness.value?.name,
              "messageSender":"client",
              "replyTo":"",
              "repliedMessageId":"",
              "image":"",
              "referenceId":"",
              "readBy":1,
              "chatMembers":array,
              "from":businessController.selectedBusiness.value?.id,
              "to": businessController.selectedSender.value.id,
              "createdAt":Timestamp.now()
            });
          } catch (e) {
            print(e);
          }
      }
       
        @override
        void onInit() {
        messageReceiver.bindStream(getMessages());
          super.onInit();
        }
}