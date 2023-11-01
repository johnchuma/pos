// ignore_for_file: avoid_print
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/clients_controller.dart';
import 'package:pos/controllers/unread_messages_controller.dart';
import 'package:pos/models/conversation.dart';

class ConversationController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
    AuthController authContoller = Get.find<AuthController>();
    BusinessController businessController= Get.find<BusinessController>();
        Rx<List<Conversation?>> conversationReceiver = Rx<List<Conversation?>>([]);
        List<Conversation?> get conversations => conversationReceiver.value;
       Rx<bool> fetching =  Rx<bool>(false);
         String? userId;
       
         ConversationController();
        Rx<Conversation?> selectedConversation = Rx<Conversation?>(null);
        Stream<List<Conversation>> getConversationsAsBusiness() {
          return firestore
              .collection("conversations").where("to",isEqualTo: businessController.selectedBusiness.value?.id).orderBy("createdAt",descending: true)
              .snapshots() 
              .asyncMap((QuerySnapshot querySnapshot) async {
            List<Conversation> conversations = [];
            for (var element in querySnapshot.docs) {
             Conversation conversation = Conversation.fromDocumentSnapshot(element);
             conversation.unreadMessages.bindStream(UnreadMessagesController().getUnreadMessagesWithReference(messageType: "clientBusiness",to: businessController.selectedBusiness.value?.id,referenceId: conversation.id));
             conversation.client = await ClientsController().getClient(conversation.from);
             conversation.business = await BusinessController().getBusiness(conversation.to);
             conversations.add(conversation);
            }
            return  conversations;
          });
        }

Stream<List<Conversation>> getConversationsAsClient() {
          return firestore
              .collection("conversations").where("from",isEqualTo: authContoller.user?.email).orderBy("createdAt",descending: true)
              .snapshots() 
              .asyncMap((QuerySnapshot querySnapshot) async {
            List<Conversation> conversations = [];
            for (var element in querySnapshot.docs) {
             Conversation conversation = Conversation.fromDocumentSnapshot(element);
             conversation.unreadMessages.bindStream(UnreadMessagesController().getUnreadMessagesWithReference(messageType: "clientBusiness",to: authContoller.user?.email,referenceId: conversation.id));
             conversation.client = await ClientsController().getClient(conversation.from);
             conversation.business = await BusinessController().getBusiness(conversation.to);
              conversations.add(conversation);
            }
            return  conversations;
          });
        }
Future<void> deleteConversation(id) async {
  try {
    await firestore.collection("private_conversations").doc(id).delete();
  } catch (e) {
    Get.snackbar("Error", e.toString(), backgroundColor: Colors.grey);
  }
}
    


      Future createClientBusinessConversation ()async{
          try {
            Conversation? conversation  = await getConversation();
            if(conversation == null){
                var id = Timestamp.now().toDate().toString();
            var ids = [authContoller.user?.email,businessController.selectedBusiness.value?.id];
            ids.sort();
              await  firestore.collection("conversations").doc(id).set({
              "id":id,
              "type":"clientBusiness",
              "from":authContoller.user?.email,
              "to":businessController.selectedBusiness.value?.id,
              "ids":ids,
              "createdAt":Timestamp.now()
            });
             return await getConversation();
            }
            return conversation;
          } catch (e) {
            print(e);
          }
      }
       
        Future getConversation ()async{
          try {
            var ids = [authContoller.user?.email,businessController.selectedBusiness.value?.id];
            ids.sort();
            QuerySnapshot querySnapshot =  await  firestore.collection("conversations").where("ids",isEqualTo: ids).get();
            Conversation? conversation = null;
            for (var doc in querySnapshot.docs) {
              conversation = Conversation.fromDocumentSnapshot(doc);
            }
            return conversation;
          } catch (e) {
            print(e);
          }
      }
        @override
        void onInit() {
        
         
         conversationReceiver.bindStream(getConversationsAsClient());
         
          super.onInit();
        }
}