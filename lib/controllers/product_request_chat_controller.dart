// ignore_for_file: avoid_print

import 'package:pos/controllers/app_controller.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/clients_controller.dart';
import 'package:pos/controllers/product_request_controller.dart';
import 'package:pos/controllers/retailer_order_controller.dart';
import 'package:pos/models/Message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ProductRequestChatController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
    ProductRequestController productRequestController = Get.find<ProductRequestController>();
    BusinessController businessController = Get.find<BusinessController>();
    AuthController authController = Get.find<AuthController>();
        Rx<List<Message?>> messageReceiver = Rx<List<Message?>>([]);
        List<Message?> get messages => messageReceiver.value;


         String? userId;
         ProductRequestChatController();
        Stream<List<Message>> getMessages() {  
          return firestore
              .collection("private_messages").where("referenceId",isEqualTo: productRequestController.selectedProductRequest.value?.id).orderBy("createdAt",descending: true)
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

         Stream<List<Message>> getOffers() {  
          return firestore
              .collection("private_messages").where("referenceId",isEqualTo: productRequestController.selectedProductRequest.value?.id)
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
           
            var array =[businessController.selectedBusiness.value?.id,productRequestController.selectedClient.value?.id];
            array.sort();
            var id = Timestamp.now().toDate().toString();
              await  firestore.collection("private_messages").doc(id).set({
              "id":id,
              "message":message,
              "name": authController.auth.currentUser?.displayName,
              "messageType":"productRequest",
              "replyTo":"",
              "repliedMessageId":"",
              "image":"",
              "referenceId":productRequestController.selectedProductRequest.value?.id,
              "readBy":1,
              "chatMembers":array,
              "from": productRequestController.isClient  ? productRequestController.selectedClient.value?.id: businessController.selectedBusiness.value?.id,
              "to": productRequestController.isClient ?businessController.selectedBusiness.value?.id:productRequestController.selectedClient.value?.id,
              "createdAt":Timestamp.now()
            });
          } catch (e) {
            print(e);
          }
      }
      Future<void> sendMessageLogic (message)async{
          try {
          


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