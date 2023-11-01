// ignore_for_file: avoid_print

import 'package:pos/controllers/app_controller.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/clients_controller.dart';
import 'package:pos/models/Message_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/utils/onesignal_notification.dart';

class PrivateChatController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
    AuthController authContoller = Get.find<AuthController>();
    ClientsController clientController = Get.find<ClientsController>();
    AppController appController = Get.find<AppController>();

        Rx<List<Message?>> messageReceiver = Rx<List<Message?>>([]);
        List<Message?> get messages => messageReceiver.value;
         String? userId;
      
        Stream<List<Message>> getMessages() {
           var ids = ["admin"];
           if(clientController.selectedClient.value == null){
              ids.add(authContoller.user!.email!);
           }
           else{
            ids.add(clientController.selectedClient.value!.email);
           }
           
             ids.sort();
          return firestore
              .collection("private_messages").where("chatMembers",isEqualTo:ids).orderBy("createdAt",descending: true)
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
            if(clientController.selectedClient.value == null){
              firestore.collection("clients").where("role",isEqualTo: "admin").get().then((QuerySnapshot querySnapshot) {
               List? tokenIdList = querySnapshot.docs.map((item) => item["onesignalToken"]).toList();
              sendNotification(tokenIdList:tokenIdList ,heading:authContoller.user?.displayName,contents: message,image:authContoller.user?.photoURL);         
              });
            }
            else{
               List? tokenIdList = [clientController.selectedClient.value?.onesignalToken];
              sendNotification(tokenIdList:tokenIdList ,heading:authContoller.user?.displayName,contents: message,image:authContoller.user?.photoURL);         
            }
           var array = [clientController.selectedClient.value == null?authContoller.user?.email:clientController.selectedClient.value?.email,"admin"];
            array.sort();
            var id = Timestamp.now().toDate().toString();
              await  firestore.collection("private_messages").doc(id).set({
              "id":id,
              "message":message,
              "name": authContoller.user?.displayName,
              "messageType":"clientAdmin",
              "replyTo":"",
              "repliedMessageId":"",
              "image":"",
              "referenceId":"",
              "readBy":1,
              "chatMembers":array,
              "from":clientController.selectedClient.value == null?authContoller.user?.email:"admin",
              "to":clientController.selectedClient.value == null?"admin":clientController.selectedClient.value?.email,
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