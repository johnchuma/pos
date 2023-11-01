// ignore_for_file: avoid_print

import 'package:pos/controllers/app_controller.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/clients_controller.dart';
import 'package:pos/controllers/conversation_controller.dart';
import 'package:pos/models/Message_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/utils/onesignal_notification.dart';

class ClientBusinessChatController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
    AuthController authContoller = Get.find<AuthController>();
    ClientsController clientController = Get.find<ClientsController>();
    BusinessController  businessController = Get.find<BusinessController>();
    ConversationController conversationController = Get.find<ConversationController>();
    AppController appController = Get.find<AppController>();
    bool isClient = false;
     ClientBusinessChatController(this.isClient);
        Rx<List<Message?>> messageReceiver = Rx<List<Message?>>([]);
        List<Message?> get messages => messageReceiver.value;
         String? userId;
      
        Stream<List<Message>> getMessages() {   
          return firestore
              .collection("private_messages").where("referenceId",isEqualTo:conversationController.selectedConversation.value?.id).orderBy("createdAt",descending: true)
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
           var array = [
              authContoller.user?.email,
              businessController.selectedBusiness.value?.id
           ];
          if(isClient){
             List? tokenIdList = businessController.selectedBusiness.value?.staffs.map((item) =>item.onesignalToken).toList();
              sendNotification(tokenIdList:tokenIdList ,heading:authContoller.user?.displayName,contents: message,image:authContoller.user?.photoURL);         
          }
          else{
            List? tokenIdList = [clientController.selectedClient.value?.onesignalToken];
              sendNotification(tokenIdList:tokenIdList ,heading:authContoller.user?.displayName,contents: message,image:authContoller.user?.photoURL);         

          }
          
            array.sort();
            var id = Timestamp.now().toDate().toString();
              await  firestore.collection("private_messages").doc(id).set({
              "id":id,
              "message":message,
              "name": authContoller.user?.displayName,
              "messageType":"clientBusiness",
              "replyTo":"",
              "repliedMessageId":"",
              "image":"",
              "referenceId":conversationController.selectedConversation.value?.id,
              "readBy":1,
              "chatMembers":array,
              "from":isClient?authContoller.user?.email:businessController.selectedBusiness.value?.id,
              "to":isClient?businessController.selectedBusiness.value?.id:clientController.selectedClient.value?.email,
              "createdAt":Timestamp.now()
            });
           
          } catch (e) {

            print(e);
          }
      }
       
        @override
        void onInit() {
          print(conversationController.selectedConversation.value?.id);
        messageReceiver.bindStream(getMessages());
          super.onInit();
        }
}