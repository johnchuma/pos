// ignore_for_file: avoid_print

import 'package:pos/controllers/app_controller.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/clients_controller.dart';
import 'package:pos/models/Message_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivateChatController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
    AuthController authContoller = Get.find<AuthController>();
    ClientsController clientController = Get.find<ClientsController>();
    AppController appController = Get.find<AppController>();

        Rx<List<Message?>> messageReceiver = Rx<List<Message?>>([]);
        List<Message?> get messages => messageReceiver.value;
         String? userId;
      
        Stream<List<Message>> getMessages() {
          return firestore
              .collection("private_messages").where("userId",isEqualTo:appController.isAdmin.value?clientController.selectedClient.value.email:authContoller.user?.email).orderBy("createdAt",descending: true)
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
            var id = Timestamp.now().toDate().toString();
              await  firestore.collection("private_messages").doc(id).set({
              "id":id,
              "message":message,
              "name":authContoller.auth.currentUser?.displayName,
              "messageSender":"client",
              "replyTo":"",
              "isRead":false,
              "repliedMessageId":"",
              "image":"",
              "sentBy": authContoller.auth.currentUser?.email,
              "userId": appController.isAdmin.value?clientController.selectedClient.value.email: authContoller.user?.email,
              "createdAt":Timestamp.now()
            });
           await firestore.collection("conversations").doc(userId).set({
              "id":userId,
              "lastMessage":message,
              'from':authContoller.user?.email,
              'to':appController.isAdmin.value?clientController.selectedClient.value.email: authContoller.user?.email,
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