import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessSubscription{
  late String businessId;
  late double amount;
  late Timestamp expiresAt;
  late Timestamp createdAt;
  BusinessSubscription();
  BusinessSubscription.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
   businessId = documentSnapshot["businessId"];
   amount = documentSnapshot["amount"];
   expiresAt = documentSnapshot["expiresAt"];
   createdAt = documentSnapshot["createdAt"];
  }
}