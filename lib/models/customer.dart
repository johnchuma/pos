import 'package:cloud_firestore/cloud_firestore.dart';

class Customer{
  late String id;
  late String name = "";
  late String image = "";
  late String businessId = "";
  late String email = "";
  late String phone ="";
  late String address ="";
  late Timestamp createdAt;

  Customer();
  Customer.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    id = documentSnapshot["id"];
    name = documentSnapshot["name"];
    image = documentSnapshot["image"];
    businessId = documentSnapshot["businessId"];
    email = documentSnapshot["email"];
    phone = documentSnapshot["phone"];
    address = documentSnapshot["address"];
    createdAt = documentSnapshot["createdAt"];
  }
}