import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pos/models/client.dart';
import 'package:pos/models/product.dart';

class Sale{

  late String id;
  late String productId;
  late String staffId;
  late String registerId;
  late double productAmount;
  late double totalAmount;
  late double totalPrice;
  late double buyingPrice;
  late double price;
  late double amount;


  late Product product;
  late String customerId;
  late Timestamp createdAt;

  
  Sale();
  Sale.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    id = documentSnapshot["id"];
    productId = documentSnapshot["productId"];
    staffId = documentSnapshot["staffId"];
    amount = documentSnapshot["amount"];
    customerId = documentSnapshot["customerId"];
    price = documentSnapshot["price"];
    totalPrice = documentSnapshot["totalPrice"];
    buyingPrice = documentSnapshot["buyingPrice"];
    createdAt = documentSnapshot["createdAt"];
  }
}