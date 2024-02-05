import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pos/models/product.dart';

class Debt{
  late String id;
  late String customerId = "";
  late String businessId = "";
  late String name = "";
  late String saleId;
  late double price = 0.0;
  late List<Product> products = [];
  late List productsId = [];
  late bool isPaid = false;
  late List payments = [];
  late Timestamp createdAt;

  Debt();
  Debt.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    id = documentSnapshot["id"];
    customerId = documentSnapshot["customerId"];
    businessId = documentSnapshot["businessId"];
    name = documentSnapshot["name"];
    price = documentSnapshot["price"];
    saleId = documentSnapshot["saleId"];
    productsId = documentSnapshot["productsId"];
    payments = documentSnapshot["payments"];
    isPaid = documentSnapshot["isPaid"];
    createdAt = documentSnapshot["createdAt"];
  }
}