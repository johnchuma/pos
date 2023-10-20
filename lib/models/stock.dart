import 'package:cloud_firestore/cloud_firestore.dart';

class Stock{
  late String id;
  late double amount;
  late double buyingPrice;
  late double sellingPrice;
  late String productId;
  late Timestamp  createdAt;
  Stock();
  Stock.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    id = documentSnapshot["id"];
    amount = documentSnapshot["amount"];
    buyingPrice = documentSnapshot["buyingPrice"];
    sellingPrice = documentSnapshot["sellingPrice"];
    productId = documentSnapshot["productId"];
    createdAt= documentSnapshot["createdAt"];
  }
}