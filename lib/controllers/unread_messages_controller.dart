import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message_model.dart';

class UnreadMessagesController{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> updateAllUnreadMessages({ messages})async{
      for (var message in messages!) {
        await firestore
              .collection("private_messages").doc(message.id).update({"readBy":2});
      }
  }
  Stream<List<Message>> getUnreadMessages({to,messageType}) {   
          return firestore
              .collection("private_messages").where("messageType",isEqualTo:messageType).where("readBy",isEqualTo: 1).where("to",isEqualTo: to).orderBy("createdAt",descending: true)
              .snapshots() 
              .asyncMap((QuerySnapshot querySnapshot) async {
            List<Message> messages = [];
            for (var element in querySnapshot.docs) {
             Message message = Message.fromDocumentSnapshot(element);
              messages.add(message);
            }
            return  messages;
          });}
   Stream<List<Message>> getUnreadMessagesWithReference({to,messageType,referenceId}) {   
          return firestore
              .collection("private_messages").where("referenceId",isEqualTo: referenceId).where("messageType",isEqualTo:messageType).where("readBy",isEqualTo: 1).where("to",isEqualTo: to).orderBy("createdAt",descending: true)
              .snapshots() 
              .asyncMap((QuerySnapshot querySnapshot) async {
            List<Message> messages = [];
            for (var element in querySnapshot.docs) {
             Message message = Message.fromDocumentSnapshot(element);
              messages.add(message);
            }
            return  messages;
          });}

           Stream<List<Message>> getUnreadMessagesWithReferenceAndFrom({to,from, messageType,referenceId}) {   
          return firestore
              .collection("private_messages").where("referenceId",isEqualTo: referenceId).where("messageType",isEqualTo:messageType).where("readBy",isEqualTo: 1).where("to",isEqualTo: to).where("from",isEqualTo: from).orderBy("createdAt",descending: true)
              .snapshots() 
              .asyncMap((QuerySnapshot querySnapshot) async {
            List<Message> messages = [];
            for (var element in querySnapshot.docs) {
             Message message = Message.fromDocumentSnapshot(element);
              messages.add(message);
            }
            return  messages;
          });}
}