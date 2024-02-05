import 'package:cloud_firestore/cloud_firestore.dart';

class Payout{
  late String id;
  late String customerId = "";
  late String businessId = "";
  late String saleId;
  late String name = "";
  late double price = 0.0;
  late List productsId = [];
  late List payments = [];
  late bool isPaid = false;
  late Timestamp createdAt;

  Payout();
  Payout.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    id = documentSnapshot["id"];
    customerId = documentSnapshot["customerId"];
    businessId = documentSnapshot["businessId"];
    name = documentSnapshot["name"];
    saleId = documentSnapshot["saleId"];
    productsId = documentSnapshot["productsId"];
    payments = documentSnapshot["payments"];
    isPaid = documentSnapshot["isPaid"];
    price = documentSnapshot["price"];
    createdAt = documentSnapshot["createdAt"];
  }
}