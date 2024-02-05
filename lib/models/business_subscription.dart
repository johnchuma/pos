import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessSubscription{
  late String businessId;
  late double amount;
  late Timestamp expiresAt;
  late Timestamp createdAt;
  int paidDays(){
    return ((amount * 31)/15000).round();
  }
  int remainedDays(){
    int days = createdAt.toDate().add(Duration(days: paidDays())).difference(DateTime.now()).inDays;
      return days<0?0:days; 
  }
  BusinessSubscription();
  BusinessSubscription.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
   businessId = documentSnapshot["businessId"];
   amount = documentSnapshot["amount"];
   expiresAt = documentSnapshot["expiresAt"];
   createdAt = documentSnapshot["createdAt"];
  }
}